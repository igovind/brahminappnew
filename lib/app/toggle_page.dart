import 'package:brahminapp/app/home_page/drawer_tiles/my_account/create_profile_page.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/my_account/new_edit_profile_page.dart';
import 'package:brahminapp/app/home_page/home_page.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TogglePage extends StatelessWidget {
  final UserId user;

  const TogglePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FireStoreDatabase(uid: user.uid).getUserData,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data.data() == null) {
            return EditProfilePage(
              uid: user.uid,
              added: false,
            );
          }
          return Provider<UserId>.value(
            value: user,
            child: Provider<DatabaseL>(
              create: (BuildContext context) =>
                  FireStoreDatabase(uid: user.uid),
              child: //NewEditProfilePgae(uid: user.uid),
             HomePage(
                user: user,
              ),
            ),
          );
        });
  }
}
