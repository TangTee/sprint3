import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tangteevs/feed/EditAct.dart';
import 'package:tangteevs/utils/showSnackbar.dart';
import 'package:tangteevs/widgets/like.dart';
import 'package:url_launcher/url_launcher.dart';
import '../HomePage.dart';
import '../Report.dart';
import '../comment/comment.dart';
import '../utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'TagResult.dart';

class CardWidget extends StatefulWidget {
  final snap;
  const CardWidget({super.key, required this.snap});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<CardWidget> {
  var postData = {};
  var userData = {};
  var currentUser = {};
  var joinLen = 0;
  bool isLoading = false;
  var member = [];
  var joinData = {};
  var isJoin;
  var history = [];
  var waitingLen = 0;

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
          .doc(widget.snap['postid'])
          .get();

      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap['uid'])
          .get();

      var currentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // get post Length
      var joinSnap = await FirebaseFirestore.instance
          .collection('join')
          .doc(widget.snap['postid'])
          .get();

      joinLen = joinSnap.data()!['member'].length - 1;
      postData = postSnap.data()!;
      userData = userSnap.data()!;
      currentUser = currentSnap.data()!;
      joinData = joinSnap.data()!;
      member = joinSnap.data()?['member'];
      waitingLen = postSnap.data()!['waiting'].length;
      history = postSnap.data()!['history'];
      isJoin = history.every((history) {
        if (history != FirebaseAuth.instance.currentUser!.uid) {
          return true;
        } else {
          return false;
        }
      });
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _post =
      FirebaseFirestore.instance.collection('post');
  final CollectionReference _join =
      FirebaseFirestore.instance.collection('join');

