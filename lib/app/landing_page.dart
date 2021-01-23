import 'package:brahminapp/app/toggle_page.dart';
import 'package:brahminapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/app/sign_in/sign_in_page.dart';
import 'package:brahminapp/services/auth.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  initializing() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<UserId>(
        stream: FirebaseAuth.instance.authStateChanges().map((event) {
          return UserId(
              userEmail: event.email,
              uid: event.uid,
              photoUrl: event.photoURL,
              displayName: event.displayName);
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserId user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
   /*         if (user.displayName == null) {
              return Provider<DatabaseL>(
                create: (_) => FireStoreDatabase(uid: user.uid),
                child: EditProfilePage(
                  uid: user.uid,
                  added: false,
                ),
              );
            }
            if (user.displayName == '') {
              return Provider<DatabaseL>(
                create: (_) => FireStoreDatabase(uid: user.uid),
                child: EditProfilePage(
                  uid: user.uid,
                  added: false,
                ),
              );
            }*/
            return Provider<UserId>.value(
              value: user,
              child: Provider<DatabaseL>(
                create: (BuildContext context) =>
                    FireStoreDatabase(uid: user.uid),
                child: TogglePage(
                  user: user,
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
