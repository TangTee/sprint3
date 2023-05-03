import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tangteevs/widgets/tag.dart';

import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import '../utils/color.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';

class Review extends StatefulWidget {
  final List member;
  final String groupName;
  const Review({
    Key? key,
    required this.member,
    required this.groupName,
  }) : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final user = FirebaseAuth.instance.currentUser!.uid;
  List member_R = [];
  bool isLoading = false;
  var current;
  final _reviewKey = GlobalKey<FormState>();
  double rating2 = 1;
  final _reviewController = TextEditingController();
  final _review = FirebaseFirestore.instance.collection('reviews').doc();

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
      member_R = widget.member;

      // var groupSnap = await FirebaseFirestore.instance
      //     .collection('users')
      //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser)
      //     .get();

      // member_R = groupSnap.data()?['member'];
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      member_R.remove(user);
      member_R.add('empty');
      isLoading = false;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
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
                  backgroundColor: mobileBackgroundColor,
                  toolbarHeight: MediaQuery.of(context).size.height * 0.13,
                  centerTitle: true,
                  elevation: 0,
                  title: const Text(
                    "Review List",
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: purple,
                    ),
                  ),
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(-20),
                    child: Text("รีวิวเพื่อนในกิจกรรมที่เข้าร่วม",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: unselected)),
                  ),
                ),
                body: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: mobileBackgroundColor,
                      ))
                    : Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('หน้านี้สามารถเข้าได้แค่ครั้งเดียวเท่านั้น',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: redColor)),
                            ],
                          ),
                          memberList(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                width:
                                    350, //MediaQuery.of(context).size.width * 2.0,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      backgroundColor: green),
                                  onPressed: () {
                                    int count = 0;
                                    Navigator.of(context)
                                        .popUntil((_) => count++ >= 2);
                                  },
                                  child: const Text(
                                    "Finish",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'MyCustomFont'),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          );
  }

  memberList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: member_R)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SafeArea(
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
                                          documentSnapshot['profile']
                                              .toString(),
                                        ),
                                        radius: 25,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                          ],
                                        ),
                                      ),
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
                                                        key: _reviewKey,
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
                                                                          () {});
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
                                                              if (_reviewKey
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
                                                                  'groupName':
                                                                      widget
                                                                          .groupName,
                                                                  'reviewerId':
                                                                      user,
                                                                  'timeStamp':
                                                                      DateTime
                                                                          .now(),
                                                                }).whenComplete(
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {
                                                                    member_R.remove(
                                                                        documentSnapshot[
                                                                            'uid']);
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
