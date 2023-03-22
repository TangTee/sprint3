import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/services/database_service.dart';
import '../utils/color.dart';
import '../utils/showSnackbar.dart';

class JoinPage extends StatefulWidget {
  final String postid;
  const JoinPage({Key? key, required this.postid}) : super(key: key);

  @override
  JoinPageState createState() => JoinPageState();
}

class JoinPageState extends State<JoinPage> {
  DatabaseService databaseService = DatabaseService();
  var postData = {};
  var waiting = [];
  var waitingLen = 0;
  var joinLen = 0;
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
      var postSnap = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postid)
          .get();

      var joinSnap = await FirebaseFirestore.instance
          .collection('join')
          .doc(widget.postid)
          .get();

      postData = postSnap.data()!;
      waiting = postSnap.data()?['waiting'];
      waiting.add('Empty');
      waitingLen = postSnap.data()?['waiting'].length - 1;
      joinLen = joinSnap.data()?['member'].length - 1;
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
    return Scaffold(
      bottomNavigationBar: null,
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: mobileSearchColor, size: 30),
          onPressed: () => {Navigator.of(context).pop(true)},
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.13,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Request List",
          style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            color: purple,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Center(
            child: SizedBox(
              height: 40,
              child: Column(
                children: const [
                  Text("Press the check mark to accept the request to join",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: unselected)),
                  Text("or press the cross mark to decline",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: unselected)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  if (joinLen == int.parse(postData['peopleLimit']))
                    const Text("Group is full",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: redColor)),
                  if (joinLen == int.parse(postData['peopleLimit']) - 1)
                    const Text("1 Last place",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: redColor)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.80,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('uid', whereIn: waiting)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            height: 500,
                            width: 600,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot
                                              documentSnapshot =
                                              snapshot.data!.docs[index];
                                          return Card(
                                            elevation: 2,
                                            margin: const EdgeInsets.all(10),
                                            child: ClipPath(
                                              clipper: ShapeBorderClipper(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3))),
                                              child: SizedBox(
                                                height: 70,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: SizedBox(
                                                    height: 80,
                                                    child: ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor: green,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          documentSnapshot[
                                                                  'profile']
                                                              .toString(),
                                                        ),
                                                        radius: 25,
                                                      ),
                                                      title: Text(
                                                          documentSnapshot[
                                                              'Displayname']),
                                                      //subtitle: documentSnapshot['bio'],
                                                      trailing:
                                                          SingleChildScrollView(
                                                        child: SizedBox(
                                                            width: 100,
                                                            child: Row(
                                                              children: [
                                                                if (joinLen ==
                                                                    int.parse(
                                                                        postData[
                                                                            'peopleLimit']))
                                                                  const Icon(
                                                                    Icons.check,
                                                                    color:
                                                                        unselected,
                                                                  ),
                                                                if (joinLen !=
                                                                    int.parse(
                                                                        postData[
                                                                            'peopleLimit']))
                                                                  Expanded(
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .check,
                                                                        color:
                                                                            green,
                                                                      ),
                                                                      onPressed:
                                                                          () =>
                                                                              joinActivity(
                                                                        widget
                                                                            .postid
                                                                            .toString(),
                                                                        documentSnapshot[
                                                                            'uid'],
                                                                        postData[
                                                                            'waiting'],
                                                                        joinLen,
                                                                        int.parse(
                                                                            postData['peopleLimit']),
                                                                      ).whenComplete(() {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              true;
                                                                        });
                                                                        getData();
                                                                      }),
                                                                    ),
                                                                  ),
                                                                Expanded(
                                                                  child:
                                                                      IconButton(
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color:
                                                                          orange,
                                                                    ),
                                                                    onPressed: () =>
                                                                        denyActivity(
                                                                      widget
                                                                          .postid
                                                                          .toString(),
                                                                      documentSnapshot[
                                                                          'uid'],
                                                                      postData[
                                                                          'waiting'],
                                                                    ).whenComplete(
                                                                            () {
                                                                      setState(
                                                                          () {
                                                                        isLoading =
                                                                            true;
                                                                      });
                                                                      getData();
                                                                    }),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Future<dynamic> joinActivity(String postId, String uid, List waiting,
    int joinLen, int peoplelimit) async {
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String res = "Some error occurred";

  try {
    firestore.collection('join').doc(postId).update({
      'member': FieldValue.arrayUnion([uid])
    });
    firestore.collection('post').doc(postId).update({
      'waiting': FieldValue.arrayRemove([uid])
    });
    firestore.collection('post').doc(postId).update({
      'history': FieldValue.arrayUnion([uid])
    });
    res = 'success';
  } catch (err) {
    res = err.toString();
  }
  return res;
}

Future<dynamic> denyActivity(String postId, String uid, List waiting) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String res = "Some error occurred";

  try {
    firestore.collection('post').doc(postId).update({
      'waiting': FieldValue.arrayRemove([uid])
    });
    res = 'success';
  } catch (err) {
    res = err.toString();
  }
  return res;
}
