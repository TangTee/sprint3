import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/PostCard.dart';

Future<String> requestToLoin(String postId, String uid, List waiting) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String res = "Some error occurred";
  try {
    if (waiting.contains(uid)) {
      // if the likes list contains the user uid, we need to remove it
      firestore.collection('post').doc(postId).update({
        'waiting': FieldValue.arrayRemove([uid])
      });
    } else {
      // else we need to add uid to the likes array
      firestore.collection('post').doc(postId).update({
        'waiting': FieldValue.arrayUnion([uid])
      });
    }
    res = 'success';
  } catch (err) {
    res = err.toString();
  }
  return res;
}

class WaitingPage extends StatelessWidget {
  const WaitingPage({Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: WaitingCard(),
    );
  }
}

class WaitingCard extends StatelessWidget {
  final _post = FirebaseFirestore.instance.collection('post');

   WaitingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('post')
            .where('waiting',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .where('open', isEqualTo: true)
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                      child: CardWidget(
                          snap: (streamSnapshot.data! as dynamic).docs[index]),
                    ));
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
    );
  }
}
