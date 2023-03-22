import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  var currentUData = {};
  var member = [];
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  double rating2 = 1;
  final _reviewController = TextEditingController();
  final _review = FirebaseFirestore.instance.collection('reviews').doc();
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

      var currentUSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      postData = postSnap.data()!;
      groupData = groupSnap.data()!;
      currentUData = currentUSnap.data()!;
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : MaterialApp(
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
                                          onPressed: (() {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title:
                                                          const Text('Review'),
                                                      content: Form(
                                                        key: _formKey,
                                                        child: Column(
                                                          children: [
                                                            RatingBar.builder(
                                                              initialRating: 1,
                                                              minRating: 1,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          4.0),
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {
                                                                if (rating !=
                                                                    0) {
                                                                  rating2 =
                                                                      rating;
                                                                }
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.16,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 0),
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.90,
                                                                  child:
                                                                      TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    maxLines: 3,
                                                                    controller:
                                                                        _reviewController,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        // _enteredTextD = value;
                                                                        // if (value.length > 25) {
                                                                        //   TextD = redColor;
                                                                        // } else {
                                                                        //   TextD = mobileSearchColor;
                                                                        // }
                                                                      });
                                                                    },
                                                                    decoration:
                                                                        textInputDecoration
                                                                            .copyWith(
                                                                      labelStyle:
                                                                          const TextStyle(
                                                                        color:
                                                                            mobileSearchColor,
                                                                        fontFamily:
                                                                            "MyCustomFont",
                                                                      ),
                                                                      hintText:
                                                                          'write review here',
                                                                      // counterText:
                                                                      //     '${_enteredTextD.length.toString()} /150',
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return 'Please write review';
                                                                      }
                                                                      if (value
                                                                              .length >
                                                                          150) {
                                                                        return 'Limit at 150 characters ';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: const Text(
                                                                'Cancle')),
                                                        TextButton(
                                                            onPressed:
                                                                (() async {
                                                              if (_formKey
                                                                      .currentState!
                                                                      .validate() ==
                                                                  true) {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                });
                                                                await _review
                                                                    .set({
                                                                  'reviewId':
                                                                      _review
                                                                          .id,
                                                                  'uid':
                                                                      documentSnapshot[
                                                                          'uid'],
                                                                  'review':
                                                                      _reviewController
                                                                          .text,
                                                                  'rating':
                                                                      rating2,
                                                                  'reviewerId':
                                                                      currentUData[
                                                                          'uid'],
                                                                  'timeStamp':
                                                                      DateTime
                                                                          .now(),
                                                                }).whenComplete(
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {
                                                                    _reviewController
                                                                        .clear();
                                                                    isLoading =
                                                                        false;
                                                                    // enable =
                                                                    //     false;
                                                                  });
                                                                });
                                                              }
                                                            }),
                                                            child: const Text(
                                                                'Save'))
                                                      ],
                                                    ));
                                          }),
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
                                  'Save',
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
