import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tangteevs/feed/EditAct.dart';
import 'package:tangteevs/pickers/block_picker.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class detail extends StatefulWidget {
  String postid;
  String uid;
  String rid;
  bool post;
  String problem;
  detail(
      {Key? key,
      required this.postid,
      required this.uid,
      required this.rid,
      required this.post,
      required this.problem})
      : super(key: key);

  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<detail> {
  var postData = {};
  var userData = {};
  var commentData = {};
  var currentUser = {};
  var joinData = {};
  var history = [];
  var isJoin;
  var joinLen = 0;
  var waitingLen = 0;
  bool isLoading = false;
  bool enable = false;

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
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postid)
          .get();

      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var currentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // get comment Length
      var commentSnap = await FirebaseFirestore.instance
          .collection('comments')
          .where('postid', isEqualTo: widget.postid)
          .get();

      var joinSnap = await FirebaseFirestore.instance
          .collection('join')
          .doc(widget.postid)
          .get();

      var waitingSnap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postid)
          .get();

      waitingLen = postSnap.data()!['waiting'].length;
      joinLen = joinSnap.data()!['member'].length - 1;
      history = postSnap.data()!['history'];
      isJoin = history.every((history) {
        if (history != FirebaseAuth.instance.currentUser!.uid) {
          return true;
        } else {
          return false;
        }
      });
      postData = postSnap.data()!;
      userData = userSnap.data()!;
      currentUser = currentSnap.data()!;
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
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _comment =
      FirebaseFirestore.instance.collection('comments');
  final TextEditingController _commentController = TextEditingController();
  final commentSet = FirebaseFirestore.instance.collection('comments');

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : DismissKeyboard(
            child: MaterialApp(
              home: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: mobileBackgroundColor,
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: unselected),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  elevation: 1,
                  title: Text(
                    postData['activityName'].toString(),
                    style: const TextStyle(
                      color: mobileSearchColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('post')
                                .orderBy('timeStamp', descending: true)
                                .where('postid', isEqualTo: widget.postid)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    itemCount:
                                        (snapshot.data! as dynamic).docs.length,
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot documentSnapshot =
                                          snapshot.data!.docs[index];
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: green,
                                                  backgroundImage: NetworkImage(
                                                    userData['profile']
                                                        .toString(),
                                                  ),
                                                  radius: 25,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Text(
                                                      '\t\t' +
                                                          userData[
                                                              'Displayname'],
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            'MyCustomFont',
                                                        color:
                                                            mobileSearchColor,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Card(
                                              clipBehavior: Clip.hardEdge,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 151, 150, 150),
                                                  width: 0.5,
                                                ),
                                              ),
                                              //margin: const EdgeInsets.only(top: 15),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            top: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.62,
                                                                child: Text(
                                                                    documentSnapshot[
                                                                        'activityName'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontFamily:
                                                                          'MyCustomFont',
                                                                      color:
                                                                          mobileSearchColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                              ),
                                                              const SizedBox(
                                                                  child: Icon(Icons
                                                                      .person)),
                                                              Text.rich(TextSpan(
                                                                  children: <
                                                                      InlineSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            '\t$joinLen / ${documentSnapshot['peopleLimit']}',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontFamily:
                                                                              'MyCustomFont',
                                                                          color:
                                                                              unselected,
                                                                        )),
                                                                  ])),
                                                            ],
                                                          ),
                                                        ),
                                                        Text.rich(TextSpan(
                                                            children: <
                                                                InlineSpan>[
                                                              const TextSpan(
                                                                text: '',
                                                              ),
                                                              const WidgetSpan(
                                                                child: Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                  text:
                                                                      '${'${'\t\t' + documentSnapshot['date']}\t\t(' + documentSnapshot['time']})',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'MyCustomFont',
                                                                    color:
                                                                        unselected,
                                                                  )),
                                                            ])),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text.rich(TextSpan(
                                                                children: <
                                                                    InlineSpan>[
                                                                  const TextSpan(
                                                                    text: '',
                                                                  ),
                                                                  const WidgetSpan(
                                                                    child: Icon(
                                                                      Icons
                                                                          .maps_home_work,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                      text:
                                                                          '${'\t\t' + documentSnapshot['place']} /',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'MyCustomFont',
                                                                        color:
                                                                            unselected,
                                                                        fontSize:
                                                                            14,
                                                                      )),
                                                                ])),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                              child: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.05,
                                                                child: Row(
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Uri uri =
                                                                            Uri.parse(documentSnapshot['location']);
                                                                        _launchUrl(
                                                                            uri);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Location',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              purple,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.7,
                                                            child: const Text(
                                                                'Detail',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'MyCustomFont',
                                                                    color:
                                                                        mobileSearchColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800))),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(1),
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.4,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.04,
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.30,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        OutlinedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          style: OutlinedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                              side: BorderSide(color: HexColor(postData['tagColor']), width: 1.5)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2),
                                                                            child:
                                                                                Text(
                                                                              postData['tag'],
                                                                              style: const TextStyle(color: mobileSearchColor, fontSize: 14),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            if (FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid ==
                                                                    documentSnapshot[
                                                                        'uid'] &&
                                                                documentSnapshot[
                                                                        'open'] ==
                                                                    true)
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    if (waitingLen ==
                                                                        0)
                                                                      OutlinedButton(
                                                                        onPressed:
                                                                            null,
                                                                        style: OutlinedButton
                                                                            .styleFrom(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          side: const BorderSide(
                                                                              color: disable,
                                                                              width: 1.5),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          '0 Request',
                                                                          style: TextStyle(
                                                                              color: disable,
                                                                              fontSize: 16),
                                                                        ),
                                                                      ),
                                                                    if (waitingLen !=
                                                                        0)
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {},
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              lightGreen,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          '$waitingLen Request',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'MyCustomFont',
                                                                            color:
                                                                                unselected,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid !=
                                                                    documentSnapshot[
                                                                        'uid'] &&
                                                                documentSnapshot[
                                                                        'open'] ==
                                                                    true)
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.45,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    if (int.parse(documentSnapshot['peopleLimit']) !=
                                                                            joinLen &&
                                                                        isJoin ==
                                                                            true)
                                                                      ElevatedButton(
                                                                          style: documentSnapshot['waiting'].contains(FirebaseAuth.instance.currentUser!.uid)
                                                                              ? ElevatedButton.styleFrom(
                                                                                  backgroundColor: lightPurple,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                )
                                                                              : ElevatedButton.styleFrom(
                                                                                  backgroundColor: lightGreen,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                ),
                                                                          child: documentSnapshot['waiting'].contains(FirebaseAuth.instance.currentUser!.uid)
                                                                              ? const Text(
                                                                                  'Waiting',
                                                                                  style: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontFamily: 'MyCustomFont',
                                                                                    color: mobileBackgroundColor,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                )
                                                                              : const Text(
                                                                                  'Join',
                                                                                  style: TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontFamily: 'MyCustomFont',
                                                                                    color: unselected,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                          onPressed: () => {}),
                                                                    if (int.parse(documentSnapshot['peopleLimit']) ==
                                                                            joinLen &&
                                                                        isJoin ==
                                                                            true)
                                                                      OutlinedButton(
                                                                        onPressed:
                                                                            null,
                                                                        style: OutlinedButton
                                                                            .styleFrom(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          side: const BorderSide(
                                                                              color: disable,
                                                                              width: 1.5),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'Full',
                                                                          style: TextStyle(
                                                                              color: disable,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ),
                                                                    if (isJoin ==
                                                                        false)
                                                                      OutlinedButton(
                                                                        onPressed:
                                                                            null,
                                                                        style: OutlinedButton
                                                                            .styleFrom(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          side: const BorderSide(
                                                                              color: disable,
                                                                              width: 1.5),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'Joined',
                                                                          style: TextStyle(
                                                                              color: disable,
                                                                              fontSize: 14),
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
                                                ),
                                              )),
                                          Row(
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Text('Comment',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily:
                                                          'MyCustomFont',
                                                      color: unselected,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            ],
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: commentSet
                                                .doc(documentSnapshot['postid'])
                                                .collection('comments')
                                                .orderBy('timeStamp',
                                                    descending: true)
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                return SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.33,
                                                  child: ListView.builder(
                                                      itemCount: snapshot
                                                          .data!.docs.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final DocumentSnapshot
                                                            documentSnapshot =
                                                            snapshot.data!
                                                                .docs[index];

                                                        var postidD =
                                                            postData['postid'];

                                                        var time = timeago.format(
                                                            documentSnapshot[
                                                                    'timeStamp']
                                                                .toDate(),
                                                            locale: 'en_short');

                                                        return Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          65),
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        green,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                      documentSnapshot[
                                                                              'profile']
                                                                          .toString(),
                                                                    ),
                                                                    radius: 20,
                                                                  ),
                                                                ),
                                                                Card(
                                                                  clipBehavior:
                                                                      Clip.hardEdge,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0),
                                                                    side:
                                                                        const BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          151,
                                                                          150,
                                                                          150),
                                                                      width: 2,
                                                                    ),
                                                                  ),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 180,
                                                                              child: Text(documentSnapshot['Displayname'],
                                                                                  style: const TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontFamily: 'MyCustomFont',
                                                                                    color: mobileSearchColor,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  )),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 1),
                                                                              child: Text(time,
                                                                                  style: const TextStyle(
                                                                                    fontSize: 12,
                                                                                    fontFamily: 'MyCustomFont',
                                                                                    color: unselected,
                                                                                  )),
                                                                            ),
                                                                            IconButton(
                                                                              iconSize: 12,
                                                                              icon: const Icon(Icons.more_horiz),
                                                                              onPressed: () {},
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              250,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              documentSnapshot['comment'],
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontFamily: 'MyCustomFont',
                                                                                color: unselected,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                );
                                              }
                                              return Container(
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                            },
                                          )
                                        ],
                                      );
                                      //),
                                    });
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
                                        child: CircularProgressIndicator(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            color: mobileBackgroundColor,
                            child: Column(
                              children: [
                                SizedBox(
                                  child: widget.post
                                      ? Text(
                                          'This activity has been reported for : ' +
                                              widget.problem,
                                        )
                                      : Text(
                                          'This comment has been reported for :' +
                                              widget.problem,
                                        ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                              .doc(widget.uid)
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void _showModalBottomSheet1(BuildContext context, uid) {
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
              if (postData['uid'].toString() == uid)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: const Center(
                    child: Text(
                      'Edit Activity',
                      style:
                          TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return EditAct(
                            postid: postData['postid'],
                          );
                        },
                      ),
                      (_) => false,
                    );
                  },
                ),
              if (postData['uid'].toString() != uid)
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
                  onTap: () {},
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
