import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tangteevs/profile/Profile.dart';
import 'package:flutter/material.dart';

import '../utils/color.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final List groupMember;

  const GroupInfo({
    Key? key,
    required this.groupName,
    required this.groupId,
    required this.groupMember,
  }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  var groupData = {};
  var postData = {};
  var member = [];
  bool isLoading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
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
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: lightPurple,
            title: Text(widget.groupName),
          ),
          body: SafeArea(
            child: memberList(),
          ),
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: widget.groupMember)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];
              return SafeArea(
                child: Container(
                  color: mobileBackgroundColor,
                  height: MediaQuery.of(context).size.height * 0.08,
                  margin: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 20,
                  ),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: ProfilePage(
                              uid: documentSnapshot['uid'],
                            ),
                            withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                          );
                        },
                        child: SafeArea(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: green,
                                      backgroundImage: NetworkImage(
                                        documentSnapshot['profile'].toString(),
                                      ),
                                      radius: 25,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.56,
                                      child: Row(
                                        children: [
                                          Text(
                                            documentSnapshot['Displayname'],
                                            style: const TextStyle(
                                              color: mobileSearchColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          if (documentSnapshot['uid'] ==
                                              groupData['owner'])
                                            const Text(
                                              '[Host]',
                                              style: TextStyle(
                                                color: unselected,
                                                fontSize: 14,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (postData['open'] == false &&
                                        documentSnapshot['uid'] !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                      SizedBox(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.rate_review,
                                            color: unselected,
                                            size: 30,
                                          ),
                                          onPressed: (() {}),
                                        ),
                                      ),
                                    if (documentSnapshot['uid'] !=
                                        FirebaseAuth.instance.currentUser!.uid)
                                      SizedBox(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.more_horiz,
                                            color: unselected,
                                            size: 30,
                                          ),
                                          onPressed: (() {
                                            //add action
                                            return _showModalBottomSheetP(
                                                context,
                                                documentSnapshot,
                                                groupData);
                                          }),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }
}

void _showModalBottomSheetP(
    BuildContext context, DocumentSnapshot<Object?> userData, groupdata) {
  final report = FirebaseFirestore.instance.collection('report').doc();
  final TextEditingController ReportController = TextEditingController();

  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    )),
    builder: (BuildContext context) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (FirebaseAuth.instance.currentUser!.uid != userData['uid'])
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                title: const Center(
                    child: Text(
                  'Report',
                  style: TextStyle(
                      color: redColor,
                      fontFamily: 'MyCustomFont',
                      fontSize: 20),
                )),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Report Information'),
                            content: Form(
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                controller: ReportController,
                                decoration: textInputDecorationp.copyWith(
                                  hintText: 'Describe Problems',
                                ),
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "plase Enter comment";
                                  }
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .popUntil((route) => route.isFirst),
                                  child: const Text('Cancle')),
                              TextButton(
                                onPressed: (() {
                                  report.set({
                                    'rid': report.id,
                                    'detail': ReportController.text,
                                    'uid': userData['uid'],
                                    'profile': userData['profile'],
                                    'Displayname': userData['Displayname'],
                                    'type': 'people',
                                    'reportBy':
                                        FirebaseAuth.instance.currentUser?.uid,
                                    'timeStamp': FieldValue.serverTimestamp(),
                                  }).whenComplete(() {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  });
                                }),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: redColor,
                                  ),
                                ),
                              )
                            ],
                          ));
                },
              ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              title: const Center(
                  child: Text(
                'Cancel',
                style: TextStyle(
                    color: redColor, fontFamily: 'MyCustomFont', fontSize: 20),
              )),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
