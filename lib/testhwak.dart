import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/admin/user/user.dart';
import 'package:tangteevs/utils/color.dart';

import 'notification/screens/second_screen.dart';
import 'notification/services/local_notification_service.dart';

class testColor extends StatefulWidget {
  const testColor({super.key});

  @override
  State<testColor> createState() => _testColorState();
}

class _testColorState extends State<testColor> {
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: mobileSearchColor,
              size: 30,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserPage(),
                ),
              )
            },
          ),
          title: const Text('Flutter Color Picker Example'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Wrap(
            spacing: 32,
            runSpacing: 10,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await service.showNotification(
                        id: 0, title: 'Notification Title', body: 'Some body');
                  },
                  child: const Text("Item 1")),
              ElevatedButton(
                onPressed: () async {
                  await service.showScheduledNotification(
                    id: 0,
                    title: 'Notification Title',
                    body: 'Some body',
                    seconds: 10,
                  );
                },
                child: const Text('Show Scheduled Notification'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await service.showNotificationWithPayload(
                      id: 0,
                      title: 'Notification Title',
                      body: 'Some body',
                      payload: 'payload navigation');
                },
                child: const Text('Show Notification With Payload'),
              ),
              ElevatedButton(
                  onPressed: () {
                    AwesomeNotifications().createNotification(
                        content: NotificationContent(
                      //with image from URL
                      id: 12345,
                      channelKey: 'image',
                      title: 'Simple Notification with Network Image',
                      body: 'This simple notification is from Flutter App',
                      bigPicture:
                          'https://www.fluttercampus.com/img/logo_small.webp',
                      notificationLayout: NotificationLayout.BigPicture,
                    ));
                  },
                  child: const Text("Image")),
            ],
          ),
        ));
  }
}
