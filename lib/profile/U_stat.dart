import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tangteevs/profile/pichart.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../utils/color.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';

class U_stat extends StatefulWidget {
  final String uid;
  const U_stat({Key? key, required this.uid}) : super(key: key);

  @override
  _U_statState createState() => _U_statState();
}

class _U_statState extends State<U_stat> {
  var userData = {};
  var postData = {};
  var cateData = [];
  var cusLen = [];
  var cateDataC = [];
  var colorListR = <HexColor>[];
  var postDataAll;
  var postDataMy;
  var postDataJoin;
  var catelen;
  var colorList = [];
  bool isLoading = false;

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
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnapMy = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: widget.uid)
          .get();

      var postSnapAll = await FirebaseFirestore.instance
          .collection('post')
          .where('history', arrayContains: widget.uid)
          .get();

      var cateSnap =
          await FirebaseFirestore.instance.collection('categorys').get();

      userData = userSnap.data()!;

      postDataAll = postSnapAll.size;
      postDataAll ??= 0;
      postDataMy = postSnapMy.size;
      postDataMy ??= 0;
      postDataJoin = postDataAll - postDataMy;
      if (postDataJoin < 1) {
        postDataJoin = 0;
      }

      cateData = cateSnap.docs.map((doc) => doc.data()['Category']).toList();
      colorList = cateSnap.docs.map((doc) => doc.data()['color']).toList();
      catelen = cateData.length;

      for (var i = 0; i < catelen; i++) {
        colorListR.add(HexColor(await colorList.elementAt(i)));
      }

      setState(() {});
    } catch (e) {
      // showSnackBar(
      //   context,
      //   e.toString(),
      // );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center()
        : Scaffold(
            bottomNavigationBar: null,
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: mobileSearchColor, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              toolbarHeight: MediaQuery.of(context).size.height * 0.15,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                "\t\t\t\t\tUser\nStatistics",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: purple,
                ),
              ),
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    backgroundColor: mobileBackgroundColor,
                  ))
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
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
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 15.0,
                                    top: 10,
                                  ),
                                ),
                                const Text(
                                  'User Point',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'MyCustomFont',
                                    fontWeight: FontWeight.bold,
                                    color: mobileSearchColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.84,
                                  child: Text(
                                    'No matter how many User Points you have.\nIf you receive report from other users your User Point will be reduced. And if your User Point run out your account will be banned from tungTee',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'MyCustomFont',
                                      color: mobileSearchColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                if (userData['points'] >= 80)
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      lineHeight: 15.0,
                                      percent: userData['points'] / 100,
                                      center: Text(
                                        '${userData['points']} Points',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                      trailing: const Icon(Icons.mood),
                                      barRadius: const Radius.circular(16),
                                      backgroundColor: unselected,
                                      progressColor: green,
                                    ),
                                  ),
                                if (userData['points'] < 80 &&
                                    userData['points'] >= 50)
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      lineHeight: 15.0,
                                      percent: userData['points'] / 100,
                                      center: Text(
                                        '${userData['points']} Points',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                      trailing:
                                          const Icon(Icons.sentiment_satisfied),
                                      barRadius: const Radius.circular(16),
                                      backgroundColor: unselected,
                                      progressColor: HexColor('#FFD93D'),
                                    ),
                                  ),
                                if (userData['points'] < 50 &&
                                    userData['points'] >= 30)
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      lineHeight: 15.0,
                                      percent: userData['points'] / 100,
                                      center: Text(
                                        '${userData['points']} Points',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                      trailing: const Icon(
                                          Icons.sentiment_dissatisfied),
                                      barRadius: const Radius.circular(16),
                                      backgroundColor: unselected,
                                      progressColor: HexColor('#FF8400'),
                                    ),
                                  ),
                                if (userData['points'] < 30)
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      lineHeight: 15.0,
                                      percent: userData['points'] / 100,
                                      center: Text(
                                        '${userData['points']} Points',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                      trailing: const Icon(
                                          Icons.sentiment_very_dissatisfied),
                                      barRadius: const Radius.circular(16),
                                      backgroundColor: unselected,
                                      progressColor: HexColor('#E21818'),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Card(
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                top: 10,
                              ),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Activity',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'MyCustomFont',
                                        color: mobileSearchColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'All activity: ${postDataAll.toString()}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'MyCustomFont',
                                        color: mobileSearchColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        right: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  //color: green,
                                                  border: Border(
                                                    right: BorderSide(
                                                      color: lightPurple,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.43,
                                                child: Text(
                                                  'My post: ${postDataMy.toString()}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'MyCustomFont',
                                                    color: mobileSearchColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  //color: purple,
                                                  border: Border(
                                                    left: BorderSide(
                                                      color: lightPurple,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.43,
                                                child: Text(
                                                  'Join: ${postDataJoin.toString()}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'MyCustomFont',
                                                    color: mobileSearchColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PichartRender(
                              uid: widget.uid,
                              cateData: cateData,
                              catelen: catelen,
                              colorList: colorListR),
                        ],
                      ),
                    ),
                  ),
          );
  }
}
