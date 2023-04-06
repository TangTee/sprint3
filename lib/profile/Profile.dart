import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/admin/home.dart';
import 'package:tangteevs/profile/edit.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:age_calculator/age_calculator.dart';
import '../widgets/PostCard.dart';
import '../widgets/ReviewCard.dart';
import '../widgets/custom_textfield.dart';
import 'U_stat.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  var postLen = 0;
  bool isLoading = false;

  String y = "";
  String m = "";
  String d = "";
  DateTime birthday = DateTime(1);
  DateDuration duration = DateDuration();
  int _count = 0;

  void _incrementCount() {
    setState(() {
      _count++;
    });
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
          .doc(widget.uid)
          .get();

      // get post Length
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;

      y = userData['year'].toString();
      m = userData['month'].toString();
      d = userData['day'].toString();
      var yy = int.parse(y);
      var mm = int.parse(m);
      var dd = int.parse(d);
      DateTime birthday = DateTime(yy, mm, dd);
      duration = AgeCalculator.age(birthday);

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

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (userData['admin'] == true)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: const Center(
                    child: Text(
                      'Go to admin page',
                      style:
                          TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const AdminHomePage();
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
                      'Edit Profile',
                      style:
                          TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPage(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: const Center(
                    child: Text(
                      'User statistics',
                      style:
                          TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => U_stat(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
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
    final post = FirebaseFirestore.instance
        .collection('post')
        .orderBy('timeStamp', descending: true);

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : DismissKeyboard(
            child: MaterialApp(
              home: Scaffold(
                bottomNavigationBar: null,
                backgroundColor: mobileBackgroundColor,
                appBar: AppBar(
                  leading:
                      userData['uid'] != FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: unselected),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          : Container(),
                  backgroundColor: mobileBackgroundColor,
                  title: Text(
                    userData['Displayname'].toString(),
                    style:
                        const TextStyle(color: mobileSearchColor, fontSize: 24),
                  ),
                  centerTitle: true,
                  actions: [
                    if (userData['uid'] ==
                        FirebaseAuth.instance.currentUser!.uid)
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
                ),
                body: SafeArea(
                  child: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: green,
                                backgroundImage: NetworkImage(
                                  userData['profile'].toString(),
                                ),
                                radius: 60,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        top: 1,
                                        left: 30,
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          text: 'อายุ ${duration.years} ปี',
                                          style: const TextStyle(
                                            fontFamily: 'MyCustomFont',
                                            color: unselected,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 30,
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          text: 'เพศ ${userData['gender']}',
                                          style: const TextStyle(
                                            fontFamily: 'MyCustomFont',
                                            color: unselected,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 30,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            userData['bio'].toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: unselected,
                                              fontFamily: 'MyCustomFont',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 30,
                                      ),
                                      child: (userData['instagram']
                                                  .toString() !=
                                              '')
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      Uri uri = Uri.parse(
                                                          "https://www.instagram.com/${userData['instagram']}"); //https://www.instagram.com/
                                                      _launchUrl(uri);
                                                    },
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 0,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Image.asset(
                                                        'assets/images/instagram.png'),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                  child: (userData['facebook']
                                                              .toString() !=
                                                          '')
                                                      ? MaterialButton(
                                                          onPressed: () {
                                                            Uri uri = Uri.parse(
                                                                userData[
                                                                        'facebook']
                                                                    .toString()); //https://www.facebook.com/
                                                            _launchUrl(uri);
                                                          },
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 0,
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Image.asset(
                                                              'assets/images/facebook.png'),
                                                        )
                                                      : Container(),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              child: (userData['facebook']
                                                          .toString() !=
                                                      '')
                                                  ? MaterialButton(
                                                      onPressed: () {
                                                        Uri uri = Uri.parse(
                                                            userData['facebook']
                                                                .toString()); //https://www.facebook.com/
                                                        _launchUrl(uri);
                                                      },
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 0,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Image.asset(
                                                          'assets/images/facebook.png'),
                                                    )
                                                  : Container(),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: 0,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: const TabBar(
                                  indicatorColor: green,
                                  labelColor: green,
                                  labelPadding:
                                      EdgeInsets.symmetric(horizontal: 60),
                                  unselectedLabelColor: unselected,
                                  labelStyle: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily:
                                          'MyCustomFont'), //For Selected tab
                                  unselectedLabelStyle: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily:
                                          'MyCustomFont'), //For Un-selected Tabs
                                  tabs: [
                                    Tab(text: 'Post'),
                                    Tab(text: 'Review'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.613,
                                child: TabBarView(children: <Widget>[
                                  Container(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('post')
                                          .where('uid', isEqualTo: widget.uid)
                                          .orderBy('timeStamp',
                                              descending: true)
                                          .snapshots(),
                                      builder: ((context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                              itemCount:
                                                  (snapshot.data! as dynamic)
                                                      .docs
                                                      .length,
                                              itemBuilder: (context, index) =>
                                                  Container(
                                                    child: CardWidget(
                                                        snap: (snapshot.data!
                                                                as dynamic)
                                                            .docs[index]),
                                                  ));
                                        }
                                        return Container(
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const <Widget>[
                                                SizedBox(
                                                  height: 30.0,
                                                  width: 30.0,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Container(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('reviews')
                                          .where('uid', isEqualTo: widget.uid)
                                          .orderBy('timeStamp',
                                              descending: true)
                                          .snapshots(),
                                      builder: ((context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                              itemCount:
                                                  (snapshot.data! as dynamic)
                                                      .docs
                                                      .length,
                                              itemBuilder: (context, index) =>
                                                  Container(
                                                    child: CardRWidget(
                                                        review: (snapshot.data!
                                                                as dynamic)
                                                            .docs[index]),
                                                  ));
                                        }
                                        return Container(
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const <Widget>[
                                                SizedBox(
                                                  height: 30.0,
                                                  width: 30.0,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ]),
                              )
                            ]),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (_) {}
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
