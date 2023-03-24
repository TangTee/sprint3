import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tangteevs/regis,login/Registernext.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import '../team/privacy.dart';
import '../team/team.dart';
import '../utils/color.dart';
import '../widgets/custom_textfield.dart';

class IdcardPage extends StatefulWidget {
  final String fullName;
  final String password;
  final String email;
  const IdcardPage({
    Key? key,
    required this.fullName,
    required this.password,
    required this.email,
  }) : super(key: key);

  @override
  _IdcardPageState createState() => _IdcardPageState();
}

class _IdcardPageState extends State<IdcardPage> {
  DatabaseService databaseService = DatabaseService();
  final user = FirebaseAuth.instance.currentUser;
  final bool _isLoading = false;
  bool isChecked = false;
  bool isadmin = false;
  String bio = "";
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String _ImageidcardController = '';
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  File? media;
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  var userData = {};
  var postLen = 0;
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DismissKeyboard(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: transparent,
            iconTheme: const IconThemeData(color: mobileSearchColor),
            toolbarHeight: 120,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              "VERIFICATION",
              style: TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
            // ignore: prefer_const_constructors
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(-20),
              child: const Text("Confirm your identity",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: unselected)),
            ),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor))
              : SingleChildScrollView(
                  child: SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("Enter your date of birth.",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'MyCustomFont',
                                  color: unselected)),
                          const SizedBox(height: 16),
                          Container(
                            alignment: Alignment.center,
                            width: 360,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _dayController,
                                    keyboardType: TextInputType.number,
                                    decoration: textInputDecorationp.copyWith(
                                        hintText: "Day",
                                        prefixIcon: Icon(
                                          Icons.view_day,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "plase Enter Your Day";
                                      } else if (int.parse(val) >= 31) {
                                        return 'Day must less than 31';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: _monthController,
                                    readOnly: true,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            children: <Widget>[
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '1';
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('1'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '2';

                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('2'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '3';
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('3'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '4';
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('4'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '5';

                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('5'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '6';
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('6'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '7';
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('7'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '8';

                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('8'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '9';
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('9'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '10';
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('10'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '11';

                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('11'),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _monthController.text = '12';
                                                  // Close the dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('12'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    enableInteractiveSelection: false,
                                    decoration: textInputDecorationp.copyWith(
                                      hintText: 'month',
                                      prefixIcon: Icon(
                                        Icons.calendar_month,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _yearController,
                                    keyboardType: TextInputType.number,
                                    decoration: textInputDecorationp.copyWith(
                                        hintText: "year",
                                        prefixIcon: Icon(
                                          Icons.view_day,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "plase Enter year";
                                      } else if (int.parse(val) >= 2008) {
                                        return 'your age must be more than 15';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Please shoot in the frame for clarity\n",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'MyCustomFont',
                                  color: unselected)),
                          SizedBox(
                              height: 120,
                              child: media != null
                                  ? Image.file(media!)
                                  : Image.asset('assets/images/id-card.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                minimumSize: const Size(268, 36),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? file = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              print('${file?.path}');

                              if (file == null) return;
                              String getRandomString(int length) {
                                const characters =
                                    '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
                                Random random = Random();
                                return String.fromCharCodes(Iterable.generate(
                                    length,
                                    (_) => characters.codeUnitAt(
                                        random.nextInt(characters.length))));
                              }

                              String uniqueFileName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              Reference referenceRoot =
                                  FirebaseStorage.instance.ref();
                              Reference referenceDirImages =
                                  referenceRoot.child('idcard');
                              Reference referenceImageToUpload =
                                  referenceDirImages.child(getRandomString(40));
                              try {
                                //Store the file
                                await referenceImageToUpload
                                    .putFile(File(file.path));
                                //Success: get the download URL
                                _ImageidcardController =
                                    await referenceImageToUpload
                                        .getDownloadURL();
                              } catch (error) {
                                //Some error occurred
                              }
                              setState(() {
                                media = File(file.path);
                              });
                              print(_ImageidcardController);
                            },
                            child: const Text("Take a photo of idcard"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // ElevatedButton(
                          //     onPressed: () {
                          //       print(widget.password);
                          //     },
                          //     child: Text('test')),
                          const Text(
                              "Warning: avoid reflected light and too dark \nThe picture is not blurry, the letters are clearly visible. ",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'MyCustomFont',
                                  color: unselected)),
                          const SizedBox(
                            height: 120,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value!;

                                    isadmin = false;
                                  });
                                },
                              ),
                              Text.rich(TextSpan(
                                style: const TextStyle(
                                    color: mobileSearchColor,
                                    fontSize: 12,
                                    fontFamily: 'MyCustomFont'),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "I hereby certify that I am over 15 years old and accept",
                                      style: const TextStyle(
                                        color: mobileSearchColor,
                                        decoration: TextDecoration.none,
                                      ),
                                      recognizer: TapGestureRecognizer()),
                                  TextSpan(
                                      text: "\nconditions of use",
                                      style: const TextStyle(
                                          color: mobileSearchColor,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(
                                              context, const TermsPage());
                                        }),
                                  TextSpan(
                                      text: " and ",
                                      style: const TextStyle(
                                        color: mobileSearchColor,
                                        decoration: TextDecoration.none,
                                      ),
                                      recognizer: TapGestureRecognizer()),
                                  TextSpan(
                                      text: "Privacy Policy",
                                      style: const TextStyle(
                                          color: mobileSearchColor,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(
                                              context, const PrivacyPage());
                                        }),
                                ],
                              )),
                            ],
                          ),
                          SizedBox(
                            width: 307,
                            height: 49,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isChecked ? purple : unselected,
                                  minimumSize: const Size(268, 49),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Text(
                                    'Next',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'MyCustomFont'),
                                  ), // <-- Text
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Icon(
                                    // <-- Icon
                                    Icons.navigate_next_sharp,
                                    size: 26.0,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                if (isChecked == true) {
                                  register();
                                } else {
                                  return;
                                }
                              },
                            ),
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

  register() {
    if (_formKey.currentState!.validate() == true) {
      nextScreen(
          context,
          RegisnextPage(
            Imageidcard: _ImageidcardController.toString(),
            day: _dayController.text,
            email: widget.email,
            fullName: widget.fullName,
            month: _monthController.text,
            password: widget.password,
            year: _yearController.text,
          ));
    }
  }
}
