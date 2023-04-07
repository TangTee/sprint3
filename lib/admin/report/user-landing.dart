import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';
import '../../utils/my_date_util.dart';
import '../utils/color.dart';

class UsersPreviewWidget extends StatefulWidget {
  const UsersPreviewWidget({
    Key? key,
    required this.detail,
    required this.uid,
    required this.displayname,
  }) : super(key: key);

  final String detail;
  final String displayname;
  final String uid;

  @override
  _UsersPreviewWidgetState createState() => _UsersPreviewWidgetState();
}

class _UsersPreviewWidgetState extends State<UsersPreviewWidget> {
  bool isLoading = false;

  var userData = {};

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

      userData = userSnap.data()!;

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
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: widget.uid)
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
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.085,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: green,
                                    backgroundImage: NetworkImage(
                                      documentSnapshot['profile'].toString(),
                                    ),
                                    radius: 25,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.only(
                                            left: 30,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.035,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  widget.displayname,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontFamily: 'MyCustomFont',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          widget.detail,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontFamily: 'MyCustomFont',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w100),
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
