import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:tangteevs/HomePage.dart';
import 'package:tangteevs/regis,login/Register.dart';
import 'package:tangteevs/services/auth_service.dart';
import 'package:tangteevs/services/database_service.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'package:tangteevs/helper/helper_function.dart';
import '../admin/home.dart';
import '../services/reset_password.dart';
import '../utils/color.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  String? get uid => FirebaseAuth.instance.currentUser!.uid;

  @override
  _LoginState createState() => _LoginState();
}

late Stream<QuerySnapshot> _stream;

class _LoginState extends State<Login> {
  var auth = FirebaseAuth.instance;
  bool isLogin = false;
  bool isChecked = false;
  var userData = {};
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  final _auth = FirebaseAuth.instance;
  final dbRef =
      FirebaseFirestore.instance.collection('users').doc('admin').get();
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DismissKeyboard(
        child: Scaffold(
          backgroundColor: lightPurple,
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            toolbarHeight: 171,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200)),
                  image: DecorationImage(
                      image: AssetImage("assets/images/login.png"),
                      fit: BoxFit.fill)),
            ),
            backgroundColor: transparent,
            elevation: 0,
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor))
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "WELCOME BACK",
                          style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyCustomFont',
                              color: lightestGreen),
                        ),
                        const SizedBox(
                          height: 05,
                        ),
                        const Text(
                          "Login with TungTee account",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'MyCustomFont',
                              color: primaryColor),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 360,
                          child: TextFormField(
                            controller: emailController,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Email  ',
                              prefixIcon: const Icon(
                                Icons.account_circle,
                                color: green,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
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
                            controller: passwordController,
                            obscureText: _obscured,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Password',
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: green,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
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
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                                onPressed: () {
                                  nextScreen(
                                      context, const ResetPasswordPage());
                                },
                                child: const Text("Forget Password?"))
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        //ElevatedButton.icon(
                        // onPressed: () {
                        //   login();
                        // },
                        // icon: const Icon(Icons.lock_open),
                        // label: const Text('Login'),
                        // ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mobileBackgroundColor,
                              side: const BorderSide(
                                width: 2.0,
                                color: purple,
                              ),
                              minimumSize: const Size(307, 49),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: purple, fontSize: 24),
                          ),
                          onPressed: () {
                            login();
                          },
                        ),

                        //TextButton(
                        // onPressed: () =>
                        //    Navigator.pushNamed(context, '/register'),
                        // child: const Text('ยังไม่มีบัญชีหรอ? สมัครใช้งาน'),
                        // ),
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
                                text: "No account with TungTee? ",
                                style: const TextStyle(
                                    color: primaryColor,
                                    decoration: TextDecoration.none),
                                recognizer: TapGestureRecognizer()),
                            TextSpan(
                                text: "Register",
                                style: const TextStyle(
                                    color: lightGreen,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const RegisterPage());
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

  List<String> docIDs = [];
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          var snap = await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get();
          userData = snap.data()!;
          var a = userData['admin'];
          if (a == true && userData['points'] > 0) {
            nextScreenReplace(context, const AdminHomePage());
          } else if (a == false && userData['points'] > 0) {
            nextScreenReplace(
                context,
                const MyHomePage(
                  index: 0,
                ));
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Ban alert'),
                      content: const Text('you have been ban form tungtee'),
                      actions: [
                        TextButton(
                            onPressed: () =>
                                nextScreenReplace(context, const Login()),
                            child: const Text('ok')),
                      ],
                    ));
          }

          //nextScreenReplace(context, MyHomePage());
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
