import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tangteevs/Landing.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_textfield.dart';
import '../../HomePage.dart';
import 'Comment-report.dart';
import 'Post-report.dart';
import 'detail.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

final CollectionReference _report =
    FirebaseFirestore.instance.collection('report');

class _ReportPageState extends State<ReportPage> {
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
      length: 2,
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
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Post(),
            Comment(),
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
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: detail(
                            postid: documentSnapshot['postid'],
                            uid: documentSnapshot['uid'],
                            rid: documentSnapshot['rid'],
                          ),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation
                              .cupertino, // OPTIONAL VALUE. True by default.
                        );
                      },
                      child: ListTile(
                        title: Text(documentSnapshot['activityName']),
                        subtitle: Text(documentSnapshot['problem']),
                        trailing: const SingleChildScrollView(
                          child: SizedBox(
                            width: 100,
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
    return Scaffold(
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
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: detail(
                            postid: documentSnapshot['postid'],
                            uid: documentSnapshot['uid'],
                            rid: documentSnapshot['rid'],
                          ),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation
                              .cupertino, // OPTIONAL VALUE. True by default.
                        );
                      },
                      child: ListTile(
                        title: Text(documentSnapshot['Displayname']),
                        subtitle: Text(documentSnapshot['problem']),
                        trailing: const SingleChildScrollView(
                          child: SizedBox(
                            width: 100,
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
