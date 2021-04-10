import 'package:brahminapp/app/create_profile/edit_bank_details.dart';
import 'package:brahminapp/app/account/edit_adhaar_details.dart';
import 'package:brahminapp/app/account/gallery_page.dart';
import 'package:brahminapp/app/astrology/astrology_page.dart';
import 'package:brahminapp/app/create_profile/registration_form.dart';
import 'package:brahminapp/common_widgets/platform_alert_dialog.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatelessWidget {
  final uid;

  const CreateProfile({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _currentIndex;

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

    return StreamBuilder<DocumentSnapshot>(
        stream: FireStoreDatabase(uid: uid).getUserData,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data.data() == null) {
            _currentIndex = 0;
          }
          if (snapshot.data.data() != null) {
            _currentIndex = snapshot.data.data()["index"] ?? 0;
          }
          return Scaffold(
            appBar: AppBar(
              //actions: [FlatButton(onPressed: () {}, child: Text("check"))],
              toolbarHeight: 30,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                "Registration",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                FlatButton(
                    onPressed: () => _confirmSignOut(context),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: body(_currentIndex, uid),
            bottomNavigationBar: DotsIndicator(
                onTap: (value) {},
                position: _currentIndex.toDouble(),
                dotsCount: 6,
                decorator: DotsDecorator(
                  size: Size.fromRadius(5),
                  color: Colors.black54,
                  activeColor: Colors.deepOrangeAccent,
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                )),
          );
        });
  }
}

Widget body(int value, uid) {
  switch (value) {
    case 0:
      return StreamBuilder<DocumentSnapshot>(
          stream: FireStoreDatabase(uid: uid).getAvailableCode,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return RegistrationForm(
              snapshot: snapshot,
              uid: uid,
            );
          });
      break;
    case 1:
      return AstrologyPage(uid: uid);
      break;
    case 2:
      return GalleryPage(
        uid: uid,
        done: "dj",
      );
      break;
    case 3:
      return EditAdhaarDetails(
        uid: uid,
        check: "gfh",
      );
      break;
    case 4:
      return EditBankDetails(
        check: "h",
        uid: uid,
      );
      break;
  }
  return Text("Error");
}
