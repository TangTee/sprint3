import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/regis,login/Login.dart';
import 'package:tangteevs/regis,login/Register.dart';
import 'package:tangteevs/utils/color.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'team/team.dart';
import 'team/privacy.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var auth = FirebaseAuth.instance;
  bool isLogin = false;

  checkIfLogin() async {
    auth.userChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 360,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/landing.png"),
                  fit: BoxFit.fill)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo with name.png"),
          const Text.rich(TextSpan(
            text: "Don't have friends to do activities together?",
            style: TextStyle(
                color: mobileSearchColor,
                fontSize: 12,
                fontFamily: 'MyCustomFont',
                fontWeight: FontWeight.bold),
          )),
          const Text.rich(TextSpan(
            text:
                "Come on, let's find a new friend who enjoys the same activities.",
            style: TextStyle(
                color: mobileSearchColor,
                fontSize: 12,
                fontFamily: 'MyCustomFont',
                fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            height: 49,
            width: 600,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  minimumSize: const Size(307, 49),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: const Text(
                "Login",
                style: TextStyle(color: white, fontSize: 24),
              ),
              onPressed: () {
                nextScreen(context, const Login());
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                side: const BorderSide(
                  width: 2.0,
                  color: purple,
                ),
                minimumSize: const Size(307, 49),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            child: const Text(
              "Create Account",
              style: TextStyle(color: mobileBackgroundColor, fontSize: 24),
            ),
            onPressed: () {
              nextScreen(context, const RegisterPage());
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Text.rich(TextSpan(
            text: "By signing in you agree to",
            style: TextStyle(
              color: mobileSearchColor,
              fontSize: 12,
              fontFamily: 'MyCustomFont',
            ),
          )),
          Text.rich(TextSpan(
            style: const TextStyle(
                color: mobileSearchColor,
                fontSize: 12,
                fontFamily: 'MyCustomFont'),
            children: <TextSpan>[
              TextSpan(
                  text: "conditions of use",
                  style: const TextStyle(
                      color: mobileSearchColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      nextScreen(context, const TermsPage());
                    }),
              TextSpan(
                  text: " and ",
                  style: const TextStyle(
                      color: mobileSearchColor,
                      decoration: TextDecoration.none),
                  recognizer: TapGestureRecognizer()),
              TextSpan(
                  text: "our privacy policy",
                  style: const TextStyle(
                      color: mobileSearchColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      nextScreen(context, const PrivacyPage());
                    }),
            ],
          )),
        ],
      ),
    );
  }
}
