import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/astrology/calls/index.dart';
import 'package:brahminapp/app/bookings/bookings_page.dart';
import 'package:brahminapp/app/services_given/services_page.dart';
import 'package:brahminapp/main.dart';
import 'package:brahminapp/services/OnePage.dart';
import 'package:brahminapp/services/TempMessage.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'auth.dart';

//final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
class NotificationHandler {

  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
static final notificationAppLaunchDetails=NotificationAppLaunchDetails(true, "payload");
  static late BuildContext myContext;

  static void initNotification(BuildContext context) {
    myContext = context;
    var initAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIos = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSetting =
        InitializationSettings(android: initAndroid, iOS: initIos);
    flutterLocalNotificationPlugin.initialize(initSetting,
        onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String? payload) async {
    //List<String> data = payload!.split("*");
   Navigator.of(navigationKey.currentState!.context).push(MaterialPageRoute(
        builder: (context) => HandleNotificationRouting(payload: payload,))
    );
    //  Navigator.of(navigationKey.currentState!.context).push(MaterialPageRoute(builder: (context)=>IndexPage(userId: userId,)));
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
        context: myContext,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title!),
              content: Text(body!),
              actions: [
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  isDefaultAction: true,
                )
              ],
            ));
  }
}
