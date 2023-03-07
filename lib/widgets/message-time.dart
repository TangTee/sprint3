import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';

import '../utils/my_date_util.dart';

class MessageTime extends StatefulWidget {
  final String time;
  final bool sentByMe;
  final bool image;

  const MessageTime({
    Key? key,
    required this.time,
    required this.sentByMe,
    required this.image,
  }) : super(key: key);

  @override
  State<MessageTime> createState() => _MessageTimeState();
}

class _MessageTimeState extends State<MessageTime> {
  TextEditingController messageController = TextEditingController();
  bool isLoading = false;
  bool text = false;
  bool image = true;
  var groupData = {};
  var member = [];

  var userData = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: widget.sentByMe ? 0 : 4,
        bottom: 0,
        left: widget.sentByMe ? 0 : 14,
        right: widget.sentByMe ? 14 : 0,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(
          top: widget.sentByMe ? 2 : 2,
          bottom: 2,
          left: 10,
          right: 10,
        ),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.14,
                height: MediaQuery.of(context).size.height * 0.02,
                child: Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: widget.time),
                  style: const TextStyle(
                    fontSize: 12,
                    color: unselected,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
