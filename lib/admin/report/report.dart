import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/admin/report/detailchat.dart';
import 'package:tangteevs/admin/report/user-landing.dart';
import 'package:tangteevs/chat/chat-page.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_textfield.dart';
import '../../HomePage.dart';
import '../../widgets/message-landing.dart';
import 'detail.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

final CollectionReference _report =
    FirebaseFirestore.instance.collection('report');

class _ReportPageState extends State<ReportPage> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                title: const Center(
                  child: Text(
                    'Go to User page',
                    style: TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                  ),
                ),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const MyHomePage(
                          index: 4,
                        );
                      },
                    ),
                    (_) => false,
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                title: const Center(
                    child: Text(
                  'Logout',
                  style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                      color: redColor),
                )),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  nextScreenReplaceOut(context, const LandingPage());
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                title: const Center(
                    child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: redColor,
                      fontFamily: 'MyCustomFont',
                      fontSize: 20),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: mobileBackgroundColor,
          elevation: 1,
          leadingWidth: 130,
          centerTitle: true,
          title: const Text('test'),
          leading: Container(
            padding: const EdgeInsets.all(0),
            child: Image.asset('assets/images/logo with name.png',
                fit: BoxFit.scaleDown),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: purple,
                size: 30,
              ),
              onPressed: () {
                _showModalBottomSheet(context);
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: green,
            labelColor: green,
            labelPadding: EdgeInsets.symmetric(horizontal: 30),
            unselectedLabelColor: unselected,
            labelStyle: TextStyle(
                fontSize: 20.0, fontFamily: 'MyCustomFont'), //For Selected tab
            unselectedLabelStyle: TextStyle(
                fontSize: 20.0,
                fontFamily: 'MyCustomFont'), //For Un-selected Tabs
            tabs: [
              Tab(text: 'Post'),
              Tab(text: 'Comment'),
              Tab(text: 'Chat'),
              Tab(text: 'Users'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Post(),
            Comment(),
            Chat(),
            Users(),
          ],
        ),
      ),
    );
  }
}

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: StreamBuilder(
          stream: _report.where('type', isEqualTo: 'post').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                        color: unselected,
                        width: 1,
                      ),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.00, top: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: InkWell(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: detail(
                                  postid: documentSnapshot['postid'],
                                  uid: documentSnapshot['uid'],
                                  rid: documentSnapshot['rid'],
                                  post: true,
                                  problem: documentSnapshot['problem'],
                                ),
                                withNavBar: true,
                                pageTransitionAnimation: PageTransitionAnimation
                                    .cupertino, // OPTIONAL VALUE. True by default.
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      child:
                                          Text(documentSnapshot['activityName'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'MyCustomFont',
                                                color: unselected,
                                                fontWeight: FontWeight.bold,
                                              )),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      child: Text(
                                        documentSnapshot['problem'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'MyCustomFont',
                                          color: unselected,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: Text('no data yet'),
            );
          },
        ),
// Add new users
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _create(),
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}

class Comment extends StatelessWidget {
  const Comment({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: mobileBackgroundColor,
          body: StreamBuilder(
            stream: _report.where('type', isEqualTo: 'comment').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                          color: unselected,
                          width: 1,
                        ),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.00, top: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: detail(
                                    postid: documentSnapshot['postid'],
                                    uid: documentSnapshot['uid'],
                                    rid: documentSnapshot['rid'],
                                    post: false,
                                    problem: documentSnapshot['problem'],
                                  ),
                                  withNavBar: true,
                                  pageTransitionAnimation: PageTransitionAnimation
                                      .cupertino, // OPTIONAL VALUE. True by default.
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Text(
                                            documentSnapshot['Displayname'],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'MyCustomFont',
                                              color: unselected,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Text(
                                          documentSnapshot['problem'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'MyCustomFont',
                                            color: unselected,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: Text('no data yet'),
              );
            },
          ),
          // Add new users
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => _create(),
          //   child: const Icon(Icons.add),
          // ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat),
    );
  }
}

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: StreamBuilder(
          stream: _report.where('type', isEqualTo: 'chat').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                        color: unselected,
                        width: 1,
                      ),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.00, top: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: InkWell(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: DetailChat(
                                  groupId: documentSnapshot['groupid'],
                                  groupName: documentSnapshot['Displayname'],
                                  userName: documentSnapshot['uid'],
                                  rid: documentSnapshot['rid'],
                                ),
                                withNavBar: false,
                                pageTransitionAnimation: PageTransitionAnimation
                                    .cupertino, // OPTIONAL VALUE. True by default.
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: MessagePreviewWidget(
                                        uid: documentSnapshot['uid'],
                                        messageTitle:
                                            documentSnapshot['Displayname'],
                                        messageContent:
                                            documentSnapshot['text'],
                                        messageTime:
                                            documentSnapshot['timeStamp']
                                                .toString(),
                                        timer: true,
                                        messageImage: documentSnapshot['uid'],
                                        isunread: false,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      child: Text(
                                        documentSnapshot['problem'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'MyCustomFont',
                                          color: unselected,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: Text('no data yet'),
            );
          },
        ),
// Add new users
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _create(),
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: StreamBuilder(
          stream: _report.where('type', isEqualTo: 'people').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  void _showModalBottomSheet(BuildContext context) {
                    showModalBottomSheet(
                      useRootNavigator: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                              .doc(documentSnapshot['uid'])
                                              .update({
                                            "points": FieldValue.increment(-20),
                                          });
                                          FirebaseFirestore.instance
                                              .collection('report')
                                              .doc(documentSnapshot['rid'])
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
                                              .doc(documentSnapshot['rid'])
                                              .delete();
                                          Navigator.pop(context);
                                        },
                                        child: Text('No'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return Card(
                    clipBehavior: Clip.hardEdge,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                        color: unselected,
                        width: 1,
                      ),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.00, top: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: InkWell(
                            onTap: () {
                              _showModalBottomSheet(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: UsersPreviewWidget(
                                        uid: documentSnapshot['uid'],
                                        detail: documentSnapshot['detail'],
                                        displayname:
                                            documentSnapshot['Displayname'],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: Text('no data yet'),
            );
          },
        ),

// Add new users
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _create(),
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
