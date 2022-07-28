// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:todotasks/presentation/resources/routes_manager.dart';

// import 'package:todotasks/presentation/screens/detailes/details.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../app/app.dart';
import '../models/tasks_model.dart';

class NotificationApi {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static initializeNotification() async {
    tz.initializeTimeZones();

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('welcome');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectNotification(payload!);
      },
    );
  }

  static displayNotification(
      {required String title, required String body}) async {
    debugPrint('doing test');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    navigatorKey.currentState!.pushNamed(Routes.scheduleRoute);
  }

  static scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  static tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, int remind, String repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var formatedDate = DateFormat.yMd().parse(date);
    tz.TZDateTime fd = tz.TZDateTime.from(formatedDate, tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);
    scheduledDate = afterDate(remind, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      if (repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formatedDate.day) + 1, hour, minutes);
      }
      if (repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formatedDate.day) + 1, hour, minutes);
      }
      if (repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formatedDate.day) + 1, hour, minutes);
      }
      scheduledDate = afterDate(remind, scheduledDate);
    }
    debugPrint("scheduleDate$scheduledDate");
    return scheduledDate;
  }

  static cancelNotification(int id) async {
    flutterLocalNotificationsPlugin.cancel(id);
    debugPrint("notification canceled");
  }

  static cancelAllNotification() async {
    flutterLocalNotificationsPlugin.cancelAll();
    debugPrint("All notification canceled");
  }

  static tz.TZDateTime afterDate(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 20));
    }
    return scheduledDate;
  }

  static void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

// older ios
  static void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {}
}

























// await flutterLocalNotificationsPlugin.zonedSchedule(
//     0,
//     'scheduled title',
//     'scheduled body',
//     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//     const NotificationDetails(
//         android: AndroidNotificationDetails(
//             'your channel id', 'your channel name',
//             channelDescription: 'your channel description')),
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime);
// }

// class NotificationService {
//   //Singleton pattern
//   static final NotificationService _notificationService =
//       NotificationService._internal();
//   factory NotificationService() {
//     return _notificationService;
//   }
//   NotificationService._internal();

//   //instance of FlutterLocalNotificationsPlugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     //Initialization Settings for Android
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('welcome');

// //Initialization Settings for iOS devices
//     const IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );

//     //InitializationSettings for initializing settings for both platforms (Android & iOS)
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }

//   Future selectNotification(String? payload) async {
//     await navigateTo(Routes.notificationsRoute);
//   }

//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   static Future<dynamic> navigateTo(String routeName) {
//     return navigatorKey.currentState!.pushNamed(routeName);
//   }

//   void requestIOSPermissions(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }
// }
