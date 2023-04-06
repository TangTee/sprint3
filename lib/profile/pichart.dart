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

class PichartRender extends StatefulWidget {
  final String uid;
  final List cateData;
  final int catelen;
  final List colorList;

  PichartRender(
      {Key? key,
      required this.uid,
      required List this.cateData,
      required this.catelen,
      required List this.colorList})
      : super(key: key);

  @override
  _PichartRenderState createState() => _PichartRenderState();
}

class _PichartRenderState extends State<PichartRender> {
  bool isLoading = false;
  var cusLen = 0.0;
  var count = {};

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
      count = {
        widget.cateData[0].toString(): 0.0,
      };

      for (var i = 0; i < widget.catelen; i++) {
        var postSnapCus = await FirebaseFirestore.instance
            .collection('post')
            .where('history', arrayContains: widget.uid)
            .where('category', isEqualTo: widget.cateData[i])
            .get();

        cusLen = postSnapCus.size.toDouble();
        count[widget.cateData[i].toString()] = cusLen;
      }

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
    return Column(
      children: [
        Container(
          height: 390,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PieChart(
            dataMap: Map<String, double>.from(count),
            chartType: ChartType.ring,
            baseChartColor: unselected.withOpacity(0.15),
            colorList: List<Color>.from(widget.colorList),
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
            ),
          ),
        ),
      ],
    );
  }
}
