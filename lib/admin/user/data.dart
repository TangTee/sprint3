import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tangteevs/admin/user/UserCard.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class UserCardPage extends StatefulWidget {
  const UserCardPage({Key? key}) : super(key: key);

  @override
  _UserCardPageState createState() => _UserCardPageState();
}

class _UserCardPageState extends State<UserCardPage> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
        child: UserCard(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class UserCard extends StatelessWidget {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  UserCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _users.where('verify', isEqualTo: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          }

          return Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: SafeArea(
              child: ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Container(
                        child: UCardWidget(
                            snap: (snapshot.data! as dynamic).docs[index]),
                      )),
            ),
          );
        });
  }
}
