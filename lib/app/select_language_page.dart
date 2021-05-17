import 'package:brahminapp/app/create_profile/create_profile.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectLanguage extends StatelessWidget {
  final UserId userId;

  const SelectLanguage({Key key, @required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget languageTile(String language) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Provider<AuthBase>(
                      create: (context)=>Auth(),
                      child: CreateProfile(
                            uid: userId.uid,
                            language: Language(language: language).getCode,
                          ),
                    )));
              },
              child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Center(child: Text("$language")),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.deepOrangeAccent,
                        style: BorderStyle.solid,
                        width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 2)
                    ]),
              ),
            ),
          )
        ],
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Choose Your Language",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 50,
            ),
            languageTile("English"),
            SizedBox(
              height: 20,
            ),
            languageTile("हिन्दी"),
            SizedBox(
              height: 20,
            ),
            languageTile("বাঙ্গালী"),
            SizedBox(
              height: 20,
            ),
            languageTile("தமிழ்"),
            SizedBox(
              height: 20,
            ),
            languageTile("తెలుగు"),
          ],
        ),
      ),
    );
  }
}
