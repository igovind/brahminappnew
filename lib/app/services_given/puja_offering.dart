import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/services_given/new_add_edit_puja.dart';
import 'package:brahminapp/app/account/account_page.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';

import '../languages.dart';

class PujaOffering extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot>? snapshot;
  final language;
  final uid;

  const PujaOffering({Key? key, this.snapshot, this.uid, this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
             backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
              // height(800);
                return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    height: height(700),
                    child: NewAddAndEditPuja(
                      language: language,
                      docSnap: null,
                      uid: uid,
                    ));
              },
            );
          },
          child: Icon(
            Icons.add_sharp,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        ),
        body: snapshot!.data!.docs.isEmpty
            ? Center(
                child: Text(
                  Language(code:language, text: [
                    "You have not added any puja yet, whatever you puja please add ",
                    "आपने अभी तक कोई पूजा ऐड नहीं किआ, आप जो भी पूजा करवाते है कृपया ऐड कीजिये  ",
                    "আপনি এখনও কোনও উপাসনা যোগ করেন নি, আপনি যা পূজা করেন দয়া করে যোগ করুন ",
                    "நீங்கள் இதுவரை எந்த வழிபாட்டையும் சேர்க்கவில்லை, நீங்கள் வணங்குவதை தயவுசெய்து சேர்க்கவும் ",
                    "మీరు ఇంకా ఏ ఆరాధనను జోడించలేదు, మీరు ఆరాధించేది దయచేసి జోడించండి "
                  ]).getText,
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot!.data!.size + 1,
                itemBuilder: (context, index) {
                  if (index == snapshot!.data!.size) {
                    return Container(
                      height: 100,
                    );
                  }
                  DocumentSnapshot documentSnapshot = snapshot!.data!.docs[index];
                  String? name = documentSnapshot.get("puja");
                  String? samagri = documentSnapshot.get("Pujan Samagri");
                  double? price = documentSnapshot.get("price");
                  int? swastik = documentSnapshot.get("swastik");
                  int? subscriber = documentSnapshot.get("subscriber");
                  String? time = documentSnapshot.get("time");
                  String id = documentSnapshot.id;
                  return Dismissible(
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:  Text(Language(code:language, text: [
                              "Confirm ",
                              "पुष्टि करें ",
                              "কনফার্ম ",
                              "உறுதிப்படுத்தவும் ",
                              "నిర్ధారించండి "
                            ]).getText,),
                            content: Text(
                              Language(code:language, text: [
                                "Are you sure you wish to delete this service?",
                                "क्या आप वाकई इस सेवा को हटाना चाहते हैं ",
                                "আপনি কি নিশ্চিত যে আপনি এই পরিষেবাটি মুছতে চান? ",
                                "இந்த சேவையை நீக்க விரும்புகிறீர்களா? ",
                                "మీరు ఖచ్చితంగా ఈ సేవను తొలగించాలనుకుంటున్నారా? "
                              ]).getText,),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(Language(code:language, text: [
                                    "Delete ",
                                    "हटाएं ",
                                    "মুছে ফেলা ",
                                    "அழி ",
                                    "తొలగించు "
                                  ]).getText,)),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(Language(code:language, text: [
                                  "Cancel ",
                                  "रद्द करें ",
                                  "বাতিল ",
                                  "ரத்துசெய் ",
                                  "రద్దు చేయండి "
                                ]).getText,),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Color(0XFFffbd59),
                      child: Center(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                  Language(code:language, text: [
                                "DELETE ",
                                "हटाएँ ",
                                "মুছে ফেলা ",
                                "அழி ",
                                "తొలగించు "
                              ]).getText,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 25,
                                  )
                                ],
                              ))),
                    ),
                    onDismissed: (direction) {
                      direction.index.toString();
                      FireStoreDatabase(uid: uid).deletepuja(
                          id, snapshot!.data!.docs[index].get('keyword'));
                      BotToast.showText(text: Language(code:language, text: [
                        "Deleted successfully ",
                        "सफलतापूर्वक मिटाया गया ",
                        "সফলভাবে মোছা হয়েছে ",
                        "வெற்றிகரமாக நீக்கப்பட்டது ",
                        "విజయవంతంగా తొలగించబడింది "
                      ]).getText,);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Container(
                                  height: height(600),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30))),
                                  child: NewAddAndEditPuja(
                                    docSnap: snapshot!.data!.docs[index],
                                    uid: uid,
                                  ));
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 2)
                              ]),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height(5),
                              ),
                              Text(
                                "$name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.deepOrangeAccent),
                              ),
                              SizedBox(
                                height: height(20),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Rs/-",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        "$price",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.watch_later,
                                        color: Colors.black54,
                                        size: 16,
                                      ),
                                      Text("$time",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.black54, size: 18),
                                      Text("$swastik",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.people,
                                          color: Colors.black54, size: 18),
                                      Text("$subscriber",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: AccountTile(
                                    onPress: () {
                                      Share.share("$samagri");
                                    },
                                    title: Language(code:language, text: [
                                      "Share samagri",
                                      "शेयर सामग्री  ",
                                      "সমাগরী শেয়ার করুন ",
                                      "பகிர் சமகிரி ",
                                      "భాగస్వామ్యం "
                                    ]).getText,
                                    icon: Icons.share,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
