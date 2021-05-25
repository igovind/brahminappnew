import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/account/account_page.dart';
import 'package:brahminapp/app/astrology/calls/index.dart';
import 'package:brahminapp/app/astrology/edit_astrology_price.dart';
import 'package:brahminapp/app/bookings/bookings_page.dart';
import 'package:brahminapp/app/services_given/services_page.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:circle_bottom_navigation_bar/circle_bottom_navigation_bar.dart';
import 'package:circle_bottom_navigation_bar/widgets/tab_data.dart';

import '../languages.dart';
import 'home_page2.dart';

class ExtBotNavBar extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot>? userDataSnapshot;
  final UserId? user;
  final language;

  const ExtBotNavBar(
      {Key? key, this.user, this.userDataSnapshot, this.language})
      : super(key: key);

  @override
  _ExtBotNavBarState createState() => _ExtBotNavBarState();
}

class _ExtBotNavBarState extends State<ExtBotNavBar> {
  int currentPage = 0;

  Widget bodyContainer(
      {AsyncSnapshot<DocumentSnapshot>? tabImageSnapshot,
      AsyncSnapshot<DocumentSnapshot>? userDataSnapshot}) {
    switch (currentPage) {
      case 0:
        //slogan = "Familly, Happiness, Food";
        return HomePageFolder(
          language: widget.language,
          userId: widget.user,
          snapshot: tabImageSnapshot,
          userDataSnapshot: userDataSnapshot,
        );
        break;
/*      case 1:
        return NewsFeedSextion(
          uid: null,
        );
        break;*/
      case 1:
        return BookingsPage(
          language: widget.language,
          userId: widget.user,
        );
        break;
      case 2:
        return ServicesPage(
          language: widget.language,
          userId: widget.user,
        );
        break;
      case 3:
        return EditAstrologyPrices(
          language: widget.language,
          snapshot: userDataSnapshot,
          userId: widget.user,
        );
        break;
      case 4:
        return StreamBuilder<DocumentSnapshot>(
            stream: FireStoreDatabase(uid: widget.user!.uid).getAdhaarDetails,
            builder: (context, adhaarsnapshot) {
              if (adhaarsnapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StreamBuilder<DocumentSnapshot>(
                  stream:
                      FireStoreDatabase(uid: widget.user!.uid).getBankDetails,
                  builder: (context, bankSnapshot) {
                    if (bankSnapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return AccountPage(
                      userId: widget.user,
                      snapshot: userDataSnapshot,
                      adhaarSnapshot: adhaarsnapshot,
                      bankSnapshot: bankSnapshot,
                    );
                  });
            });
        break;
    }
    return Text("error");
  }

  List<TabData> getTabsData() {
    return [
      TabData(
        icon: Icons.home,
        iconSize: 18.0,
        title: Language(
            code: widget.language,
            text: ["Home ", "घर ", "বাড়ি ", "வீடு ", "హోమ్ "]).getText,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      TabData(
        icon: Icons.person_add_alt_1,
        iconSize: 18,
        title: Language(
                code: widget.language,
                text: ["Booking ", "बुकिंग ", "সংরক্ষণ ", "பதிவு ", "బుకింగ్ "])
            .getText,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      TabData(
        icon: Icons.layers,
        iconSize: 25,
        title: Language(
            code: widget.language,
            text: ["Service ", "सेवा ", "সেবা ", "சேவை ", "సేవ "]).getText,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      TabData(
        icon: Icons.star,
        iconSize: 18,
        title: Language(code: widget.language, text: [
          "Astrology ",
          "ज्योतिष",
          "জ্যোতিষ ",
          "ஜோதிடம் ",
          "జ్యోతిషశాస్త్రం"
        ]).getText,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      TabData(
        icon: Icons.account_circle,
        iconSize: 18,
        title: Language(
            code: widget.language,
            text: ["Account ", "खाता ", "হিসাব ", "கணக்கு ", "ఖాతా "]).getText,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ];
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
/*    void handleRouting(RemoteNotification notification) {
      //final database = Provider.of<DatabaseL>(context, listen: false);
      switch (notification.) {
        case 'Booking':
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BookingsPage()));
          break;
        case 'VCall':
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IndexPage(
                        channelName: notification,
                      )));
          break;
      }
    }*/

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final notificationData = message.data;
      print(
          "${message.notification!.title}|||| ${message.data}??????????????????????????????????????????");
      switch (message.data['type']) {
        case 'Booking':
          BotToast.showSimpleNotification(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookingsPage()));
            },
            animationDuration: Duration(seconds: 2),
            hideCloseButton: true,
            title: notification!.title as String,
            subTitle: notification.body as String,
            duration: Duration(seconds: 10),
          );
          break;
        case 'Message':
          BotToast.showSimpleNotification(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookingsPage()));
            },
            animationDuration: Duration(seconds: 2),
            hideCloseButton: true,
            title: notification!.title as String,
            subTitle: notification.body as String,
            duration: Duration(seconds: 10),
          );
          break;
        case 'VCall':
          BotToast.showSimpleNotification(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IndexPage(
                            channelName: notificationData['channel'],
                            callType: notificationData['call_type'],
                            userId: widget.user,
                          )));
            },
            animationDuration: Duration(seconds: 2),
            hideCloseButton: true,
            title: notification!.title as String,
            subTitle: notification.body as String,
            duration: Duration(seconds: 10),
          );
      }
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        final type = message.data['type'];
        switch (type) {
          case 'Booking':
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BookingsPage()));
            break;
          case 'VCall':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndexPage(
                      channelName: notificationData['channel'],
                      callType: notificationData['call_type'],
                      userId: widget.user,
                    )));
            break;
        }
      });
      FirebaseMessaging.onBackgroundMessage((message) async{
        final type = message.data['type'];
        switch (type) {
          case 'Booking':
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BookingsPage()));
            break;
          case 'VCall':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndexPage(
                      channelName: notificationData['channel'],
                      callType: notificationData['call_type'],
                      userId: widget.user,
                    )));
            break;
        }
        return null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewPadding = MediaQuery.of(context).viewPadding;
    double barHeight;
    double barHeightWithNotch = 67;
    double arcHeightWithNotch = 67;

    if (size.height > 700) {
      barHeight = 60;
    } else {
      barHeight = size.height * 0.1;
    }

    if (viewPadding.bottom > 0) {
      barHeightWithNotch = (size.height * 0.07) + viewPadding.bottom;
      arcHeightWithNotch = (size.height * 0.075) + viewPadding.bottom;
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FireStoreDatabase(uid: widget.user!.uid).getTabImages,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            return bodyContainer(
                userDataSnapshot: widget.userDataSnapshot,
                tabImageSnapshot: snapshot);
          }),
      bottomNavigationBar: CircleBottomNavigationBar(
        initialSelection: currentPage,
        barHeight: viewPadding.bottom > 0 ? barHeightWithNotch : barHeight,
        arcHeight: viewPadding.bottom > 0 ? arcHeightWithNotch : barHeight,
        itemTextOff: viewPadding.bottom > 0 ? 0 : 1,
        itemTextOn: viewPadding.bottom > 0 ? 0 : 1,
        circleOutline: 15.0,
        shadowAllowance: 3.0,
        circleSize: 30.0,
        blurShadowRadius: 50.0,
        circleColor: Colors.deepOrangeAccent,
        activeIconColor: Colors.white,
        inactiveIconColor: Colors.grey,
        tabs: getTabsData(),
        onTabChangedListener: (index) => setState(() => currentPage = index),
      ),
    );
  }
}
