import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/regis,login/Login.dart';
import 'package:tangteevs/regis,login/Register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> _userSubscription;
  bool initialRoute = false;

  @override
  void initState() {
    super.initState();
    _userSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (mounted) {
          setState(() {
            initialRoute = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            initialRoute = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialRoute
          ? const MyHomePage(
              index: 0,
            )
          : const LandingPage(),
      routes: {
        '/Landing': (context) => const LandingPage(),
        '/Login': (context) => const Login(),
        '/Register': (context) => const RegisterPage(),
        '/HomePage': (context) => const MyHomePage(index: 0),
        '/Activity': (context) => const MyHomePage(index: 1),
        '/Post': (context) => const MyHomePage(index: 2),
        '/Chat': (context) => const MyHomePage(index: 3),
        '/Profile': (context) => const MyHomePage(index: 4),
      },
    );
  }
}
