import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import 'package:tangteevs/utils/color.dart';
import '../helper/helper_function.dart';
import '../widgets/custom_textfield.dart';

class RegisnextPage extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String Imageidcard;
  final String day;
  final String month;
  final String year;
  const RegisnextPage(
      {Key? key,
      required this.fullName,
      required this.email,
      required this.password,
      required this.Imageidcard,
      required this.day,
      required this.month,
      required this.year})
      : super(key: key);

  @override
  _RegisnextPageState createState() => _RegisnextPageState();
}

class _RegisnextPageState extends State<RegisnextPage> {
  DatabaseService databaseService = DatabaseService();
  String Displayname = "";
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  String bio = "";
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  final TextEditingController _DisplaynameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  String _ImageProfileController =
      'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  final String _selectedGender = '';
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  File? media1;
  String age = "";
  String gender = "";
  String ImageProfile = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  String instagram = "";
  String facebook = "";
  String twitter = "";
  bool ban = false;
  bool verify = false;
  bool isadmin = false;
  int points = 100;

  var userData = {};
  var postLen = 0;
  bool isLoading = false;

  String _enteredTextU = '';
  Color TextU = mobileSearchColor;
  String _enteredTextB = '';
  Color TextB = mobileSearchColor;

  String get fullName => widget.fullName;

  String get email => widget.email;

  String get password => widget.password;

  String get Imageidcard => widget.Imageidcard;

  String get day => widget.day;

  String get month => widget.month;

  String get year => widget.year;

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
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            toolbarHeight: 120,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              "PROFILE",
              style: TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
            // ignore: prefer_const_constructors
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(-20),
              child: const Text("Add your personal information\n",
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
                          Container(
                            child: InkWell(
                              onTap: () async {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? file = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                print('${file?.path}');

                                if (file == null) return;
                                String uniqueFileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                Reference referenceRoot =
                                    FirebaseStorage.instance.ref();
                                Reference referenceDirImages =
                                    referenceRoot.child('Profile');
                                Reference referenceImageToUpload =
                                    referenceDirImages.child(
                                        DateTime.now().microsecond.toString());
                                try {
                                  //Store the file
                                  await referenceImageToUpload
                                      .putFile(File(file.path));
                                  //  Success: get the download URL
                                  _ImageProfileController =
                                      await referenceImageToUpload
                                          .getDownloadURL();
                                } catch (error) {
                                  //Some error occurred
                                }
                                setState(() {
                                  media1 = File(file.path);
                                });
                              },
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.transparent,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: media1 != null
                                        ? Image.file(media1!)
                                        : Image.network(
                                            'https://cdn-icons-png.flaticon.com/512/149/149071.png')),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: TextFormField(
                                controller: _DisplaynameController,
                                decoration: textInputDecorationp.copyWith(
                                    counterText:
                                        '${_enteredTextU.length.toString()} /12',
                                    counterStyle: TextStyle(color: TextU),
                                    hintText: "Display Name",
                                    prefixIcon: Icon(
                                      Icons.person_pin_circle_sharp,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                validator: (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  }
                                  if (val.length > 12) {
                                    return 'Limit at 12 characters ';
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    Displayname = val;
                                    _enteredTextU = val;
                                    if (val.length > 12) {
                                      TextU = redColor;
                                    } else {
                                      TextU = mobileSearchColor;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 360,
                            child: TextFormField(
                              controller: _bioController,
                              maxLines: 5,
                              decoration: textInputDecorationp.copyWith(
                                  counterText:
                                      '${_enteredTextB.length.toString()} /160',
                                  counterStyle: TextStyle(color: TextB),
                                  hintText: 'bio',
                                  prefixIcon: Icon(
                                    Icons.pending,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              validator: (val) {
                                if (val!.isNotEmpty) {
                                  return null;
                                }
                                if (val.length > 160) {
                                  return 'Limit at 160 characters ';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  bio = val;
                                  _enteredTextB = val;
                                  if (val.length > 160) {
                                    TextB = redColor;
                                  } else {
                                    TextB = mobileSearchColor;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Gender: '),
                              Radio(
                                value: 'Male',
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                              const Text('Male'),
                              Radio(
                                value: 'Female',
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                              const Text('Female'),
                              Radio(
                                value: 'Other',
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                              const Text('other'),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              alignment: Alignment.center,
                              width: 360,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: purple,
                                    minimumSize: const Size(307, 49),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(color: white, fontSize: 16),
                                ),
                                onPressed: () {
                                  register();
                                  // print(widget.fullName);
                                },
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
    );
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
              fullName,
              email,
              password,
              Imageidcard,
              age,
              _ImageProfileController,
              Displayname,
              gender,
              bio,
              isadmin,
              verify,
              facebook,
              twitter,
              instagram,
              day,
              month,
              year,
              points,
              ban)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          await HelperFunctions.saveUserImageidcardSF(Imageidcard);
          await HelperFunctions.saveUserAgeSF(age);
          await HelperFunctions.saveUserImageprofileSF(_ImageProfileController);
          await HelperFunctions.saveUserDisplaySF(Displayname);
          await HelperFunctions.saveUserGenderSF(gender);
          await HelperFunctions.saveUserBioSF(bio);

          nextScreen(
              context,
              const MyHomePage(
                index: 0,
              ));
        } else {
          showSnackbar(context, redColor, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
