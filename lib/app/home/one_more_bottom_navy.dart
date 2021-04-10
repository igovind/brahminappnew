import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/account/account_page.dart';
import 'package:brahminapp/app/astrology/calls/index.dart';
import 'package:brahminapp/app/astrology/edit_astrology_price.dart';
import 'package:brahminapp/app/bookings/bookings_page.dart';
import 'package:brahminapp/app/home/home_page2.dart';
import 'package:brahminapp/app/services_given/services_page.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondBottomNavy extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot> userDataSnapshot;
  final UserId user;

  const SecondBottomNavy({Key key, this.user, this.userDataSnapshot})
      : super(key: key);

  @override
  _SecondBottomNavyState createState() => _SecondBottomNavyState();
}

class _SecondBottomNavyState extends State<SecondBottomNavy> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initState() {
    super.initState();
    _navigationController = new CircularBottomNavigationController(selectedPos);
    _navigationController = new CircularBottomNavigationController(selectedPos);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //  print("onMessage: $message");
        final notification = message['notification'];
        final notificationa = message['data'];
        switch (notificationa['type']) {
          case 'Booking':
            BotToast.showSimpleNotification(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookingsPage()));
              },
              animationDuration: Duration(seconds: 2),
              hideCloseButton: true,
              title: notification['title'],
              subTitle: notification['body'],
              duration: Duration(seconds: 5),
            );
            break;
          case 'Message':
            BotToast.showSimpleNotification(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookingsPage()));
              },
              animationDuration: Duration(seconds: 2),
              hideCloseButton: false,
              title: notification['title'],
              subTitle: notification['body'],
              duration: Duration(seconds: 5),
            );
            break;
          case 'VCall':
            BotToast.showSimpleNotification(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndexPage(
                                userId: widget.user,
                                callType: notificationa['call_type'],
                                channelName: notificationa['channel'],
                              )));
                },
                animationDuration: Duration(seconds: 2),
                hideCloseButton: true,
                title: notification['title'],
                subTitle: notification['body'],
                duration: Duration(seconds: 10),
                enableSlideOff: false);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        // print("onLaunch: $message");
        final notificationa = message['data'];
        handleRouting(notificationa);
      },
      onResume: (Map<String, dynamic> message) async {
        final notificationa = message['data'];
        handleRouting(notificationa);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  void handleRouting(dynamic notification) {
    //final database = Provider.of<DatabaseL>(context, listen: false);
    switch (notification['type']) {
      case 'Booking':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookingsPage(
                      userId: widget.user,
                    )));
        break;
      case 'VCall':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IndexPage(
                      userId: widget.user,
                      callType: notification['call_type'],
                      channelName: notification['channel'],
                    )));
        break;
    }
  }

  int selectedPos = 0;

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.deepOrangeAccent,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    /* new TabItem(Icons.dynamic_feed_outlined, "Feed", Colors.deepOrangeAccent,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),*/
    new TabItem(Icons.person_add_alt_1, "Bookings", Colors.orange,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    new TabItem(Icons.layers, "Services", Colors.deepOrangeAccent,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    new TabItem(Icons.star, "Astrology", Colors.deepOrangeAccent,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    new TabItem(Icons.account_circle, "Account", Colors.deepOrangeAccent,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
  ]);
  CircularBottomNavigationController _navigationController;

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    return Scaffold(
      body: Container(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FireStoreDatabase(uid: widget.user.uid).getTabImages,
            builder: (context, tabImageSnapshot) {
              if (tabImageSnapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      child: bodyContainer(
                          userDataSnapshot: widget.userDataSnapshot,
                          tabImageSnapshot: tabImageSnapshot),
                      padding: EdgeInsets.only(bottom: height(55)),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: CircularBottomNavigation(
                          tabItems,
                          circleSize: 40,
                          iconsSize: 20,
                          controller: _navigationController,
                          barHeight: MediaQuery.of(context).size.height * 0.075,
                          //bottomNavBarHeight,
                          barBackgroundColor: Colors.white,
                          animationDuration: Duration(milliseconds: 200),
                          selectedCallback: (int selectedPos) {
                            setState(() {
                              this.selectedPos = selectedPos;
                              print(_navigationController.value);
                            });
                          },
                        ))
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget bodyContainer(
      {AsyncSnapshot<DocumentSnapshot> tabImageSnapshot,
      AsyncSnapshot<DocumentSnapshot> userDataSnapshot}) {
    switch (selectedPos) {
      case 0:
        //slogan = "Familly, Happiness, Food";
        return HomePageFolder(
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
          userId: widget.user,
        );
        break;
      case 2:
        return ServicesPage(
          userId: widget.user,
        );
        break;
      case 3:
        return EditAstrologyPrices(
          snapshot: userDataSnapshot,
          userId: widget.user,
        );
        break;
      case 4:
        return StreamBuilder<DocumentSnapshot>(
            stream: FireStoreDatabase(uid: widget.user.uid).getAdhaarDetails,
            builder: (context, adhaarsnapshot) {
              if (adhaarsnapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StreamBuilder<DocumentSnapshot>(
                  stream:
                      FireStoreDatabase(uid: widget.user.uid).getBankDetails,
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

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      circleSize: 40,
      iconsSize: 20,
      controller: _navigationController,
      barHeight: MediaQuery.of(context).size.height * 0.075,
      //bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 200),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos;
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
