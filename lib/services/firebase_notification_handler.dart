import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'OnePage.dart';
import 'notification_handler.dart';

class FirebaseNotificationsA {

  late BuildContext context;

  void setupFirebase(BuildContext context) {
   // _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListner(context);
    NotificationHandler.myContext = context;
  }

  void firebaseCloudMessageListner(BuildContext context) async {
    /*NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );*/


    //get token
    //will use to revcive noti
    //_messaging.getToken().then((value) => print("MyToken: $value"));
    // _messaging.subscribeToTopic("edmtdev_demo").whenComplete(() => print("SUBSCRIBED OK"));

    FirebaseMessaging.onMessage.listen((event) {
      print("<<<<<<<<<<[ THIS IS FOREGROUND NOTIFICATION ]>>>>>>>>>>>>>");
      switch (event.data['type']) {
        case 'Booking':
          print("<<<<<<<<<<[ THIS IS BOOKING  ]>>>>>>>>>>>>>");
          showBookingNotification(
              event.notification!.title, event.notification!.body);
          break;
        case 'Message':
          print("<<<<<<<<<<[ THIS IS MESSAGE  ]>>>>>>>>>>>>>");
          showMessageNotification(
              event.notification!.title, event.notification!.body);
          break;
        case 'VCall':
          print("<<<<<<<<<<[ THIS IS VCALL  ]>>>>>>>>>>>>>");
          showCallNotification(
              event.notification!.title,
              event.notification!.body,
              event.data['call_type'],
              event.data['channel']);
          break;
        default:
          print("<<<<<<<<<<[ THIS IS DEFAULT  ]>>>>>>>>>>>>>");
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("<<<<<<<<<<[ I DON'T THINk THIS CODE WILL WORK ]>>>>>>>>>>>>>");
      if (event.data['type'] == 'Message') {
        print("[WHAT THE FUCK B]");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => OnePage()));
      }
      if (Platform.isIOS)
        showDialog(
            context: NotificationHandler.myContext,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(event.notification!.title!),
                  content: Text(event.notification!.body!),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('OK'),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      isDefaultAction: true,
                    )
                  ],
                ));
    });
  }

  static void showNotification(title, body) async {
    print("<<<<<<<<<<[ THIS IS SIMPLE NOTIFICATION ]>>>>>>>>>>>>>");
    var androidChannel = AndroidNotificationDetails(
        "com.pujapurohit.brabjbjjhminapp",
        "channelhjhName",
        "channelDescription",
        ongoing: true,
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification'));
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin.show(
        Random().nextInt(1000), title, body, platform,
        payload: "vtk" + "*" + title);
  }

  static void showMessageNotification(title, body) async {
    print("<<<<<<<<<<[ THIS IS MESSAGE NOTIFICATION ]>>>>>>>>>>>>>");
    var androidChannel = AndroidNotificationDetails(
        "com.pujapurohit.brabjbjjhminapp",
        "channelhjhName",
        "channelDescription",
        ongoing: true,
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification'));
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin.show(
        Random().nextInt(1000), title, body, platform,
        payload: "Message" + "*" + "vtk");
  }

  static void showCallNotification(title, body, channel, callType) async {
    print("<<<<<<<<<<[ THIS IS CALL NOTIFICATION ]>>>>>>>>>>>>>");
    var androidChannel = AndroidNotificationDetails(
        "com.pujapurohit.brjnjnkahminapp",
        "channvhvhvhelName",
        "channelbjDescription",
        importance: Importance.high,
        fullScreenIntent: true,
        priority: Priority.high,
        ticker: 'ticker',
        color: Colors.red,
       // ongoing: true,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
        additionalFlags:
            Int32List.fromList(<int>[4,0]));//512, 4096,0, 2,
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin.show(
        Random().nextInt(1000), title, body, platform,
        payload: channel + "*" + callType);
  }

  static void showBookingNotification(title, body) async {
    print(
        "<<<<<<<<<<[ THIS IS BOOKING NOTIFICATION ]>>>>>>>>>>>>>$title $body");
   // const int insistentFlag = 4;
    var androidChannel = AndroidNotificationDetails(
        "com.pujapurohit.brjnjnkahminapp",
        "channvhvhvhelName",
        "channelbjDescription",
        importance: Importance.high,
        fullScreenIntent: true,
        priority: Priority.high,
        ticker: 'ticker',
        color: Colors.red,
       // ongoing: true,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
        additionalFlags:
            Int32List.fromList(<int>[4]));
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin.show(
        Random().nextInt(1000), title, body, platform,
        payload: "Booking" + "*" + title);
  }
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }
}
