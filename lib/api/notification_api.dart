import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/tzdata.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel name',
        'channel description',
        importance: Importance.max,
      ), // AndroidNotificationDetails
      iOS: IOSNotificationDetails(),
    ); // NotificationDetails
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('ic_launcher.png');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  static Future showNotification({
    int id = 0,
    String title,
    String body,
    String payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );
  // static Future showScheduleNotification({
  //   int id = 0,
  //   String title,
  //   String body,
  //   String payload,
  //   @required DateTime scheduleDate,
  // }) async =>
  //     _notifications.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tz.TZDateTime.from(scheduleDate, tz.local),
  //       await _notificationDetails(),
  //       payload: payload,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //     );
}
