import 'package:flutter/material.dart';
import 'services/local_notification_service.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const ListTile(
            title: Text("TungTee"),
            subtitle: Text("Notification ใช้เป็นแบบLocal"),
          ),
          const ListTile(
            title: Text("TungTee"),
            subtitle: Text("ระบบ Cloud Fire Message ยังไม่สามารถใช้งานได้"),
          ),
          ListTile(
            title: const Text("TungTee"),
            subtitle: Text("ยินดีต้องรับสู่แอพ TungTee"),
            onTap: () async {
              await service.showNotification(
                  id: 0, title: 'Notification Title', body: 'Some body');
            },
          )
        ],
      ),
    );
  }
}
