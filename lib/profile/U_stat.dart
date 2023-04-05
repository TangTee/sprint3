import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
  var cateDataC = [];
  var statData = {};
  var postDataAll;
  var postDataMy;
  var postDataJoin;
  final Map<String, double> count = {};
  var postlen;
  var catelen;
  bool isLoading = false;
  var colorList = <Color>[
    // HexColor('#f85ecb'),
    // HexColor('#6bc0db'),
    // HexColor('#030003'),
    // HexColor('#ff00fd'),
    // HexColor('#00e615'),
    // HexColor('#2da672'),
  ];

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

      userData = userSnap.data()!;
      //postData = postSnapMy.data()!;
      postDataAll = postSnapAll.size;
      postDataJoin = postSnapMy.size;
      postDataJoin = postDataAll - postDataJoin;

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
                },
              ),
              toolbarHeight: MediaQuery.of(context).size.height * 0.13,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                "\t\t\tUser\nStatistics",
                style: TextStyle(
                  fontSize: 46,
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
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                height: 100,
                                child: Column(
                                  children: [
                                    Text('Activity'),
                                    Text('All join ${postDataAll}'),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 160),
                                      child: Row(
                                        children: [
                                          Text('My post ${postDataJoin}'),
                                          Text('Join ${postDataJoin}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: Column(
                              children: [
                                const Text('User Point'),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 12.0,
                                    percent: userData['points'] / 100,
                                    center: Text(
                                      '${userData['points']}%',
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                    trailing: const Icon(Icons.mood),
                                    barRadius: const Radius.circular(16),
                                    backgroundColor: unselected,
                                    progressColor: green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: 500,
                          //   padding: EdgeInsets.symmetric(horizontal: 16),
                          //   child: PieChart(
                          //     dataMap: Map<String, double>.from(count),
                          //     chartType: ChartType.ring,
                          //     baseChartColor: unselected.withOpacity(0.15),
                          //     colorList: colorList,
                          //     chartValuesOptions: ChartValuesOptions(
                          //       showChartValuesInPercentage: true,
                          //     ),
                          //   ),
                          // ),
                          // Container(
                          //   height: 500,
                          //   padding: EdgeInsets.symmetric(horizontal: 16),
                          //   child: PieChart(
                          //     dataMap:
                          //         Map<String, double>.from(statData['myPost']),
                          //     chartType: ChartType.ring,
                          //     baseChartColor: unselected.withOpacity(0.15),
                          //     colorList: colorList,
                          //     chartValuesOptions: ChartValuesOptions(
                          //       showChartValuesInPercentage: true,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
          );
  }

  loadData(data, postlen) {
    for (var i = 0; i <= catelen; i++) {
      double count1 = 0.0;
      for (var j = 0; j <= postlen; j++) {
        if (data['category'] == cateData[i]) {
          count1++;
          count[cateData[i]] = count1;
        }
      }
    }
  }
}
