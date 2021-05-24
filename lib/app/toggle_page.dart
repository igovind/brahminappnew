import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/create_profile/create_profile.dart';
import 'package:brahminapp/app/home/bottom_navigation_bar_page.dart';
import 'package:brahminapp/app/home/one_more_bottom_navy.dart';
import 'package:brahminapp/app/select_language_page.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TogglePage extends StatefulWidget {
  final UserId? user;

  const TogglePage({Key? key, this.user}) : super(key: key);

  @override
  _TogglePageState createState() => _TogglePageState();
}

class _TogglePageState extends State<TogglePage> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FireStoreDatabase(uid: widget.user!.uid).getUserData,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.data!.data() == null) {
            /* return CreateProfile(
              uid: widget.user.uid,
            );*/
            return SelectLanguage(
              userId: widget.user,
            );
          }
          String lang = snapshot.data!.get("langCode") ?? "ENG";
          bool ready = snapshot.data!.get("ready") ?? true;
          if (!ready) {
            return CreateProfile(
              uid: widget.user!.uid,
              language: lang,
            );

          }
          if (UserDetails(snapshot: snapshot).astrologer!) {
            return ExtBotNavBar(
              userDataSnapshot: snapshot,
              user: widget.user,
              language: lang,
            );
          }
          return Provider<UserId?>.value(
            value: widget.user,
            child: Provider<DatabaseL>(
                create: (BuildContext context) =>
                    FireStoreDatabase(uid: widget.user!.uid),
                child: BotNavBar(
                  language: lang,
                  userDataSnapshot: snapshot,
                  user: widget.user,
                )
                /*  child: NewAddEditPuja(),*/
                ),
          );
        });
  }
}
//chu