  Future<void> post_delete(String postid) async {
    await _post.doc(postid).delete();
    _join.doc(postid).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a post activity')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
              color: unselected,
              width: 2,
            ),
          ),
          margin: const EdgeInsets.all(15),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.00),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(widget.snap['activityName'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'MyCustomFont',
                                color: unselected,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        if (widget.snap['open'] == true)
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: IconButton(
                              icon: widget.snap['likes'].contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: redColor,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      size: 30,
                                    ),
                              onPressed: () => likePost(
                                widget.snap['postid'].toString(),
                                FirebaseAuth.instance.currentUser!.uid,
                                widget.snap['likes'],
                              ),
                            ),
                          ),
                        if (widget.snap['open'] == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: SizedBox(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: unselected,
                                  size: 30,
                                ),
                                onPressed: (() {
                                  //add action
                                  _showModalBottomSheet(
                                      context, currentUser['uid']);
                                }),
                              ),
                            ),
                          ),
                        if (widget.snap['open'] == false)
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: SizedBox(
                              child: Icon(
                                Icons.favorite,
                                color: white,
                                size: 30,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          const TextSpan(
                            text: '',
                          ),
                          const WidgetSpan(
                            child: Icon(
                              Icons.calendar_today,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${'${'\t\t' + widget.snap['date']}\t(' + widget.snap['time']})',
                            style: const TextStyle(
                              fontFamily: 'MyCustomFont',
                              color: unselected,
                              fontSize: 14,
                            ),
                          ),
                          FirebaseAuth.instance.currentUser!.uid ==
                                      widget.snap['uid'] &&
                                  widget.snap['open'] == true
                              ? waitingLen != 0
                                  ? const TextSpan(
                                      text: '\t\tNew Request',
                                      style: TextStyle(
                                        fontFamily: 'MyCustomFont',
                                        color: purple,
                                        fontSize: 14,
                                      ),
                                    )
                                  : const TextSpan()
                              : isJoin == false &&
                                      joinLen.toString() !=
                                          widget.snap['peopleLimit']
                                  ? const TextSpan(
                                      text: '\t\tJoined',
                                      style: TextStyle(
                                        fontFamily: 'MyCustomFont',
                                        color: green,
                                        fontSize: 14,
                                      ),
                                    )
                                  : const TextSpan(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(
                                text: '',
                              ),
                              const WidgetSpan(
                                child: Icon(
                                  Icons.maps_home_work,
                                ),
                              ),
                              TextSpan(
                                text: '${'\t\t' + widget.snap['place']} /',
                                style: const TextStyle(
                                  fontFamily: 'MyCustomFont',
                                  color: unselected,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Uri uri =
                                        Uri.parse(widget.snap['location']);
                                    _launchUrl(uri);
                                  },
                                  child: const Text(
                                    'Location',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(
                                text: '',
                              ),
                              const WidgetSpan(
                                child: Icon(
                                  Icons.person_outline,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\t\t$joinLen / ${widget.snap['peopleLimit']}',
                                style: const TextStyle(
                                  fontFamily: 'MyCustomFont',
                                  color: unselected,
                                  fontSize: 14,
                                ),
                              ),
                              if (joinLen.toString() ==
                                  widget.snap['peopleLimit'])
                                const TextSpan(
                                  text: '\t\tFull',
                                  style: TextStyle(
                                    fontFamily: 'MyCustomFont',
                                    color: redColor,
                                    fontSize: 14,
                                  ),
                                ),
                              if (FirebaseAuth.instance.currentUser!.uid !=
                                      widget.snap['uid'] &&
                                  widget.snap['open'] == true &&
                                  joinLen ==
                                      int.parse(widget.snap['peopleLimit']) - 1)
                                const TextSpan(
                                  text: '\t\t1 Last place',
                                  style: TextStyle(
                                    fontFamily: 'MyCustomFont',
                                    color: redColor,
                                    fontSize: 14,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: Row(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: SizedBox(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => TagResult(
                                                Tag: widget.snap['tag']
                                                    .toString()),
                                          ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          side: BorderSide(
                                              color: HexColor(
                                                  widget.snap['tagColor']),
                                              width: 1.5)),
                                      child: Text(
                                        widget.snap['tag'],
                                        style: const TextStyle(
                                            color: mobileSearchColor,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Comment(postid: widget.snap),
                                    ),
                                  )
                                      .whenComplete(() {
                                    setState(() {
                                      isLoading == true;
                                    });
                                    getData();
                                  });
                                },
                                child: const Text(
                                  'See More >>',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'MyCustomFont',
                                    color: green,
                                    fontWeight: FontWeight.bold,
                                  ),
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
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, uid) {
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
              if (postData['open'] == true && postData['uid'].toString() == uid)
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
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: EditAct(
                        postid: widget.snap['postid'],
                      ),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  },
                ),
              if (postData['uid'].toString() == uid)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: const Center(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontFamily: 'MyCustomFont',
                          fontSize: 20,
                          color: redColor),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Delete Activity'),
                              content: const Text(
                                  'Are you sure you want to permanently\nremove this Activity from Tungtee?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancle')),
                                TextButton(
                                    onPressed: (() {
                                      FirebaseFirestore.instance
                                          .collection('post')
                                          .doc(widget.snap['postid'])
                                          .delete()
                                          .whenComplete(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage(
                                              index: 0,
                                            ),
                                          ),
                                        );
                                      });
                                      FirebaseFirestore.instance
                                          .collection('join')
                                          .doc(widget.snap['postid'])
                                          .delete()
                                          .whenComplete(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage(
                                              index: 0,
                                            ),
                                          ),
                                        );
                                      });
                                    }),
                                    child: const Text('Delete'))
                              ],
                            ));
                  },
                ),
              if (postData['open'] == false &&
                  postData['uid'].toString() != uid)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  title: const Center(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          fontFamily: 'MyCustomFont',
                          fontSize: 20,
                          color: redColor),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Delete Activity'),
                              content: const Text(
                                  'Are you sure you want to permanently\nremove this Activity from Tungtee?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancle')),
                                TextButton(
                                    onPressed: (() {
                                      FirebaseFirestore.instance
                                          .collection('post')
                                          .doc(widget.snap['postid'])
                                          .update({
                                        'history': FieldValue.arrayUnion([uid])
                                      }).whenComplete(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage(
                                              index: 0,
                                            ),
                                          ),
                                        );
                                      });
                                    }),
                                    child: const Text('Delete'))
                              ],
                            ));
                  },
                ),
              if (postData['open'] == true && postData['uid'].toString() != uid)
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
                    return showModalBottomSheetRP(context, postData);
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
