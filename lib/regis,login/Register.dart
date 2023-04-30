import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/regis,login/idcard.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import '../utils/color.dart';
import 'Login.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegisterPage> {
  bool isChecked = false;
  File? media;
  File? media1;
  final bool _isLoading = false;
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String password2 = "";
  String fullName = "";
  AuthService authService = AuthService();
  bool verify = false;
  bool isadmin = false;
  final textEditingController = TextEditingController();
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  bool _obscured1 = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void _toggleObscured1() {
    setState(() {
      _obscured1 = !_obscured1;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = 'Select Gender';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DismissKeyboard(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: transparent,
            toolbarHeight: 120,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              "REGISTER",
              style: TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
            // ignore: prefer_const_constructors
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(-20),
              child: const Text("CERATE YOUR ACCOUNT",
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
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: ExactAssetImage(
                                    "assets/images/background.png"),
                                fit: BoxFit.cover),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 35,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 360,
                                child: TextFormField(
                                  decoration: textInputDecorationp.copyWith(
                                      hintText: "Username",
                                      prefixIcon: Icon(
                                        Icons.person_pin_circle_sharp,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  onChanged: (val) {
                                    setState(() {
                                      fullName = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Name cannot be empty";
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 360,
                                child: TextFormField(
                                  decoration: textInputDecorationp.copyWith(
                                      hintText: "Email",
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  onChanged: (val) {
                                    setState(() {
                                      email = val;
                                    });
                                  },

                                  // check tha validation
                                  validator: (val) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val!)
                                        ? null
                                        : "Please enter a valid email";
                                  },
                                ),
                              ),
                              const SizedBox(height: 25),
                              Container(
                                alignment: Alignment.center,
                                width: 360,
                                child: TextFormField(
                                  obscureText: _obscured,
                                  decoration: textInputDecorationp.copyWith(
                                    hintText: "Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    suffixIcon: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                      child: GestureDetector(
                                        onTap: _toggleObscured,
                                        child: Icon(
                                          _obscured
                                              ? Icons.visibility_rounded
                                              : Icons.visibility_off_rounded,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val!.length < 6) {
                                      return "Password must be at least 6 characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      password = val;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 360,
                                child: TextFormField(
                                  obscureText: _obscured1,
                                  decoration: textInputDecorationp.copyWith(
                                    hintText: "Confirm Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    suffixIcon: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                      child: GestureDetector(
                                        onTap: _toggleObscured1,
                                        child: Icon(
                                          _obscured
                                              ? Icons.visibility_rounded
                                              : Icons.visibility_off_rounded,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (password == password2) {
                                      return null;
                                    } else {
                                      return "Password does not match";
                                    }
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      password2 = val;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 55,
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
                                      register();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text.rich(TextSpan(
                                text: "Already have an account? ",
                                style: const TextStyle(
                                    color: mobileSearchColor, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: " Login",
                                      style: const TextStyle(
                                          color: mobileSearchColor,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(context, const Login());
                                        }),
                                ],
                              )),
                            ],
                          ),
                        )),
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
          IdcardPage(
            email: email,
            fullName: fullName,
            password: password,
          ));
    }
  }
}
