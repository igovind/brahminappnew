import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChooseLanguage extends StatefulWidget {
  final uid;
  final language;

  const ChooseLanguage({Key key, this.uid, this.language}) : super(key: key);

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  
  @override
  Widget build(BuildContext context) {
    Widget languageTile(String selLanguage) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FireStoreDatabase(uid: widget.uid).updateData(data: {
                  "langCode": Language(language: selLanguage).getCode,
                  "lang": selLanguage
                }).whenComplete(() {
                  BotToast.showText(text: Language(code: Language(language: selLanguage).getCode, text: [
                    "Language updated ",
                    "भाषा अपडेट की गई ",
                    "ভাষা আপডেট হয়েছে ",
                    "மொழி புதுப்பிக்கப்பட்டது ",
                    "భాష నవీకరించబడింది "
                  ]).getText);
                  setState(() {

                  });
                }).whenComplete(() =>Navigator.of(context).pop());
              },
              child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Center(child: Text("$selLanguage")),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.deepOrangeAccent,
                      style: BorderStyle.solid,
                      width: 1),
                ),
              ),
            ),
          )
        ],
      );
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
                Language(code:widget.language, text: [
                  "Choose Your Language ",
                  "अपनी भाषा चुनिए ",
                  "আপনার ভাষা নির্বাচন করুন ",
                  "உங்கள் மொழியைத் தேர்வுசெய்க ",
                  "మీ భాషను ఎంచుకోండి "
                ]).getText,
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 10,
          ),
          languageTile("English"),
          SizedBox(
            height: 10,
          ),
          languageTile("हिन्दी"),
          SizedBox(
            height: 10,
          ),
          languageTile("বাঙ্গালী"),
          SizedBox(
            height: 10,
          ),
          languageTile("தமிழ்"),
          SizedBox(
            height: 10,
          ),
          languageTile("తెలుగు"),
        ],
      ),
    );
  }
}
