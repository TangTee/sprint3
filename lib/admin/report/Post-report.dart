import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';
import 'detail.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String name = '';
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

// text fields' controllers
  final TextEditingController _DisplaynameController = TextEditingController();
  final TextEditingController _idcardController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final CollectionReference _report =
      FirebaseFirestore.instance.collection('report');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: _report.where('type', isEqualTo: 'post').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: detail(
                            postid: documentSnapshot['postid'],
                            uid: documentSnapshot['uid'],
                            rid: documentSnapshot['rid'],
                          ),

                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation
                              .cupertino, // OPTIONAL VALUE. True by default.
                        );
                      },
                      child: ListTile(
                        title: Text(documentSnapshot['activityName']),
                        subtitle: Text(documentSnapshot['problem']),
                        trailing: const SingleChildScrollView(
                          child: SizedBox(
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: Text('no data yet'),
            );
          },
        ),
// Add new users
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _create(),
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
