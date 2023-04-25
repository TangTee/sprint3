import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/showSnackbar.dart';
import 'services/local_notification_service.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  late final LocalNotificationService service;
  var currentUser = {};
  bool isLoading = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var currentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
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
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : currentUser['points'] < 41
            ? Drawer(
                child: ListView(
                  children: <Widget>[
                    const ListTile(
                      title: Text("TungTee"),
                      subtitle: Text(
                          "คะแนนความประพฤติของคุณต่ำกรุณาอย่าทำผิดกฏทางชุมชน"),
                    ),
                  ],
                ),
              )
            : Drawer(
                child: ListView(
                  children: <Widget>[],
                ),
              );
  }
}
