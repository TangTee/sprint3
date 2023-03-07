import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tangteevs/chat/chat-page.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/color.dart';
import '../widgets/message-landing.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key? key}) : super(key: key);

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  var userData = {};
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  final bool _isLoading = false;
  final CollectionReference _join =
      FirebaseFirestore.instance.collection('join');

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    // gettingUserData();
  }

  // string manipulation
  // String getId(String res) {
  //   return res.substring(0, res.indexOf("_"));
  // }

  // String getName(String res) {
  //   return res.substring(res.indexOf("_") + 1);
  // }

  // gettingUserData() async {
  //   await HelperFunctions.getUserDisplayFromSF().then((val) {
  //     setState(() {
  //       userName = val!;
  //     });
  //   });
  //   // getting the list of snapshots in our stream
  //   await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
  //       .getUserGroups()
  //       .then((snapshot) {
  //     setState(() {
  //       groups = snapshot;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        elevation: 1,
        leadingWidth: 130,
        centerTitle: false,
        leading: Container(
          padding: const EdgeInsets.only(left: 13),
          child: Image.asset(
            'assets/images/logo with name.png',
            width: MediaQuery.of(context).size.width * 0.31,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: purple,
              size: 30,
            ),
            onPressed: () {
              // print((FirebaseAuth.instance.currentUser!.uid));
            },
          )
        ],
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Groups",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      )),
      body: groupList(),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: _join
          .where('member',
              arrayContains: FirebaseAuth.instance.currentUser!.uid)
          // .orderBy('recentMessageTime', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      // Unread(
                      //   documentSnapshot['groupid'].toString(),
                      //   DateTime.now().millisecondsSinceEpoch.toString(),
                      //   documentSnapshot['unread'],
                      // );
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: ChatPage(
                          groupId: documentSnapshot['groupid'],
                          userName: FirebaseAuth.instance.currentUser!.uid,
                          groupName: documentSnapshot['groupName'],
                        ),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation
                            .cupertino, // OPTIONAL VALUE. True by default.
                      );
                    },
                    child: MessagePreviewWidget(
                      uid: documentSnapshot['recentMessageUID'],
                      messageTitle: documentSnapshot['groupName'],
                      messageContent: documentSnapshot['recentMessage'],
                      messageTime:
                          documentSnapshot['recentMessageTime'].toString(),
                      timer: documentSnapshot['recentMessageTime'] == '',
                      messageImage: documentSnapshot['owner'],
                      isunread: documentSnapshot['recentMessageUID'] ==
                          FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                ),
              ); // GroupTile(
              // groupId: (snapshot.data["groupid"]),
              // groupName: (snapshot.data['groupName']),
              // member: snapshot.data['member']);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
            height: 20,
          ),
          Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
