import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/services/firebase_notification_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/services/auth.dart';
import 'app/landing_page.dart';

final GlobalKey<NavigatorState> navigationKey =
    GlobalKey(debugLabel: "Main Navigator");

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("<<<<<<<<<<[ THIS IS BACKGROUND NOTIFICATION ]>>>>>>>>>>>>>");
  await Firebase.initializeApp();
  print("${message.notification} |||||||||||| ${message.data}");
  switch (message.data['type']) {
    case 'Booking':
      print("<<<<<<<<<<[ THIS IS BOOKING  ]>>>>>>>>>>>>>");
      FirebaseNotificationsA.showBookingNotification(
          message.notification!.title, message.notification!.body);

      break;
    case 'Message':
      print("<<<<<<<<<<[ THIS IS MESSAGE  ]>>>>>>>>>>>>>");
      FirebaseNotificationsA.showMessageNotification(
          message.notification!.title, message.notification!.body);
      break;
    case 'VCall':
      print("<<<<<<<<<<[ THIS IS VCALL  ]>>>>>>>>>>>>>");
      FirebaseNotificationsA.showCallNotification(
          message.notification!.title,
          message.notification!.body,
          message.data['call_type'],
          message.data['channel']);
      break;
    default:
      print("<<<<<<<<<<[ THIS IS DEFAULT NOTIFICATION ]>>>>>>>>>>>>>");
      FirebaseNotificationsA.showNotification(
          message.notification!.title, message.notification!.body);
  }
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
  /*runApp( DevicePreview(
    enabled: true,
    builder: (context) => MyApp(),
  ),);*/
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseNotificationsA firebaseNotificationsA = FirebaseNotificationsA();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      firebaseNotificationsA.setupFirebase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        //locale: DevicePreview.of(context).locale, // <--- /!\ Add the locale
        // builder: DevicePreview.appBuilder,
        title: 'Purohit dashboard',
        navigatorKey: navigationKey,
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
