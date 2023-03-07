import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> likePost(String postId, String uid, List likes) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String res = "Some error occurred";
  try {
    if (likes.contains(uid)) {
      // if the likes list contains the user uid, we need to remove it
      firestore.collection('post').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      // else we need to add uid to the likes array
      firestore.collection('post').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
    res = 'success';
  } catch (err) {
    res = err.toString();
  }
  return res;
}
