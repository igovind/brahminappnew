import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/services/Splash_Screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/app/landing_page.dart';
import 'package:brahminapp/services/auth.dart';

void main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
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
      //locale: DevicePreview.of(context).locale, // <--- /!\ Add the locale
      builder: DevicePreview.appBuilder,
      title: 'Purohit dashboard',
      theme: ThemeData(
        primaryColor: Color(0XFFffbd59),
        fontFamily: 'Montserrat',
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Object>(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return Provider<AuthBase>(
                create: (context) => Auth(),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  //locale: DevicePreview.of(context).locale, // <--- /!\ Add the locale
                 // builder: DevicePreview.appBuilder,
                 builder: BotToastInit(),
                  navigatorObservers: [BotToastNavigatorObserver()],
                  title: 'Purohit dashboard',
                  theme: ThemeData(
                    primaryColor: Color(0xFFffbd59),
                    //primarySwatch: Colors.deepOrange,
                    fontFamily: 'Montserrat',
                  ),
                  home: SplashScreen(),
                  routes: {'/home': (_) => LandingPage()},
                ),
              );
            }
            return Scaffold(
                body: Center(
                    child: Text('Loading.....') //CircularProgressIndicator()
                    ));
          }),
    );
  }
}
