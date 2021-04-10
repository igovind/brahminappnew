import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/create_profile/edit_astrology_form.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../common_widgets/custom_slider.dart';

class EditAstrologyPrices extends StatelessWidget {
  final UserId userId;
  final AsyncSnapshot<DocumentSnapshot> snapshot;

  const EditAstrologyPrices({
    Key key,
    this.userId,
    this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }

    bool chatOk = snapshot.data.data()["chatOk"] ?? false;
    bool callOk = snapshot.data.data()["callOk"] ?? false;
    bool videoOk = snapshot.data.data()["videoOk"] ?? false;
    bool online = snapshot.data.data()["online"] ?? false;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*  SizedBox(
              height: height(30),
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Astrology",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w700),
                ),
                FlatButton(
                    onPressed: () {
                      showMaterialModalBottomSheet(
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
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: EditAstrologyForm(
                                uid: userId.uid,
                                snapshot: snapshot,
                              ));
                        },
                      );
                    },
                    child: Text(
                      "Edit",
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
                        "Available",
                        style: TextStyle(color: Colors.white),
                      ),
                      CustomSlider(
                        animationDuration: Duration(milliseconds: 100),
                        value: online,
                        width: width(100),
                        colorOff: Colors.red,
                        colorOn: Colors.green,
                        height: height(40),
                        onChanged: (bool value) {
                          FireStoreDatabase(uid: userId.uid)
                              .setOnlineStatus(value: value);
                          print(value);
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
                              "Message receive",
                              style: TextStyle(color: Colors.white),
                            ),
                            CustomSlider(
                              animationDuration: Duration(milliseconds: 100),
                              value: chatOk,
                              width: width(100),
                              colorOff: Colors.red,
                              colorOn: Colors.green,
                              height: height(40),
                              onChanged: (bool value) {
                                FireStoreDatabase(uid: userId.uid)
                                    .setMessageStatus(value: value);
                                print(value);
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
                            Text("Audio call receive",
                                style: TextStyle(color: Colors.white)),
                            CustomSlider(
                              animationDuration: Duration(milliseconds: 100),
                              value: callOk,
                              width: width(100),
                              height: height(40),
                              colorOff: Colors.red,
                              colorOn: Colors.green,
                              onChanged: (bool value) {
                                FireStoreDatabase(uid: userId.uid)
                                    .setCallStatus(value: value);
                                print(value);
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
                            Text("video call receive",
                                style: TextStyle(color: Colors.white)),
                            CustomSlider(
                              animationDuration: Duration(milliseconds: 100),
                              value: videoOk,
                              colorOff: Colors.red,
                              colorOn: Colors.green,
                              width: width(100),
                              height: height(40),
                              onChanged: (bool value) {
                                FireStoreDatabase(uid: userId.uid)
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
              "Wallet",
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
                  Text("Rs/- ${snapshot.data.data()["coins"]}",style: TextStyle(
                color: Colors.black54, fontWeight: FontWeight.bold)),
                  FlatButton(
                    child: Text("Claim",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .doc("coindWid/${UserDetails(snapshot: snapshot).uid}")
                          .set({"price": snapshot.data.data()["coins"]});
                      BotToast.showText(text: "Claimed");
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: height(20),
            ),
            Text(
              "Call history",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FireStoreDatabase(uid: userId.uid).getCallHistory,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    height: online
                        ? MediaQuery.of(context).size.height * 0.45
                        : MediaQuery.of(context).size.height * 0.62,
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CallTile(
                            name: snapshot.data.docs[index].data()["title"],
                            image: snapshot.data.docs[index].data()["image"],
                            duration:
                                snapshot.data.docs[index].data()["subtitle"],
                            time: snapshot.data.docs[index].data()["time"],
                            type: snapshot.data.docs[index].data()["type"],
                            transactionId:
                                snapshot.data.docs[index].data()["TransactionId"],
                            coins: snapshot.data.docs[index].data()["coins"],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 0.4,
                            color: Colors.black54,
                          );
                        },
                        itemCount: snapshot.data.docs.length),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class CallTile extends StatelessWidget {
  final String name;
  final String image;
  final Timestamp time;
  final String duration;
  final String type;
  final int transactionId;
  final int coins;

  const CallTile(
      {Key key,
      this.name,
      this.image,
      this.time,
      this.duration,
      this.type,
      this.transactionId,
      this.coins})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircularProfileAvatar(
                image,
                radius: MagicScreen(context: context, height: 20).getHeight,
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
                    "Transaction ID $transactionId",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "${DateFormat.yMMMMd().format(time.toDate())}   ${DateFormat.Hm().format(time.toDate())}",
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
