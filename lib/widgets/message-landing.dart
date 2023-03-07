import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/my_date_util.dart';
import '../utils/color.dart';
import '../utils/showSnackbar.dart';

class MessagePreviewWidget extends StatefulWidget {
  const MessagePreviewWidget({
    Key? key,
    required this.messageTitle,
    required this.messageContent,
    required this.timer,
    required this.isunread,
    required this.messageTime,
    required this.messageImage,
    required this.uid,
  }) : super(key: key);

  final String messageTitle;
  final String messageImage;
  final String messageContent;
  final bool timer;
  final bool isunread;
  final String messageTime;
  final String uid;

  @override
  _MessagePreviewWidgetState createState() => _MessagePreviewWidgetState();
}

class _MessagePreviewWidgetState extends State<MessagePreviewWidget> {
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
                .where('uid', isEqualTo: widget.messageImage)
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
                                                  widget.messageTitle,
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
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.only(
                                            left: 30,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.55,
                                                child: widget.messageContent
                                                        .startsWith('https://')
                                                    ? Container(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            text: widget
                                                                    .isunread
                                                                ? 'me : send a Photo.'
                                                                : '${userData['Displayname']} : send a Photo.',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'MyCustomFont',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Text(
                                                        widget.messageContent,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'MyCustomFont',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100),
                                                      ),
                                              ),
                                              SizedBox(
                                                child: Text(
                                                    widget.timer
                                                        ? ''
                                                        : MyDateUtil
                                                            .getFormattedTime(
                                                                context:
                                                                    context,
                                                                time: widget
                                                                    .messageTime),
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'MyCustomFont',
                                                        fontSize: 14)),
                                              ),
                                              const SizedBox(
                                                child: Icon(
                                                  Icons.chevron_right_rounded,
                                                  color: purple,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
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
