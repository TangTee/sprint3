import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tangteevs/chat/group_info.dart';
import 'package:tangteevs/services/database_service.dart';
import 'package:tangteevs/widgets/message-bubble.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../utils/color.dart';
import '../../utils/showSnackbar.dart';
import '../utils/color.dart';

class DetailChat extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final String rid;
  const DetailChat({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    required this.rid,
  }) : super(key: key);

  @override
  State<DetailChat> createState() => _DetailChatState();
}

class _DetailChatState extends State<DetailChat> {
  ImagePicker imagePicker = ImagePicker();
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  final String _ImageUrl = '';
  String admin = "";
  bool isLoading = false;
  bool text = false;
  bool image = true;
  bool replyImage = false;
  var postData = {};
  var groupData = {};
  var member = [];
  var userData = {};
  String replyMessage = '';
  bool imageChecker = false;
  final focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  File? media;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userName)
          .get();

      userData = userSnap.data()!;

      var groupSnap = await FirebaseFirestore.instance
          .collection('join')
          .doc(widget.groupId)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.groupId)
          .get();

      postData = postSnap.data()!;

      groupData = groupSnap.data()!;
      member = groupSnap.data()?['member'];

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DismissKeyboard(
        child: Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            elevation: 0,
            toolbarHeight: MediaQuery.of(context).size.height * 0.08,
            title: Text(widget.groupName),
            backgroundColor: lightPurple,
            actions: [
              if (FirebaseAuth.instance.currentUser!.uid ==
                      groupData['owner'] &&
                  postData['open'] == true)
                IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Close Activity'),
                              content: const Text(
                                  'Are you sure you want to permanently\nclose this Activity ?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancle')),
                                TextButton(
                                  onPressed: (() async {
                                    FirebaseFirestore.instance
                                        .collection('post')
                                        .doc(widget.groupId)
                                        .update({'open': false}).whenComplete(
                                            () {
                                      Navigator.pop(context);
                                    });
                                  }),
                                  child: const Text('Close'),
                                )
                              ],
                            ));
                  },
                  icon: const Icon(Icons.logout),
                ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                chatMessages(),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: replyMessage != ''
                        ? MediaQuery.of(context).size.height * 0.135
                        : MediaQuery.of(context).size.height * 0.075,
                    color: white,
                    child: Form(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          redColor, // Background color
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.userName)
                                          .update({
                                        "points": FieldValue.increment(-20),
                                      });
                                      FirebaseFirestore.instance
                                          .collection('report')
                                          .doc(widget.rid)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        fontFamily: 'MyCustomFont',
                                      ),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          unselected, // Background color
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('report')
                                          .doc(widget.rid)
                                          .delete();
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  chatMessages() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 550);
      }
    });
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('messages')
          .orderBy("time")
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SwipeTo(
                          onRightSwipe: () {
                            setState(() {
                              imageChecker = snapshot.data.docs[index]['image'];
                              replyMessage =
                                  snapshot.data.docs[index]['message'];
                              if (snapshot.data.docs[index]['image'] == true) {
                                replyImage = true;
                              }
                            });
                            focusNode.requestFocus();
                          },
                          child: MessageBubble(
                              image: snapshot.data.docs[index]['image'],
                              message: snapshot.data.docs[index]['message'],
                              sender: snapshot.data.docs[index]['sender'],
                              profile: snapshot.data.docs[index]['profile'],
                              reply: snapshot.data.docs[index]['reply'],
                              replyImage: snapshot.data.docs[index]
                                  ['replyImage'],
                              groupid: widget.groupId,
                              time:
                                  snapshot.data.docs[index]['time'].toString(),
                              sentByMe:
                                  FirebaseAuth.instance.currentUser!.uid ==
                                      snapshot.data.docs[index]['sender']),
                        ),
                        // MessageTime(
                        //   image: snapshot.data.docs[index]['image'],
                        //   time: snapshot.data.docs[index]['time'].toString(),
                        //   sentByMe: FirebaseAuth.instance.currentUser!.uid ==
                        //       snapshot.data.docs[index]['sender'],
                        // ),
                      ],
                    );
                  },
                ),
              )
            : Container();
      },
    );
  }
}
