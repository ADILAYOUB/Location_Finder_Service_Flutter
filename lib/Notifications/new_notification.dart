import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/Notifications/schedule.dart';

class NotificationService{
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreateMethod(ReceivedNotification receivedNotification)async{

  }


    @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayMethod(ReceivedNotification receivedNotification)async{
    
  }

    @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction)async{
    
  }

    @pragma("vm:entry-point")
  static Future<void> onActionReceiveMethod(ReceivedAction receivedAction)async{
    
  }

  static Future<void> scheduleNotification({required Schedule schedule})async{
    Random random = Random();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: random.nextInt(100),
        channelKey: 'basic_channel',
        title: 'Reminder',
        body: schedule.details,
        category: NotificationCategory.Reminder,
        notificationLayout: NotificationLayout.BigText,
        locked: true,
        autoDismissible: false,
        fullScreenIntent: true,
        backgroundColor: Colors.transparent,
      ),
      schedule: NotificationCalendar(
        minute: schedule.time.minute,
        hour: schedule.time.hour,
        day: schedule.time.day,
        weekday: schedule.time.weekday,
        month: schedule.time.month,
        year: schedule.time.year,
        preciseAlarm: true,
        allowWhileIdle: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'Close',
          label: 'Close Reminder',
          autoDismissible: true,
        )
      ]
    );
  }

}