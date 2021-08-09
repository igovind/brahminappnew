import 'package:brahminapp/app/account/edit_adhaar_details.dart';
import 'package:brahminapp/app/account/gallery_page.dart';
import 'package:brahminapp/app/create_profile/registration_form.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/app/services_given/services_page.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/common_widgets/platform_alert_dialog.dart';
import 'package:brahminapp/main.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatelessWidget {
  final uid;
  final language;
  final UserId userId;

  const CreateProfile({Key? key, required this.uid, required this.language, required this.userId})
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
        title: Language(code: language, text: [
          "Logout",
          "लॉग आउट",
          "প্রস্থান",
          "வெளியேறு",
          "లాగ్ అవుట్"
        ]).getText,
        content: Language(code: language, text: [
          "Are you sure that you want to logout?",
          "क्या आप वाकई लॉगआउट करना चाहते हैं?",
          "আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?",
          "நீங்கள் வெளியேற விரும்புகிறீர்களா?",
          "మీరు లాగ్ అవుట్ చేయాలనుకుంటున్నారా?"
        ]).getText,
        cancelActionText: Language(code: language, text: [
          "Cancel",
          "रद्द करें",
          "বাতিল",
          "ரத்துசெய்",
          "రద్దు చేయండి"
        ]).getText,
        defaultActionText: Language(code: language, text: [
          "Logout",
          "लॉग आउट",
          "প্রস্থান",
          "வெளியேறு",
          "లాగ్ అవుట్"
        ]).getText,
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
              leading: SizedBox(),
              toolbarHeight: 40,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                Language(code: language, text: [
                  "Registration",
                  "पंजीकरण",
                  "নিবন্ধন",
                  "பதிவு",
                  "నమోదు"
                ]).getText,
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                    onPressed: () => _confirmSignOut(context),
                    child: Text(
                      Language(code: language, text: [
                        "Logout",
                        "लॉग आउट",
                        "প্রস্থান",
                        "வெளியேறு",
                        "లాగ్ అవుట్"
                      ]).getText,
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: body(_currentIndex, uid, language, snapshot,userId),
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

Widget body(int? value, uid, language, snapshot,user) {
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
    case 1:
      return GalleryPage(
        language: language,
        uid: uid,
        done: "dj",
      );
    case 2:
      return EditAdhaarDetails(
        language: language,
        uid: uid,
        check: "gfh",
      );

    case 3:
      return ServicesPage(
        check: "hvy",
        userData: snapshot,
        userId: user,
        language: language,
      );
  }
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${Language(code: language, text: [
                  "Congratulations!!\n You have Successfully Created your profile",
                  "बधाई हो!!\n आपने सफलतापूर्वक अपना प्रोफ़ाइल बना लिया है",
                  "অভিনন্দন !!\n আপনি সফলভাবে আপনার প্রোফাইল তৈরি করেছেন",
                  "வாழ்த்துக்கள் !!\n உங்கள் சுயவிவரத்தை வெற்றிகரமாக உருவாக்கியுள்ளீர்கள்",
                  "అభినందనలు !!\n మీరు మీ ప్రొఫైల్‌ను విజయవంతంగా సృష్టించారు "
                ]).getText}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 50,
          ),
          CustomContainer(
            radius: 10,
            child: TextButton(
                onPressed: () =>
                    Navigator.of(navigationKey.currentState!.context).pop(),
                child: Text(
                  Language(code: language, text: [
                    "Open App",
                    "ऐप खोलें",
                    "এপ খোল",
                    "பயன்பாட்டைத் திறக்கவும்",
                    "అనువర్తనాన్ని తెరవండి "
                  ]).getText,
                  style: TextStyle(color: Colors.deepOrange),
                )),
          )
        ],
      ),
    ),
  );
}
