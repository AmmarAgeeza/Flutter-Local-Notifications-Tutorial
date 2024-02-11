import 'dart:async';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse notificationResponse) {
    // log(notificationResponse.id!.toString());
    // log(notificationResponse.payload!.toString());
    streamController.add(notificationResponse);
    // Navigator.push(context, route);
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //basic Notification
  static void showBasicNotification() async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
        'id 1', 'basic notification',
        importance: Importance.max,
        priority: Priority.high,
        sound:
            RawResourceAndroidNotificationSound('sound.wav'.split('.').first));
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Baisc Notification',
      'body',
      details,
      payload: "Payload Data",
    );
  }

  //basic Notification2
  static void showBasicNotification2() async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
        'id 3', 'basic notification1',
        importance: Importance.max,
        priority: Priority.high,
        sound:
            RawResourceAndroidNotificationSound('sound.wav'.split('.').first));
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      4,
      'Basic Notification',
      'body',
      details,
      payload: "Payload Data",
    );
  }

  //showRepeatedNotification
  static void showRepeatedNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'id 2',
      'repeated notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      'Reapated Notification',
      'body',
      RepeatInterval.everyMinute,
      details,
      payload: "Payload Data",
    );
  }

  //showSchduledNotification
  static void showSchduledNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'id 3',
      'schduled notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = const NotificationDetails(
      android: android,
    );
    tz.initializeTimeZones();
    log(tz.local.name);
    log("Before ${tz.TZDateTime.now(tz.local).hour}");
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    log(tz.local.name);
    log("After ${tz.TZDateTime.now(tz.local).hour}");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'Schduled Notification',
      'body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      // tz.TZDateTime(
      //   tz.local,
      //   2024,
      //   2,
      //   10,
      //   21,
      //   30,
      // ),
      details,
      payload: 'zonedSchedule',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }


}

//1.setup. [Done]
//2.Basic Notification. [Done]
//3.Repeated Notification. [Done]
//4.Scheduled Notification. [Done]
//5.Custom Sound. [Done]
//6.on Tab. [Done]
//7.Daily Notifications at specific time.
//8.Real Example in ToDo App.