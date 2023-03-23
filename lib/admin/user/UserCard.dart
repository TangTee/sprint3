import 'package:flutter/material.dart';
import 'package:tangteevs/admin/user/verify.dart';
import 'package:tangteevs/pickers/block_picker.dart';

import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/utils/showSnackbar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';

class UCardWidget extends StatefulWidget {
  final snap;
  const UCardWidget({super.key, required this.snap});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UCardWidget> {
  var userData = {};
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
          .doc(widget.snap['uid'])
          .get();

      var currentSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
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

  final TextEditingController _idcardController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();
  final TextEditingController _DisplaynameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _idcardController.text = documentSnapshot['idcard'];
      _verifyController.text = documentSnapshot['verify'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    height: 300,
                    width: 400,
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: Image.network(_idcardController.text,
                                fit: BoxFit.cover))),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text.rich(
                  TextSpan(
                    text: 'verify this id card',
                    style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      color: unselected,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green, // Background color
                      ),
                      child: const Text('Yes'),
                      onPressed: () async {
                        const bool verify = true;
                        await _users
                            .doc(documentSnapshot!.id)
                            .update({"verify": verify});
                        _DisplaynameController.text = '';
                        _emailController.text = '';
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: disable, // Background color
                      ),
                      child: const Text('No'),
                      onPressed: () async {
                        const bool verify = false;
                        await _users
                            .doc(documentSnapshot!.id)
                            .update({"verify": verify});
                        _DisplaynameController.text = '';
                        _emailController.text = '';
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: mobileBackgroundColor,
        child: Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
              color: unselected,
              width: 1,
            ),
          ),
          margin: const EdgeInsets.all(10),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.00, top: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(widget.snap['Displayname'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'MyCustomFont',
                                color: unselected,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            widget.snap['email'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'MyCustomFont',
                              color: unselected,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        widget.snap['verify'] == true
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Are you sure to delete User?'),
                                        content: const Text(
                                            'This action cannot be undone.\nThis action permanently remove \nthis User from Tungtee'),
                                        actions: [
                                          TextButton(
                                            child: const Text(
                                              'Cancel',
                                              style: const TextStyle(
                                                color: mobileSearchColor,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text(
                                              'Delete',
                                              style: const TextStyle(
                                                color: redColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.snap['uid'])
                                                  .delete()
                                                  .whenComplete(
                                                () {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'You have successfully deleted a users',
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _update(widget.snap);
                                  },
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
}
