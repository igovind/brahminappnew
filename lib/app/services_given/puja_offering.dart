import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/account/account_page.dart';
import 'package:brahminapp/app/services_given/puja_offering/add_new_puja.dart';
import 'package:brahminapp/app/services_given/puja_offering/share_samagri.dart';
import 'package:brahminapp/app/services_given/puja_offering/x_puja_edit_page.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../languages.dart';

class PujaOffering extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot>? snapshot;
  final AsyncSnapshot<DocumentSnapshot> userData;
  final language;
  final uid;

  const PujaOffering(
      {Key? key,
      this.snapshot,
      this.uid,
      this.language,
      required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: FireStoreDatabase(uid: "").getListOfPuja,
        builder: (context, snapshotS) {
          if (snapshotS.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<dynamic> pujaList = snapshotS.data!.get("listed_puja");
          List<dynamic> samagriList = snapshotS.data!.get("listed_samagri");
          samagriList.forEach((element) {});
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AddNewPuja(
                            pujaList: pujaList,
                            samagriList: samagriList,
                            userData: userData,
                          )));
                },
                child: Icon(
                  Icons.add_sharp,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepOrangeAccent,
              ),
              body: snapshot!.data!.docs.isEmpty
                  ? Center(
                      child: Text(
                        Language(code: language, text: [
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
                      itemCount: snapshot!.data!.size,
                      itemBuilder: (context, index) {
                        if (index == snapshot!.data!.size) {
                          return Container(
                            height: 100,
                          );
                        }
                        String? name = "";
                        List<dynamic> samagri1;
                        dynamic price;
                        int? swastik;
                        int? subscriber;
                        String? time;
                        String? image;
                        String description;
                        String adDes;
                        String pjid;

                        String type;
                        List<dynamic> samList;
                        String id;
                        DocumentSnapshot documentSnapshot =
                            snapshot!.data!.docs[index];
                        String keyword = documentSnapshot.get("keyword");
                        if (keyword == "#other") {
                          name = documentSnapshot.get("puja");
                          samagri1 = [];
                          price = documentSnapshot.get("price");
                          swastik = documentSnapshot.get("swastik");
                          subscriber = documentSnapshot.get("subscriber");
                          time = documentSnapshot.get("time");
                          image =
                              "https://firebasestorage.googleapis.com/v0/b/swastik13-8242d.appspot.com/o/inventories%2Fimportent%20images%2FScreen%20Shot%202021-08-18%20at%2009.21.11.png?alt=media&token=a3f13378-5504-4999-8bc4-daa8949d2a16";
                          description = documentSnapshot.get("PanditD");
                          adDes = documentSnapshot.get("Benefit");

                          type = "other";
                          samList = [];
                          id = documentSnapshot.id;
                          pjid = "PJID0000";
                        } else {
                          name = documentSnapshot.get("puja");
                          samagri1 =
                              documentSnapshot.get("samagri1") ?? [];
                          price = documentSnapshot.get("price");
                          swastik = documentSnapshot.get("swastik");
                          subscriber = documentSnapshot.get("subscriber");
                          time = documentSnapshot.get("time");
                          image = documentSnapshot.get("image");
                          description = documentSnapshot.get("PanditD");
                          adDes = documentSnapshot.get("Benefit");
                          pjid = documentSnapshot.get("pjid");

                          type = documentSnapshot.get("type");
                          samList = documentSnapshot.get("samagri2") == null
                              ? []
                              : documentSnapshot.get("samagri2");
                          id = documentSnapshot.id;
                        }

                        return Dismissible(
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    Language(code: language, text: [
                                      "Confirm ",
                                      "पुष्टि करें ",
                                      "কনফার্ম ",
                                      "உறுதிப்படுத்தவும் ",
                                      "నిర్ధారించండి "
                                    ]).getText,
                                  ),
                                  content: Text(
                                    Language(code: language, text: [
                                      "Are you sure you wish to delete this service?",
                                      "क्या आप वाकई इस सेवा को हटाना चाहते हैं ",
                                      "আপনি কি নিশ্চিত যে আপনি এই পরিষেবাটি মুছতে চান? ",
                                      "இந்த சேவையை நீக்க விரும்புகிறீர்களா? ",
                                      "మీరు ఖచ్చితంగా ఈ సేవను తొలగించాలనుకుంటున్నారా? "
                                    ]).getText,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          Language(code: language, text: [
                                            "Delete ",
                                            "हटाएं ",
                                            "মুছে ফেলা ",
                                            "அழி ",
                                            "తొలగించు "
                                          ]).getText,
                                        )),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        Language(code: language, text: [
                                          "Cancel ",
                                          "रद्द करें ",
                                          "বাতিল ",
                                          "ரத்துசெய் ",
                                          "రద్దు చేయండి "
                                        ]).getText,
                                      ),
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
                                          Language(code: language, text: [
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
                            BotToast.showText(
                              text: Language(code: language, text: [
                                "Deleted successfully ",
                                "सफलतापूर्वक मिटाया गया ",
                                "সফলভাবে মোছা হয়েছে ",
                                "வெற்றிகரமாக நீக்கப்பட்டது ",
                                "విజయవంతంగా తొలగించబడింది "
                              ]).getText,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => PujaEditTile(
                                          adDes: adDes,
                                          languageCode: language,
                                          uid: uid,
                                          edit: true,
                                          keyword: keyword,
                                          type: type,
                                          mainSamagriList: samagriList,
                                          samagri: samList,
                                          name: name,
                                          description: description,
                                          image: image,
                                          duration: time,
                                          pjid: pjid,
                                          price: price,
                                          serviceIdL: id,
                                        )));
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 2)
                                    ]),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: height(5),
                                    ),
                                    Image.network(
                                      image!,
                                      height: MagicScreen(
                                              height: 150, context: context)
                                          .getHeight,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        Text(
                                          "$name",
                                          overflow: TextOverflow.fade,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.deepOrangeAccent),
                                        ),
                                        id[id.length - 1] != "%"
                                            ? SizedBox()
                                            : Icon(
                                                Icons.circle,
                                                size: 20,
                                                color: Colors.green,
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                      height: height(20),
                                    ),
                                    DottedBorder(
                                      color: Colors.black54,
                                      child: Row(
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(Icons.star,
                                                  color: Colors.black54,
                                                  size: 18),
                                              Text("$swastik",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(Icons.people,
                                                  color: Colors.black54,
                                                  size: 18),
                                              Text("$subscriber",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {},
                                        child: AccountTile(
                                          onPress: () {
                                           Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SharePujaCard(
                                             name: name,
                                             description: description,
                                             img: image,
                                             samagri: samagri1,
                                             userSnap: userData,
                                           )));
                                          },
                                          title:
                                              Language(code: language, text: [
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
        });
  }
}
