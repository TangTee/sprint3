import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tangteevs/utils/color.dart';

import '../regis,login/Login.dart';
import '../widgets/custom_textfield.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DismissKeyboard(
        child: Scaffold(
          backgroundColor: lightPurple,
          appBar: AppBar(
            toolbarHeight: 150,
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/reset.png"),
                      fit: BoxFit.scaleDown)),
            ),
            backgroundColor: transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  Image.asset("assets/images/reset.png"),
                  const Text("Reset password",
                      style: TextStyle(
                          fontSize: 51,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MyCustomFont',
                          color: lightGreen)),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Don’t worry! It happens.",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MyCustomFont',
                          color: primaryColor)),
                  const Text(
                      "Plase enter Your E-mail address to reset you password\n",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MyCustomFont',
                          color: primaryColor)),
                  const SizedBox(
                    height: 35,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 360,
                    child: TextField(
                      controller: _emailController,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Your E-mail',
                        hintStyle: const TextStyle(),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: primaryColor,
                        side: const BorderSide(
                          width: 2.0,
                          color: purple,
                        ),
                        minimumSize: const Size(307, 49),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: const Text(
                      "Send",
                      style: TextStyle(color: purple, fontSize: 24),
                    ),
                    onPressed: () {
                      String email = _emailController.text;
                      _auth.sendPasswordResetEmail(email: email).then((value) {
                        print('Password reset email sent');
                        _showResetEmailSentDialog();
                      }).catchError((error) {
                        print('Error sending password reset email: $error');
                        _showErrorDialog();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(
                    style: const TextStyle(
                        color: mobileSearchColor,
                        fontSize: 12,
                        fontFamily: 'MyCustomFont'),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Back to ",
                          style: const TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.none),
                          recognizer: TapGestureRecognizer()),
                      TextSpan(
                          text: "Login Page",
                          style: const TextStyle(
                              color: lightGreen,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const Login());
                            }),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showResetEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Email Sent'),
          content: const Text(
              'Check your email for instructions on how to reset your password.'),
          actions: [
            TextButton(
              onPressed: () {
                nextScreen(context, const Login());
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Sending Email'),
          content: const Text('No email match. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
