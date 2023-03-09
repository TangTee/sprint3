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
import '../utils/color.dart';
import '../utils/showSnackbar.dart';
import '../notification/services/local_notification_service.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    getData();
  }

  late final LocalNotificationService service;

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => GroupInfo(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    groupMember: member,
                  ))));
    }
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
                                    await service.showNotificationWithPayload(
                                        id: 0,
                                        title: widget.groupName,
                                        body:
                                            'กิจกรรมจบแล้วอย่าลืมไปรีวิวเพื่อนๆนะ',
                                        payload: 'payload navigation');
                                  }),
                                  child: const Text('Close'),
                                )
                              ],
                            ));
                  },
                  icon: const Icon(Icons.logout),
                ),
              IconButton(
                  onPressed: () {
                    nextScreen(
                        context,
                        GroupInfo(
                          groupId: widget.groupId,
                          groupName: widget.groupName,
                          groupMember: member,
                        ));
                  },
                  icon: const Icon(Icons.people)),
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
                          if (replyMessage != '') buildReply(),
                          Row(children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()),
                                );
                              },
                              child: const Icon(
                                Icons.attach_file_outlined,
                                color: purple,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.78,
                              child: Column(
                                children: [
                                  TextFormField(
                                    focusNode: focusNode,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    minLines: 1,
                                    controller: messageController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                            width: 2, color: unselected),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            width: 2, color: unselected),
                                      ),
                                      hintText: 'Send a message...',
                                      hintStyle: TextStyle(
                                        color: unselected,
                                        fontFamily: 'MyCustomFont',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                sendMessage();
                              },
                              child: const SizedBox(
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Icon(
                                  Icons.send_outlined,
                                  size: 30,
                                  color: purple,
                                )),
                              ),
                            )
                          ]),
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

  sendMessage() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 300), curve: Curves.easeOut);
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "time": DateTime.now().millisecondsSinceEpoch,
        "profile": userData['profile'].toString(),
        "image": text,
        "reply": replyMessage.toString(),
        "replyImage": replyImage,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
        replyMessage = '';
        replyImage = false;
      });
    }
  }

  sendImage() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 300), curve: Curves.easeOut);
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "time": DateTime.now().millisecondsSinceEpoch,
        "profile": userData['profile'].toString(),
        "image": image,
        "reply": replyMessage.toString(),
        "replyImage": replyImage,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  Widget bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            'Choose Profile Photo',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.camera,
                    color: lightPurple,
                  ),
                  onPressed: () async {
                    takePhoto(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  label: const Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.image,
                    color: lightPurple,
                  ),
                  onPressed: () async {
                    takePhoto(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  label: const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    XFile? file = await imagePicker.pickImage(
      source: source,
    );
    // print('${file?.path}');

    if (file == null) return;

    try {
      String getRandomString(int length) {
        const characters =
            '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
        Random random = Random();
        return String.fromCharCodes(Iterable.generate(length,
            (_) => characters.codeUnitAt(random.nextInt(characters.length))));
      }

      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('Profile');
      Reference referenceImageToUpload =
          referenceDirImages.child(getRandomString(30));
      //Store the file
      await referenceImageToUpload.putFile(File(file.path));
      //  Success: get the download URL

      messageController.text = (await referenceImageToUpload.getDownloadURL());
      sendImage();
    } catch (error) {
      //Some error occurred
    }
    setState(() {
      media = File(file.path);
    });
  }

  Widget buildReply() => Column(
        children: [
          if (imageChecker == true)
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    replyMessage.toString(),
                  ),
                  radius: 15,
                ),
                trailing: IconButton(
                  onPressed: cancelReply,
                  icon: const Icon(Icons.close),
                  iconSize: 16,
                ),
              ),
            ),
          if (imageChecker == false)
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.only(left: 10.0, right: 0),
                        child: Text(
                          'reply to: $replyMessage',
                          maxLines: 3,
                          style: const TextStyle(fontSize: 14, height: 1),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        padding: const EdgeInsets.only(right: 10.0, left: 0),
                        child: IconButton(
                          onPressed: cancelReply,
                          icon: const Icon(Icons.close),
                          iconSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
        ],
      );

  void cancelReply() {
    setState(() {
      replyMessage = '';
    });
  }
}
