
import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/common_widgets/hexa_color.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'app/astrology/calls/index.dart';
import 'app/bookings/bookings_page.dart';
import 'app/landing_page.dart';
import 'app/notification_back.dart';
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Workmanager().registerOneOffTask("1", "simpleTask");
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final notificationData = message.data;
      print(
          "${message.notification!.title}|||| ${message.data}??????????????????????????????????????????");


    });
    return Future.value(true);
  });
}
void main() async {
  Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
  /*runApp( DevicePreview(
    enabled: true,
    builder: (context) => MyApp(),
  ),);*/
}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        //locale: DevicePreview.of(context).locale, // <--- /!\ Add the locale
        // builder: DevicePreview.appBuilder,
        title: 'Purohit dashboard',
        theme: ThemeData(
          primaryColor: Colors.deepOrangeAccent, //Color(0xFFffbd59),

          fontFamily: 'Montserrat',
        ),
        routes: {'/home': (_) => LandingPage()},
        home: FutureBuilder<Object>(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Provider<AuthBase>(
                  create: (context) => Auth(), child: LandingPage());
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
