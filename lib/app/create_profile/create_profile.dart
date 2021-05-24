import 'package:brahminapp/app/create_profile/edit_bank_details.dart';
import 'package:brahminapp/app/account/edit_adhaar_details.dart';
import 'package:brahminapp/app/account/gallery_page.dart';
import 'package:brahminapp/app/astrology/astrology_page.dart';
import 'package:brahminapp/app/create_profile/registration_form.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/common_widgets/platform_alert_dialog.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatelessWidget {
  final uid;
  final language;

  const CreateProfile({Key? key, required this.uid, required this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? _currentIndex;

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
        title: Language(code: language,text: ["Logout","लॉग आउट","প্রস্থান","வெளியேறு","లాగ్ అవుట్"]).getText,
        content: Language(code: language,text: ["Are you sure that you want to logout?","क्या आप वाकई लॉगआउट करना चाहते हैं?","আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?","நீங்கள் வெளியேற விரும்புகிறீர்களா?","మీరు లాగ్ అవుట్ చేయాలనుకుంటున్నారా?"]).getText,
        cancelActionText: Language(code: language,text: ["Cancel","रद्द करें","বাতিল","ரத்துசெய்","రద్దు చేయండి"]).getText,
        defaultActionText: Language(code: language,text: ["Logout","लॉग आउट","প্রস্থান","வெளியேறு","లాగ్ అవుట్"]).getText,
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
          if (snapshot.data!.data() == null) {
            _currentIndex = 0;
          }
          if (snapshot.data!.data() != null) {
            _currentIndex = snapshot.data!.get("index") ?? 0;
          }
          return Scaffold(
            appBar: AppBar(
             // iconTheme: IconThemeData(color: Colors.black54),
              //actions: [FlatButton(onPressed: () {}, child: Text("check"))],
              leading: SizedBox(),
              toolbarHeight: 30,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                Language(code: language,text: ["Registration","पंजीकरण","নিবন্ধন","பதிவு","నమోదు"]).getText,
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () => _confirmSignOut(context),
                    child: Text(
                      Language(code: language,text: ["Logout","लॉग आउट","প্রস্থান","வெளியேறு","లాగ్ అవుట్"]).getText,
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: body(_currentIndex, uid,language),
            bottomNavigationBar: DotsIndicator(
                onTap: (value) {},
                position: _currentIndex!.toDouble(),
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

Widget body(int? value, uid,language) {
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
              language: language,
              snapshot: snapshot,
              uid: uid,
            );
          });
      break;
    case 1:
      return AstrologyPage(uid: uid,language: language,);
      break;
    case 2:
      return GalleryPage(
        language: language,
        uid: uid,
        done: "dj",
      );
      break;
    case 3:
      return EditAdhaarDetails(
        language: language,
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
