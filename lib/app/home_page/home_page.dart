import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/Chat/View/ChatListPageView.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/bank_details.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/contact_us.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/gallery.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/history.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/my_booking_request_page.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/my_upcoming_puja_page.dart';
import 'package:brahminapp/app/home_page/tab_bar/dashboard/model_class.dart';
import 'package:brahminapp/app/home_page/tab_bar/home_page_sec.dart';
import 'package:brahminapp/app/home_page/tab_bar/payment.dart';
import 'package:brahminapp/common_widgets/platform_alert_dialog.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'drawer_tiles/my_account/user_profile_page.dart';
import 'drawer_tiles/puja_offering/puja_page.dart';

Future<void> _signOut(context) async {
  try {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.signOut();
  } catch (e) {
    print(e.toString());
  }
}

Future<void> _confirmSignOut(context) async {
  final didRequestSignOut = await PlatformAlertDialog(
    title: 'Logout',
    content: 'Are you sure that you want to logout?',
    cancelActionText: 'Cancel',
    defaultActionText: 'Logout',
  ).show(context);
  if (didRequestSignOut == true) {
    _signOut(context);
  }
}

class HomePage extends StatefulWidget {
  final UserId user;

  const HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        final notificationa = message['data'];
        BotToast.showSimpleNotification(
          onTap: () {
           // final database = Provider.of<DatabaseL>(context, listen: false);
            switch (notificationa['type']) {
              case 'Booking':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBookingRequestPage()));
                break;
            }
          },
          animationDuration: Duration(seconds: 2),
          hideCloseButton: true,
          title: notification['title'],
          subTitle: notification['body'],
          duration: Duration(seconds: 5),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notificationa = message['data'];
        handleRouting(notificationa);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyBookingRequestPage()));
        break;
    }
  }

  Widget _listTile({String title, Icon icon, VoidCallback onPressed}) {
    return ListTile(
      contentPadding: EdgeInsets.all(4),
      leading: IconButton(
        iconSize: 30,
        color: Colors.deepOrange,
        icon: icon,
        onPressed: () {},
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 18,
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _appDrawer(BuildContext context) {
    final user = Provider.of<UserId>(context, listen: false);
    print('kkkkrrrr   /////////////////////////${user.uid} ${user.photoUrl}');
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:
               Text(user.displayName == null ? ' ' : user.displayName),
            accountEmail: Text(user.userEmail == null ? ' ' : user.userEmail),
            currentAccountPicture: user.photoUrl != null
                ? Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(user.photoUrl),
                            fit: BoxFit.fill)),
                  )
                : Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('images/placeholder.jpg'),
                            fit: BoxFit.fill)),
                  ),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
          ),
          _listTile(
              title: 'My account',
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Provider<DatabaseL>(
                          create: (context) => FireStoreDatabase(uid: user.uid),
                          child: UserProfilePage(
                            uid: user.uid,
                          ),
                        )));
              }),
          Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'My gallery',
              icon: Icon(Icons.photo_camera_back),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Gallery(
                          uid: user.uid,
                        )));
              }),
          Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'Bank details',
              icon: Icon(Icons.home_repair_service_rounded),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BankDetailsPage(
                          uid: widget.user.uid,
                        )));
              }),
          Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'Puja offering',
              icon: Icon(Icons.local_offer),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PujaPage(
                    uid: user.uid,
                  ),
                ));
              }),
         /* Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'Astrology',
              icon: Icon(Icons.all_inclusive_sharp),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AstrologySection(uid: user.uid,)
                ));
              }),*/
          Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'Booking Request',
              icon: Icon(Icons.group),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyBookingRequestPage(),
                ));
              }),
          Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'Upcoming puja',
              icon: Icon(Icons.list),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Schedule(
                    uid: user.uid,
                  ),
                ));
              }),
          Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'History',
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HistoryPage(
                          uid: user.uid,
                        )));
              }),
          Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'Support team',
              icon: Icon(Icons.support_agent),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ContactUsPage(
                          uid: user.uid,
                        )));
              }),
          Divider(
            thickness: 0.5,
          ),
          _listTile(
              title: 'Logout',
              icon: Icon(Icons.exit_to_app),
              onPressed: () => _confirmSignOut(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId>(context, listen: false);
    // to hide only bottom bar:
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);

// to hide only status bar:
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

// to hide both:
    // SystemChrome.setEnabledSystemUIOverlays ([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Purohit dashboard',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Montserrat',
      ),
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            toolbarHeight: 150,
            iconTheme: new IconThemeData(color: Colors.deepOrange),
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: const Text(
              'Puja Purohit',
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w700),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.deepOrange[100],
              indicatorColor: Colors.deepOrange,
              labelColor: Colors.deepOrange,
              isScrollable: true,
              tabs: choices.map<Widget>((Choice choice) {
                return Tab(
                  iconMargin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  text: choice.title,
                  icon: Icon(choice.icon),
                );
              }).toList(),
            ),
          ),
          drawer: _appDrawer(context),
          body: StreamBuilder<DocumentSnapshot>(
              stream: FireStoreDatabase(uid: user.uid).getUserData,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                int number = snapshot.data.data()['setReward'];
                double net = snapshot.data.data()['setPrice'].toDouble();

                print('????????????????????????$number');
                return TabBarView(
                  children: choices.map((Choice choice) {
                    if (choice.title == 'Chats') {
                      return Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: Provider<DatabaseL>(
                                create: (context) =>
                                    FireStoreDatabase(uid: user.uid),
                                child: Chat(
                                  databaseL: null,
                                  user: user,
                                )),
                          ));
                    }
                    if (choice.title == 'Dashboard') {
                      return Padding(
                          padding: EdgeInsets.all(2),
                          child: Card(
                            child: Provider<DatabaseL>(
                                create: (context) =>
                                    FireStoreDatabase(uid: user.uid),
                                child: ModelClass(
                                  uid: user.uid,
                                )),
                          ));
                    }
                    if (choice.title == 'Payments') {
                      return Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: Payment(
                              uid: user.uid,
                            ),
                          ));
                    }
                    if (choice.title == 'Home') {
                      return Padding(
                          padding: EdgeInsets.all(1),
                          child: Card(
                            color: Colors.deepOrange[20],
                            elevation: 0.5,
                            child: HomePageSec(
                              num: number,
                              net: net,
                              uid: user.uid,
                            ),
                          ));
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ChoicePage(
                        choice: choice,
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }
}

class Choice {
  final String title;
  final IconData icon;

  const Choice({this.title, this.icon});
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Home', icon: Icons.home),
  Choice(title: 'Chats', icon: Icons.chat),
  Choice(title: 'Dashboard', icon: Icons.dashboard),
  Choice(title: 'Payments', icon: Icons.payment),
];

class ChoicePage extends StatelessWidget {
  const ChoicePage({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      elevation: 0.5,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              choice.icon,
              size: 150.0,
              color: textStyle.color,
            ),
            Text(
              choice.title,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
