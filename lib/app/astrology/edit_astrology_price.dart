import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/create_profile/edit_astrology_form.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common_widgets/custom_slider.dart';

class EditAstrologyPrices extends StatelessWidget {
  final UserId? userId;
  final AsyncSnapshot<DocumentSnapshot>? snapshot;
  final language;

  const EditAstrologyPrices({
    Key? key,
    this.userId,
    this.snapshot,
    this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }

    bool chatOk = snapshot!.data!.get("chatOk") ?? false;
    bool callOk = snapshot!.data!.get("callOk") ?? false;
    bool videoOk = snapshot!.data!.get("videoOk") ?? false;
    bool online = snapshot!.data!.get("online") ?? false;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*  SizedBox(
              height: height(30),
            ),*/
            SizedBox(
              height: MagicScreen(context: context, height: 20).getHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Language(code: language, text: [
                    "Astrology ",
                    "ज्योतिष ",
                    "জ্যোতিষ ",
                    "ஜோதிடம் ",
                    "జ్యోతిషశాస్త్రం "
                  ]).getText,
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w700),
                ),
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: EditAstrologyForm(
                                language: language,
                                uid: userId!.uid,
                                snapshot: snapshot,
                              ));
                        },
                      );
                    },
                    child: Text(
                      Language(code: language, text: [
                        "Edit ",
                        "संपादित करें ",
                        "সম্পাদনা করুন ",
                        "தொகு ",
                        "సవరించండి "
                      ]).getText,
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.w700),
                    ))
              ],
            ),
            SizedBox(
              height: height(10),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  color: Colors.deepOrangeAccent,
                  border: Border.all(
                      color: Colors.deepOrangeAccent,
                      style: BorderStyle.solid,
                      width: 0.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Language(code: language, text: [
                          "Available",
                          "उपलब्ध ",
                          "উপলব্ধ ",
                          "கிடைக்கிறது ",
                          "అందుబాటులో ఉంది "
                        ]).getText,
                        style: TextStyle(color: Colors.white),
                      ),
                      CustomSlider(
                        animationDuration: Duration(milliseconds: 100),
                        value: online,
                        width: width(100),
                        colorOff: Colors.red,
                        colorOn: Colors.green,
                        height: height(40),
                        onChanged: (value) {
                          FireStoreDatabase(uid: userId!.uid)
                              .setOnlineStatus(value: value!);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height(5),
                  ),
                  !online
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Language(code: language, text: [
                                "Receive Message ",
                                "संदेश प्राप्त करें ",
                                "বার্তা গ্রহণ করুন ",
                                "செய்திகளைப் பெறுக ",
                                "సందేశాలను స్వీకరించండి "
                              ]).getText,
                              style: TextStyle(color: Colors.white),
                            ),
                            CustomSlider(
                              animationDuration: Duration(milliseconds: 100),
                              value: chatOk,
                              width: width(100),
                              colorOff: Colors.red,
                              colorOn: Colors.green,
                              height: height(40),
                              onChanged: (value) {
                                FireStoreDatabase(uid: userId!.uid)
                                    .setMessageStatus(value: value);
                              },
                            ),
                          ],
                        ),
                  SizedBox(
                    height: height(5),
                  ),
                  !online
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                Language(code: language, text: [
                                  "Receive Audio Calls ",
                                  "ऑडियो कॉल प्राप्त करें ",
                                  "অডিও কল গ্রহণ করুন ",
                                  "ஆடியோ அழைப்புகளைப் பெறுக ",
                                  "ఆడియో కాల్‌లను స్వీకరించండి "
                                ]).getText,
                                style: TextStyle(color: Colors.white)),
                            CustomSlider(
                              animationDuration: Duration(milliseconds: 100),
                              value: callOk,
                              width: width(100),
                              height: height(40),
                              colorOff: Colors.red,
                              colorOn: Colors.green,
                              onChanged: (value) {
                                FireStoreDatabase(uid: userId!.uid)
                                    .setCallStatus(value: value);
                              },
                            ),
                          ],
                        ),
                  SizedBox(
                    height: height(5),
                  ),
                  !online
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                Language(code: language, text: [
                                  "Receive Video Calls ",
                                  "वीडियो कॉल प्राप्त करें ",
                                  "ভিডিও কল গ্রহণ করুন ",
                                  "வீடியோ அழைப்புகளைப் பெறுக ",
                                  "వీడియో కాల్‌లను స్వీకరించండి "
                                ]).getText,
                                style: TextStyle(color: Colors.white)),
                            CustomSlider(
                              animationDuration: Duration(milliseconds: 100),
                              value: videoOk,
                              colorOff: Colors.red,
                              colorOn: Colors.green,
                              width: width(100),
                              height: height(40),
                              onChanged: (value) {
                                FireStoreDatabase(uid: userId!.uid)
                                    .setVideoStatus(value: value);
                                print(value);
                              },
                            ),
                          ],
                        ),
                  SizedBox(
                    height: height(5),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height(20),
            ),
            Text(
              Language(code: language, text: [
                "Wallet ",
                "झोली",
                "মানিব্যাগ ",
                "பணப்பை ",
                "వాలెట్ "
              ]).getText,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: height(10),
            ),
            CustomContainer(
              radius: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Rs/- ${snapshot!.data!.get("coins")}",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold)),
                  TextButton(
                    child: Text(
                        Language(code: language, text: [
                          "Withdraw",
                          "निकासी करे",
                          "প্রত্যাহার",
                          "திரும்பப் பெறுங்கள்",
                          "ఉపసంహరించుకోండి"
                        ]).getText,
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (snapshot!.data!.get("coins") > 10) {
                        FirebaseFirestore.instance
                            .doc(
                                "coindWid/${UserDetails(snapshot: snapshot).uid}")
                            .set({"price": snapshot!.data!.get("coins")});
                        BotToast.showText(text: "Claimed");
                      } else {
                        BotToast.showText(
                            text: Language(code: language, text: [
                          "You must have at least 10 rupees for withdrawal. ",
                          "आपके पास कम से कम १० रूपए होने चाहिए निकासी के लिए  ",
                          "প্রত্যাহারের জন্য আপনার কমপক্ষে 10 টাকা থাকতে হবে। ",
                          "திரும்பப் பெற உங்களிடம் குறைந்தது 10 ரூபாய் இருக்க வேண்டும். ",
                          "ఉపసంహరణకు మీ వద్ద కనీసం 10 రూపాయలు ఉండాలి. "
                        ]).getText);
                      }
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: height(20),
            ),
            Text(
              Language(code: language, text: [
                "Last calls ",
                "पिछले कॉल्स  ",
                "শেষ কল ",
                "கடைசி அழைப்புகள் ",
                "చివరి కాల్స్ "
              ]).getText,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FireStoreDatabase(uid: userId!.uid).getCallHistory,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    height: online
                        ? MediaQuery.of(context).size.height * 0.45
                        : MediaQuery.of(context).size.height * 0.5,
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index == snapshot.data!.size) {
                            return SizedBox(
                              height: 50,
                            );
                          }
                          return CallTile(
                            language: language,
                            name: snapshot.data!.docs[index].get("title"),
                            image: snapshot.data!.docs[index].get("image"),
                            duration:
                                snapshot.data!.docs[index].get("subtitle"),
                            time: snapshot.data!.docs[index].get("time"),
                            type: snapshot.data!.docs[index].get("type"),
                            transactionId:
                                snapshot.data!.docs[index].get("TransactionId"),
                            coins: snapshot.data!.docs[index].get("coins"),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 0.4,
                            color: Colors.black54,
                          );
                        },
                        itemCount: snapshot.data!.docs.length),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class CallTile extends StatelessWidget {
  final String? name;
  final String? image;
  final Timestamp? time;
  final String? duration;
  final String? type;
  final int? transactionId;
  final int? coins;
  final language;

  const CallTile(
      {Key? key,
      this.name,
      this.image,
      this.time,
      this.duration,
      this.type,
      this.transactionId,
      this.coins,
      this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MagicScreen(context: context, height: 70).getHeight,
                width: MagicScreen(context: context, width: 70).getWidth,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(image!))),
              ),
              Column(
                children: [
                  Text("$name"),
                  Text(
                    "$duration",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  )
                ],
              ),
              Text(
                "Rs/- $coins",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
              ),
              Icon(
                type == "video" ? Icons.video_call : Icons.phone_callback,
                color: Colors.green,
              ),
            ],
          ),
          SizedBox(
            height: MagicScreen(context: context, height: 8).getHeight,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    Language(code: language, text: [" ", " ", " ", " ", " "])
                        .getText,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "${DateFormat.yMMMMd().format(time!.toDate())}   ${DateFormat.Hm().format(time!.toDate())}",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
