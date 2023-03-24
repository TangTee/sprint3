import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tangteevs/widgets/tag.dart';

import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import '../utils/color.dart';
import '../utils/showSnackbar.dart';
import '../widgets/custom_textfield.dart';

class EditAct extends StatefulWidget {
  final String postid;
  const EditAct({Key? key, required this.postid}) : super(key: key);

  @override
  _EditActState createState() => _EditActState();
}

class _EditActState extends State<EditAct> {
  final user = FirebaseAuth.instance.currentUser;
  String activityName = "";
  String place = "";
  String location = "";
  String detail = "";
  String people = "";
  String tag = "";
  String tagColor = "";
  DatabaseService databaseService = DatabaseService();
  final bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  final CollectionReference _post =
      FirebaseFirestore.instance.collection('post');

  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _peopleLimitController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _tagColorController = TextEditingController();
  var value;
  var test;
  var postData = {};
  bool isLoading = false;
  var countActivity;
  var countPlace;
  var countDetail;
  var countPeople;
  Color textA = mobileSearchColor;
  Color textP = mobileSearchColor;
  Color textD = mobileSearchColor;
  Color textL = mobileSearchColor;
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

      postData = postSnap.data()!;
      _activityNameController.text = postData['activityName'].toString();
      _dateController.text = postData['date'].toString();
      _detailController.text = postData['detail'].toString();
      _locationController.text = postData['location'].toString();
      _peopleLimitController.text = postData['peopleLimit'].toString();
      _placeController.text = postData['place'].toString();
      _timeController.text = postData['time'].toString();
      _tagController.text = postData['tag'].toString();
      _tagColorController.text = postData['tagColor'].toString();
      countActivity = _activityNameController.text;
      countPlace = _placeController.text;
      countDetail = _detailController.text;
      countPeople = _peopleLimitController.text;

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
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center()
        : DismissKeyboard(
            child: MaterialApp(
              home: Scaffold(
                bottomNavigationBar: null,
                backgroundColor: mobileBackgroundColor,
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: mobileSearchColor,
                      size: 30,
                    ),
                    onPressed: () => {
                      Navigator.of(context).popUntil((route) => route.isFirst)
                    },
                  ),
                  toolbarHeight: MediaQuery.of(context).size.height * 0.13,
                  centerTitle: true,
                  elevation: 0,
                  title: const Text(
                    "Edit Activity",
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: purple,
                    ),
                  ),
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(-20),
                    child: Text("แก้ไขกิจกรรมของคุณ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: unselected)),
                  ),
                ),
                body: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: mobileBackgroundColor,
                      ))
                    : SafeArea(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: TextFormField(
                                      controller: _activityNameController,
                                      decoration: textInputDecorationp.copyWith(
                                          hintText: 'Activity Name',
                                          counterText:
                                              '${countActivity.length.toString()} /25',
                                          counterStyle: TextStyle(color: textA),
                                          prefixIcon: const Icon(
                                            Icons.title,
                                            color: lightPurple,
                                          )),
                                      validator: (val) {
                                        if (val!.isNotEmpty) {
                                          return null;
                                        }
                                        if (val.length > 25) {
                                          return 'Limit at 25 characters ';
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {
                                        setState(() {
                                          activityName = val;
                                          countActivity = val;
                                          if (val.length > 12) {
                                            textA = redColor;
                                          } else {
                                            textA = mobileSearchColor;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.005,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: TextFormField(
                                    controller: _placeController,
                                    decoration: textInputDecorationp.copyWith(
                                        hintText: 'place',
                                        counterText:
                                            '${countPlace.length.toString()} /25',
                                        counterStyle: TextStyle(color: textP),
                                        prefixIcon: const Icon(
                                          Icons.maps_home_work,
                                          color: lightPurple,
                                        )),
                                    validator: (val) {
                                      if (val!.isNotEmpty) {
                                        return null;
                                      }
                                      if (val.length > 25) {
                                        return 'Limit at 25 characters ';
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        place = val;
                                        countPlace = val;
                                        if (val.length > 12) {
                                          textP = redColor;
                                        } else {
                                          textP = mobileSearchColor;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.005,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: TextFormField(
                                    controller: _locationController,
                                    decoration: textInputDecorationp.copyWith(
                                      hintText: 'location',
                                      prefixIcon: const Icon(
                                        Icons.place,
                                        color: lightPurple,
                                      ),
                                    ),
                                    validator: (val) {
                                      if (!Uri.tryParse(val!)!
                                          .hasAbsolutePath) {
                                        return 'Please enter location link https:';
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        location = val;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: TextFormField(
                                    controller: _dateController,
                                    decoration: textInputDecorationp.copyWith(
                                      hintText: 'Date',
                                      prefixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: lightPurple,
                                      ),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101));

                                      if (pickedDate != null) {
                                        print(pickedDate);
                                        String formattedDate =
                                            DateFormat('yyyy/MM/dd')
                                                .format(pickedDate);
                                        print(formattedDate);

                                        setState(() {
                                          _dateController.text = formattedDate;
                                        });
                                      } else {
                                        print("Date is not selected");
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: TextFormField(
                                    controller: _timeController,
                                    decoration: textInputDecorationp.copyWith(
                                      hintText: "Time",
                                      prefixIcon: const Icon(
                                        Icons.query_builder,
                                        color: lightPurple,
                                      ),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (pickedTime != null) {
                                        print(pickedTime.format(context));
                                        setState(() {
                                          _timeController.text = pickedTime.format(
                                              context); //set the value of text field.
                                        });
                                      } else {
                                        print("Time is not selected");
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: TextFormField(
                                    controller: _detailController,
                                    decoration: textInputDecorationp.copyWith(
                                        hintText: 'Detail',
                                        counterText:
                                            '${countDetail.length.toString()} /150',
                                        counterStyle: TextStyle(color: textD),
                                        prefixIcon: const Icon(
                                          Icons.pending,
                                          color: lightPurple,
                                        )),
                                    validator: (val) {
                                      if (val!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return "plase Enter Your Place";
                                      }
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        detail = val;
                                        countDetail = val;
                                        if (val.length > 12) {
                                          textD = redColor;
                                        } else {
                                          textD = mobileSearchColor;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: TextFormField(
                                    controller: _peopleLimitController,
                                    keyboardType: TextInputType.number,
                                    decoration: textInputDecorationp.copyWith(
                                        hintText: 'People Limit',
                                        counterText: '$countPeople /99',
                                        counterStyle: TextStyle(color: textL),
                                        prefixIcon: const Icon(
                                          Icons.person_outline,
                                          color: lightPurple,
                                        )),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a valid people limit';
                                      } else if (int.parse(value) >= 100) {
                                        return 'people must less than 100';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        people = val;
                                        countPeople = val;
                                        if (val.length > 2) {
                                          textL = redColor;
                                        } else {
                                          textL = mobileSearchColor;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.005,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: Row(
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: SizedBox(
                                                child: OutlinedButton(
                                                  onPressed: null,
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                    side: const BorderSide(
                                                        color: disable,
                                                        width: 1.5),
                                                  ),
                                                  child: Text(
                                                    _tagController.text,
                                                    style: const TextStyle(
                                                        color: disable,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: SizedBox(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    value =
                                                        showModalBottomSheetC(
                                                            context);
                                                    setState(() {});
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    backgroundColor: green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    side: const BorderSide(
                                                        color: green,
                                                        width: 1.5),
                                                  ),
                                                  child: const Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: white,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: purple,
                                      minimumSize: const Size(307, 49),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: const Text(
                                    "save",
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 24),
                                  ),
                                  onPressed: () {
                                    Updata();
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
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

  Updata() async {
    final String activityName = _activityNameController.text;
    final String place = _placeController.text;
    final String location = _locationController.text;
    final String date = _dateController.text;
    final String time = _timeController.text;
    final String detail = _detailController.text;
    final String tag = _tagController.text;
    final String peopleLimit = _peopleLimitController.text;
    var timeStamp = postData['timeStamp'];

    if (_formKey.currentState!.validate()) {
      if (value == null) {
        await _post.doc(widget.postid).update({
          'activityName': activityName,
          'place': place,
          'location': location,
          'date': date,
          'time': time,
          'detail': detail,
          'peopleLimit': peopleLimit,
          'timeStamp': timeStamp,
          'tag': _tagController.text,
          'tagColor': _tagColorController.text,
        });
      } else {
        await _post.doc(widget.postid).update({
          'activityName': activityName,
          'place': place,
          'location': location,
          'date': date,
          'time': time,
          'detail': detail,
          'peopleLimit': peopleLimit,
          'timeStamp': timeStamp,
          'tag': value['_tag2'],
          'tagColor': value['_tag2Color'],
        });
      }

      _activityNameController.text = '';
      _placeController.text = '';
      _locationController.text = '';
      _dateController.text = '';
      _timeController.text = '';
      _detailController.text = '';
      _peopleLimitController.text = '';
      _tagController.text = '';
      _tagColorController.text = '';

      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
