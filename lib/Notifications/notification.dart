import 'package:flutter/material.dart';
import 'package:mapapp/Notifications/new_notification.dart';
import 'package:mapapp/Notifications/schedule.dart';

class NotificationsPanel extends StatefulWidget {
  const NotificationsPanel({super.key});

  @override
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    DateTime now = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.black),
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Schedule details',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  child: Text('Send Notification'),
                  onPressed: () {
                    NotificationService.scheduleNotification(
                            schedule: Schedule(
                                details: _controller.text.trim(),
                                time: now.add(const Duration(seconds: 120))))
                        .then((_) {
                      setState(() {
                        _controller.clear();
                      });
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
