import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tangteevs/Landing.dart';
import 'package:tangteevs/admin/user/data.dart';
import 'package:tangteevs/admin/user/verify.dart';
import 'package:tangteevs/testhwak.dart';
import '../../HomePage.dart';
import '../../notification/screens/second_screen.dart';
import '../../notification/services/local_notification_service.dart';
import '../../utils/color.dart';
import '../../widgets/custom_textfield.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => SecondScreen(payload: payload))));
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // hwak 1
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 3.0),
                title: const Center(
                  child: Text(
                    'test hwak',
                    style: TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                  ),
                ),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const testColor();
                      },
                    ),
                    (_) => false,
                  );
                },
              ),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 3.0),
                title: const Center(
                  child: Text(
                    'Go to User page',
                    style: TextStyle(fontFamily: 'MyCustomFont', fontSize: 20),
                  ),
                ),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const MyHomePage(
                          index: 4,
                        );
                      },
                    ),
                    (_) => false,
                  );
                },
              ),
              // hwak2

              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 3.0),
                title: const Center(
                    child: Text(
                  'Logout',
                  style: TextStyle(
                      fontFamily: 'MyCustomFont',
                      fontSize: 20,
                      color: redColor),
                )),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  nextScreenReplaceOut(context, const LandingPage());
                },
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     // await service.showNotification(
              //     //     id: 0,
              //     //     title: 'Notification Title',
              //     //     body: 'Some body');
              //     // String? fcmKey = await getFcmToken();
              //     // print('FCM Key: $fcmKey');
              //   },
              //   child: const Text("Item 1"),
              // ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 3.0),
                title: const Center(
                    child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: redColor,
                      fontFamily: 'MyCustomFont',
                      fontSize: 20),
                )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final foregroundColor =
    //     useWhiteForeground(currentColor) ? Colors.white : Colors.black;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: mobileBackgroundColor,
          elevation: 1,
          leadingWidth: 130,
          centerTitle: true,
          leading: Container(
            padding: const EdgeInsets.all(0),
            child: Image.asset('assets/images/logo with name.png',
                fit: BoxFit.scaleDown),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: purple,
                size: 30,
              ),
              onPressed: () {
                _showModalBottomSheet(context);
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: green,
            labelColor: green,
            labelPadding: EdgeInsets.symmetric(horizontal: 30),
            unselectedLabelColor: unselected,
            labelStyle: TextStyle(fontSize: 20.0, fontFamily: 'MyCustomFont'),
            unselectedLabelStyle:
                TextStyle(fontSize: 20.0, fontFamily: 'MyCustomFont'),
            tabs: [
              Tab(text: 'Verify'),
              Tab(text: 'Data'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VerifyPage(),
            SearchData(),
          ],
        ),
      ),
    );
  }
}
