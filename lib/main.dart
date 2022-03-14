import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'landing_page.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Map<int, Color> colorCodes = {
      50: Color.fromRGBO(197, 205, 72, .1),
      100: Color.fromRGBO(147, 205, 72, .2),
      200: Color.fromRGBO(147, 205, 72, .3),
      300: Color.fromRGBO(147, 205, 72, .4),
      400: Color.fromRGBO(147, 205, 72, .5),
      500: Color.fromRGBO(147, 205, 72, .6),
      600: Color.fromRGBO(147, 25, 72, .7),
      700: Color.fromRGBO(147, 205, 72, .8),
      800: Color.fromRGBO(147, 205, 72, .9),
      900: Color.fromRGBO(255, 153, 51, 1),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.green,
      title: 'iPurohit',
      home: LandingPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.yellow.shade50,
        colorScheme: ColorScheme(
          background: Colors.teal,
          brightness: Brightness.light,
          onBackground: Colors.orangeAccent,
          onPrimary: Colors.black,
          //Color.fromRGBO(255, 190, 48, 1),
          onError: Colors.green,
          onSecondary: Colors.black,
          error: Colors.black12,
          onSurface: Colors.purple,
          secondary: Color.fromRGBO(255, 190, 48, 1),
          surface: Colors.deepPurple,
          primary: Colors.yellow.shade50,
        ).copyWith(
            //secondary: Colors.pink,
            ),
        /*textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.purple),
            titleLarge: TextStyle(color: Colors.black54)),*/
      ),
    );
  }
}
