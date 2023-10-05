
import 'dart:io' show Platform;

import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

// import 'package:timezone/data/latest.dart' as tz;


import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/ui/notified_page.dart';


import '../models/task.dart';

class NotifyHelper{
  int id = 0;


  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {

    //tz.initializeTimeZones();
    _configureLocalTimezone();
    // this is for latest iOS settings
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );


    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("appicon");

      final InitializationSettings initializationSettings =
      InitializationSettings(
      iOS: initializationSettingsIOS,
      android:initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:  (NotificationResponse notificationResponse) async {
          switch (notificationResponse.notificationResponseType) {
            case NotificationResponseType.selectedNotification:
              // selectNotificationStream.add(notificationResponse.payload);
              print('notification payload NotificationResponseType selectedNotification: ${notificationResponse.payload}');
              await Get.to( NotifiedPage(label:  notificationResponse.payload!));
              break;
            case NotificationResponseType.selectedNotificationAction:
              // if (notificationResponse.actionId == navigationActionId) {
              //   selectNotificationStream.add(notificationResponse.payload);
              // }
              print("Notification Done NotificationResponseType selectedNotificationAction");
              break;
          }
          // Get.to(()=>Container(color: Colors.white,));
        },);

  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

  }
  Future<void> isAndroidPermissionGranted() async {
    print("isAndroidPermissionGranted();");
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;

      // setState(() {
      //   _notificationsEnabled = granted;
      // });
    }
  }
  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      print("requestPermissions Android");
      final bool? granted = await androidImplementation?.requestPermission();
      print("granted is  $granted");

      // setState(() {
      //   _notificationsEnabled = granted ?? false;
      // });
    }
  }



  Future<void> displayNotification({required String title, required String body}) async {
    print("doing test  displayNotification ");
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        title,
        body,
        notificationDetails,
        payload: '1::task 240::this task'
    );
  }

  scheduledNotificationMaster({required String title, required String body}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id++,
        title,
        body,
        // 0,
        // 'scheduled title',
        // 'theme changes 5 seconds ago',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);

  }

  scheduledTaskNotification(Task task) async {
    DateTime myTime = DateFormat('HH:mm a').parse(task.startTime.toString());
    int hour = int.parse(DateFormat.H().format(myTime));
    int minute = int.parse(DateFormat.m().format(myTime));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!,
        "${task.title}",
        "${task.note}",
        _convertTime(hour , minute),
        // 0,
        // 'scheduled title',
        // 'theme changes 5 seconds ago',
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'full screen channel id', 'full screen channel name',
                channelDescription: 'full screen channel description',
                priority: Priority.high,
                importance: Importance.high,
                fullScreenIntent: true)
            ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:DateTimeComponents.time,
        payload: "${task.id}::${task.title}::${task.note}",
    );




  }
  tz.TZDateTime _convertTime(int hour , int minute){
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduleDate =
          tz.TZDateTime(tz.local , now.year , now.month , now.day , hour , minute);
      if(scheduleDate.isBefore(now)){
        scheduleDate = scheduleDate.add(const Duration (days: 1));
      }
      print("now $now");
      print("tz.local ${tz.local}");
      print("scheduleDate");
      print(scheduleDate);
      return scheduleDate;
  }
 Future<void>  _configureLocalTimezone() async{
    tz.initializeTimeZones();
    // get device timezone
     String timezone = 'Unknown';
     try {
       timezone = await FlutterTimezone.getLocalTimezone();
     } catch (e) {
       timezone = "	Africa/Bujumbura";
     }
     print("timezone is $timezone ");
    tz.setLocalLocation(tz.getLocation(timezone));
    // DateTime dateTime = DateTime.now();
    // String timeZoneName = dateTime.timeZoneName;
    // Duration timeZoneOffset = dateTime.timeZoneOffset;
    // print("dateTime is $dateTime ");
    // print("timeZoneName is $timeZoneName ");
    // print("timeZoneOffset is $timeZoneOffset ");
  }
  // displayNotification({required String title, required String body}) async {
  //   print("doing test");
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.max, priority: Priority.high);
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'You change your theme',
  //     'You changed your theme back !',
  //     platformChannelSpecifics,
  //     payload: 'It could be anything you pass',
  //   );
  // }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
   Get.dialog(Text("Welcome to flutter"));
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      print('notification payloadggggg: $payload');
    } else {
      print("Notification Done");
    }
    await Get.to( NotifiedPage(label: payload));
  }
}