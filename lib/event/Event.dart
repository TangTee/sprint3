import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

import '../widgets/tag.dart';

// import 'AddTag.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadTag(),
    );
  }
}

class LoadTag extends StatefulWidget {
  const LoadTag({super.key});

  @override
  State<LoadTag> createState() => _LoadTagState();
}

class _LoadTagState extends State<LoadTag> {
  bool _isLoading = false;
  bool isDateSelect = false;

  final _post = FirebaseFirestore.instance.collection('post').doc();
  final _join = FirebaseFirestore.instance.collection('join');
  final _formKey = GlobalKey<FormState>();
  final _activityName = TextEditingController();
  final _place = TextEditingController();
  final _location = TextEditingController();
  final dateController = TextEditingController();
  final _time = TextEditingController();
  final _detail = TextEditingController();
  var getDate;
  var IntGetdate;
  var thisDate;
  late final String _tag = 'Tag';
  final _peopleLimit = TextEditingController();
  var _tag2;
  var category;
  var valuee;
  var _tag2Color;
  String _enteredTextA = '';
  Color TextA = mobileSearchColor;
  String _enteredTextP = '';
  Color TextP = mobileSearchColor;
  String _enteredTextD = '';
  Color TextD = mobileSearchColor;
  var _enteredTextL;
  Color TextL = mobileSearchColor;
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: mobileBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _activityName,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                                color: mobileSearchColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: "MyCustomFont"),
                            suffixIcon: const Icon(Icons.edit),
                            border: InputBorder.none,
                            hintText: 'Write your activity name',
                            counterText:
                                '${_enteredTextA.length.toString()} /25',
                            counterStyle: TextStyle(color: TextA)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid activity name';
                          }
                          if (value.length > 25) {
                            return 'Limit at 25 characters ';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _enteredTextA = value;
                            if (value.length > 25) {
                              TextA = redColor;
                            } else {
                              TextA = mobileSearchColor;
                            }
                          });
                        },
                      ),
                      TextFormField(
                        controller: _place,
                        decoration: textInputDecoration.copyWith(
                          labelStyle: const TextStyle(
                            color: mobileSearchColor,
                            fontFamily: "MyCustomFont",
                          ),
                          hintText: 'Place',
                          counterText: '${_enteredTextP.length.toString()} /25',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid place';
                          }
                          if (value.length > 25) {
                            return 'Limit at 25 characters ';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _enteredTextP = value;
                            if (value.length > 25) {
                              TextP = redColor;
                            } else {
                              TextP = mobileSearchColor;
                            }
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          controller: _location,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Location URL',
                            labelStyle: const TextStyle(
                              fontFamily: "MyCustomFont",
                              color: mobileSearchColor,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid Location URL';
                            }

                            if (!Uri.tryParse(value)!.hasAbsolutePath) {
                              return 'Please enter link http: or https:';
                            }

                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  child: TextField(
                                    controller: dateController,
                                    decoration: textInputDecoration.copyWith(
                                      prefixIcon:
                                          const Icon(Icons.calendar_month),
                                      labelStyle: const TextStyle(
                                        color: mobileSearchColor,
                                        fontFamily: "MyCustomFont",
                                      ),
                                      hintText: '_ _ / _ _ / _ _ ',
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate:
                                            DateTime(DateTime.now().year + 1),
                                      );

                                      if (pickedDate != null) {
                                        getDate =
                                            DateFormat('d').format(pickedDate);
                                        IntGetdate = int.parse(getDate);
                                        String formattedDate =
                                            DateFormat('yyyy/MM/dd')
                                                .format(pickedDate);
                                        setState(() {
                                          isDateSelect = true;
                                          dateController.text = formattedDate;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (isDateSelect == false)
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    child: TextField(
                                      controller: _time,
                                      decoration: textInputDecoration.copyWith(
                                          enabled: false,
                                          labelStyle: const TextStyle(
                                            color: mobileSearchColor,
                                            fontFamily: "MyCustomFont",
                                          ),
                                          disabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            borderSide: BorderSide(
                                                color: disable, width: 2),
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.query_builder,
                                          ),
                                          hintText: "_ _ : _ _ "),
                                      readOnly: true,
                                      onTap: () async {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        TimeOfDay now = TimeOfDay.now();
                                        int nowInMinutes =
                                            now.hour * 60 + now.minute + 60;
                                        int pickedInMinutes =
                                            pickedTime!.hour * 60 +
                                                pickedTime.minute;

                                        if (pickedInMinutes > nowInMinutes) {
                                          setState(() {
                                            _time.text =
                                                pickedTime.format(context);
                                          });
                                        } else if (pickedInMinutes <
                                            nowInMinutes) {
                                          return print("Please selec time ...");
                                        } else {
                                          print("Time is not selected");
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    child: TextField(
                                        controller: _time,
                                        decoration:
                                            textInputDecoration.copyWith(
                                                labelStyle: const TextStyle(
                                                  color: mobileSearchColor,
                                                  fontFamily: "MyCustomFont",
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.query_builder,
                                                ),
                                                hintText: "_ _ : _ _ "),
                                        readOnly: true,
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          TimeOfDay now = TimeOfDay.now();
                                          int nowInMinutes =
                                              now.hour * 60 + now.minute + 60;
                                          int pickedInMinutes =
                                              pickedTime!.hour * 60 +
                                                  pickedTime.minute;

                                          final today = DateFormat('d')
                                              .format(DateTime.now());
                                          var IntToday = int.parse(today);

                                          if (IntGetdate > IntToday) {
                                            setState(() {
                                              _time.text =
                                                  pickedTime.format(context);
                                            });
                                          } else if (getDate == today) {
                                            if (pickedInMinutes >
                                                nowInMinutes) {
                                              setState(() {
                                                _time.text =
                                                    pickedTime.format(context);
                                              });
                                            } else {
                                              print("Try again");
                                            }
                                          }
                                        }),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              maxLines: 3,
                              controller: _detail,
                              decoration: textInputDecoration.copyWith(
                                labelStyle: const TextStyle(
                                  color: mobileSearchColor,
                                  fontFamily: "MyCustomFont",
                                ),
                                hintText: 'Detail',
                                counterText:
                                    '${_enteredTextD.length.toString()} /150',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid detail';
                                }
                                if (value.length > 150) {
                                  return 'Limit at 150 characters ';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _enteredTextD = value;
                                  if (value.length > 25) {
                                    TextD = redColor;
                                  } else {
                                    TextD = mobileSearchColor;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: TextFormField(
                            controller: _peopleLimit,
                            decoration: textInputDecoration.copyWith(
                              labelStyle: const TextStyle(
                                color: mobileSearchColor,
                                fontFamily: "MyCustomFont",
                              ),
                              hintText: 'People Limit',
                              counterText: _enteredTextL == null
                                  ? '0 /99'
                                  : '$_enteredTextL /99',
                              counterStyle: TextStyle(color: TextL),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                _enteredTextL = val;
                                if (val.length > 2) {
                                  TextL = redColor;
                                } else {
                                  TextL = mobileSearchColor;
                                }
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid people limit';
                              } else if (int.parse(value) >= 100) {
                                return 'people must less than 100';
                              } else {
                                return null;
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                valuee = showModalBottomSheetC(context);
                                setState(() {});
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: mobileSearchColor,
                              ),
                              child: SizedBox(
                                width: 50,
                                child: Row(
                                  children: const [
                                    Icon(Icons.add),
                                    Text('Tag')
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _time.text == ''
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 90.0,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      backgroundColor: unselected),
                                  onPressed: () {},
                                  child: const Text(
                                    "Post",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'MyCustomFont'),
                                  ),
                                ),
                              ),
                            )
                          : valuee == null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        90.0,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          backgroundColor: unselected),
                                      onPressed: () {},
                                      child: const Text(
                                        "Post",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'MyCustomFont'),
                                      ),
                                    ),
                                  ),
                                )
                              : valuee == "other"
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                90.0,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              backgroundColor: unselected),
                                          onPressed: () {},
                                          child: const Text(
                                            "Post",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'MyCustomFont'),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                90.0,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              backgroundColor: green),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                    .validate() ==
                                                true) {
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              await _post.set({
                                                'postid': _post.id,
                                                'activityName':
                                                    _activityName.text,
                                                'place': _place.text,
                                                'location': _location.text,
                                                'date': dateController.text,
                                                'time': _time.text,
                                                'detail': _detail.text,
                                                'peopleLimit':
                                                    _peopleLimit.text,
                                                'likes': [],
                                                'waiting': [],
                                                'history': [
                                                  FirebaseAuth
                                                      .instance.currentUser?.uid
                                                ],
                                                'category':
                                                    valuee['_category2'],
                                                'tag': valuee['_tag2'],
                                                'tagColor':
                                                    valuee['_tag2Color'],
                                                'open': true,
                                                'timeStamp': FieldValue
                                                    .serverTimestamp(),
                                                'uid': FirebaseAuth
                                                    .instance.currentUser?.uid,
                                              }).whenComplete(() {
                                                _join.doc(_post.id).set({
                                                  'owner': FirebaseAuth.instance
                                                      .currentUser?.uid,
                                                  'member': [
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid
                                                  ],
                                                  'groupid': _post.id,
                                                  'groupName':
                                                      _activityName.text,
                                                  "recentMessage": "",
                                                  "recentMessageSender": "",
                                                  "recentMessageTime": "",
                                                  "recentMessageUID": "",
                                                  "clicked": [],
                                                  "unread": [],
                                                }).whenComplete(() {
                                                  var uid = FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid;
                                                  _join.doc(_post.id).update({
                                                    'member':
                                                        FieldValue.arrayUnion(
                                                            [uid]),
                                                    // FirebaseAuth.instance.c//.doc(_post.id).update({
                                                    //   'member': FieldValue.arrayUnion([uid]),
                                                  });
                                                  nextScreenReplaceOut(
                                                      context,
                                                      const MyHomePage(
                                                        index: 0,
                                                      ));
                                                });
                                              });
                                            }
                                          },
                                          child: const Text(
                                            "Post",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'MyCustomFont'),
                                          ),
                                        ),
                                      ),
                                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    dateController.text = "";
    _time.text = "";
    super.initState();
  }
}
