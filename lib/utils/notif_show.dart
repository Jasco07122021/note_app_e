import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive/hive.dart';

class Utils {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initNotificationToken() async {
    await firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true);
    firebaseMessaging.getToken().then((token) async {
      Hive.box('note').put("token", token);
    });
  }

  static void initNotification(context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Utils.showLocalNotification(message, context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message, context);
    });
  }

  static Future<void> showLocalNotification(
      RemoteMessage message, BuildContext context) async {
    String title = message.notification!.title!;
    String body = message.notification!.body!;

    var android = const AndroidNotificationDetails("channelId", "channelName",
        channelDescription: "channelDescription");
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);

    int id = Random().nextInt((pow(2, 31) - 1).toInt());
    await FlutterLocalNotificationsPlugin().show(id, title, body, platform);

    showToastWidget(
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          alignment: Alignment.centerLeft,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                body,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
        context: context,
        animation: StyledToastAnimation.slideFromTop,
        reverseAnimation: StyledToastAnimation.slideToTop,
        position: StyledToastPosition.top,
        startOffset: const Offset(0.0, -3.0),
        reverseEndOffset: const Offset(0.0, -3.0),
        duration: const Duration(seconds: 4),
        //Animation duration   animDuration * 2 <= duration
        animDuration: const Duration(seconds: 2),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn);
  }
}
