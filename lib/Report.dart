import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/color.dart';


void showModalBottomSheetRP(BuildContext context, rPid) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final report =
      FirebaseFirestore.instance.collection('report').doc(rPid['rid']);
  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    )),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'อนาจาร',
                    style: TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': rPid['postid'],
                    'activityName': rPid['activityName'],
                    'place': rPid['place'],
                    'location': rPid['location'],
                    'date': rPid['date'],
                    'time': rPid['time'],
                    'detail': rPid['detail'],
                    'peopleLimit': rPid['peopleLimit'],
                    'uid': rPid['uid'],
                    'problem': 'อนาจาร',
                    'type': 'post',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'ความรุนแรง',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': rPid['postid'],
                    'activityName': rPid['activityName'],
                    'place': rPid['place'],
                    'location': rPid['location'],
                    'date': rPid['date'],
                    'time': rPid['time'],
                    'detail': rPid['detail'],
                    'peopleLimit': rPid['peopleLimit'],
                    'uid': rPid['uid'],
                    'problem': 'ความรุนแรง',
                    'type': 'post',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'การคุกคาม',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': rPid['postid'],
                    'activityName': rPid['activityName'],
                    'place': rPid['place'],
                    'location': rPid['location'],
                    'date': rPid['date'],
                    'time': rPid['time'],
                    'detail': rPid['detail'],
                    'peopleLimit': rPid['peopleLimit'],
                    'uid': rPid['uid'],
                    'problem': 'การคุกคาม',
                    'type': 'post',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'ข้อมูลเท็จ',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': rPid['postid'],
                    'activityName': rPid['activityName'],
                    'place': rPid['place'],
                    'location': rPid['location'],
                    'date': rPid['date'],
                    'time': rPid['time'],
                    'detail': rPid['detail'],
                    'peopleLimit': rPid['peopleLimit'],
                    'uid': rPid['uid'],
                    'problem': 'ข้อมูลเท็จ',
                    'type': 'post',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'สแปม',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': rPid['postid'],
                    'activityName': rPid['activityName'],
                    'place': rPid['place'],
                    'location': rPid['location'],
                    'date': rPid['date'],
                    'time': rPid['time'],
                    'detail': rPid['detail'],
                    'peopleLimit': rPid['peopleLimit'],
                    'uid': rPid['uid'],
                    'problem': 'สแปม',
                    'type': 'post',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'คำพูดแสดงความเกลีดชัง',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': rPid['postid'],
                    'activityName': rPid['activityName'],
                    'place': rPid['place'],
                    'location': rPid['location'],
                    'date': rPid['date'],
                    'time': rPid['time'],
                    'detail': rPid['detail'],
                    'peopleLimit': rPid['peopleLimit'],
                    'uid': rPid['uid'],
                    'problem': 'คำพูดแสดงความเกลีดชัง',
                    'type': 'post',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
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
        ),
      );
    },
  );
}

void showModalBottomSheetRC(BuildContext context, rPid, Map mytext) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final report =
      FirebaseFirestore.instance.collection('report').doc(mytext['cid']);

  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    )),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'อนาจาร',
                    style: TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': mytext['postid'],
                    'Displayname': mytext['Displayname'],
                    'cid': mytext['cid'],
                    'comment': mytext['comment'],
                    'uid': mytext['uid'],
                    'problem': 'อนาจาร',
                    'type': 'comment',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'ความรุนแรง',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': mytext['postid'],
                    'Displayname': mytext['Displayname'],
                    'cid': mytext['cid'],
                    'comment': mytext['comment'],
                    'uid': mytext['uid'],
                    'problem': 'ความรุนแรง',
                    'type': 'comment',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'การคุกคาม',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': mytext['postid'],
                    'Displayname': mytext['Displayname'],
                    'cid': mytext['cid'],
                    'comment': mytext['comment'],
                    'uid': mytext['uid'],
                    'problem': 'การคุกคาม',
                    'type': 'comment',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'ข้อมูลเท็จ',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': mytext['postid'],
                    'Displayname': mytext['Displayname'],
                    'cid': mytext['cid'],
                    'comment': mytext['comment'],
                    'uid': mytext['uid'],
                    'problem': 'ข้อมูลเท็จ',
                    'type': 'comment',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'สแปม',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': mytext['postid'],
                    'Displayname': mytext['Displayname'],
                    'cid': mytext['cid'],
                    'comment': mytext['comment'],
                    'uid': mytext['uid'],
                    'problem': 'สแปม',
                    'type': 'comment',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'คำพูดแสดงความเกลีดชัง',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'postid': mytext['postid'],
                    'Displayname': mytext['Displayname'],
                    'cid': mytext['cid'],
                    'comment': mytext['comment'],
                    'uid': mytext['uid'],
                    'problem': 'คำพูดแสดงความเกลีดชัง',
                    'type': 'comment',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
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
        ),
      );
    },
  );
}

void showModalBottomSheetRT(context, userData, message, displayname, groupid) {
  final report = FirebaseFirestore.instance.collection('report').doc();

  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    )),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'อนาจาร',
                    style: TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'uid': userData,
                    'Displayname': displayname,
                    'groupid': groupid,
                    'text': message,
                    'problem': 'อนาจาร',
                    'type': 'chat',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'ความรุนแรง',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'uid': userData,
                    'Displayname': displayname,
                    'groupid': groupid,
                    'text': message,
                    'problem': 'ความรุนแรง',
                    'type': 'chat',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'การคุกคาม',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'uid': userData,
                    'Displayname': displayname,
                    'groupid': groupid,
                    'text': message,
                    'problem': 'การคุกคาม',
                    'type': 'chat',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'ข้อมูลเท็จ',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'uid': userData,
                    'Displayname': displayname,
                    'groupid': groupid,
                    'text': message,
                    'problem': 'ข้อมูลเท็จ',
                    'type': 'chat',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'สแปม',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'uid': userData,
                    'Displayname': displayname,
                    'groupid': groupid,
                    'text': message,
                    'problem': 'สแปม',
                    'type': 'chat',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                title: const Center(
                  child: Text(
                    'คำพูดแสดงความเกลีดชัง',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                    ),
                  ),
                ),
                onTap: () {
                  report.set({
                    'rid': report.id,
                    'uid': userData,
                    'Displayname': displayname,
                    'groupid': groupid,
                    'text': message,
                    'problem': 'คำพูดแสดงความเกลีดชัง',
                    'type': 'chat',
                    //'likes': [],
                    'timeStamp': DateTime.now(),
                    'reportBy': FirebaseAuth.instance.currentUser?.uid,
                  }).whenComplete(() {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  });
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
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
        ),
      );
    },
  );
}
