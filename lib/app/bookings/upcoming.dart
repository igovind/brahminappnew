import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/services_given/claim_reward.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/common_widgets/hexa_color.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'booking_tile.dart';

class Upcoming extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final UserId userId;

  const Upcoming({Key key, this.snapshot, this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    if (snapshot.data.docs.isEmpty) {
      return Center(
        child: Text("You don't have any upcoming puja"),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        final DocumentSnapshot ref = snapshot.data.docs[index];
        final String link = ref.data()['Link'];
        final String otp = ref.data()['otp'];
        dynamic cod = ref.data()['cod'];
        final bool samagri = ref.data()['samagri'];
        final double samagriPrice = ref.data()['samagri_price'];
        final String tuid = ref.data()['clientuid'];
        final double net = ref.data()['benefit'];
        final String serviceId = ref.id;
        final String contact = ref.data()['contact'];

        return Column(
          children: [
            BookingTiles(
                snapshot: snapshot.data.docs[index],
                onPressLocation: () async {
                  var url = '$link';
                  if (await canLaunch(url)) {
                    await launch(url);
                    BotToast.showText(text: "Opening Google Maps");
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Payment mode"),
                        Text(
                          cod != null && cod == true
                              ? ' Cash at home'
                              : ' Online',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height(5),
                    ),
                    Text("$contact"),
                    SizedBox(
                      height: height(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomRaisedButton(
                            child: Text(
                              'Mark as done',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: HexColor("#540D6E"),
                            //borderRadius: 12,
                            height: height(40),
                            onPressed: () => showDialog(
                                context: context,
                                child: ClaimReward(
                                  realOTP: otp,
                                  uid: userId.uid,
                                  tuid: tuid,
                                  samagri: samagri,
                                  net: net,
                                  samagriPrice: samagriPrice,
                                  serviceId: serviceId,
                                ))),
                        SizedBox(
                          width: height(10),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 4)
                            ],
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: IconButton(
                              icon: Icon(Icons.call),
                              color: Colors.white,
                              onPressed: () async {
                                var url = 'tel://$contact';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                  BotToast.showText(text: "calling $contact");
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                          padding: EdgeInsets.all(4),
                        )
                      ],
                    )
                  ],
                )),
          ],
        );
      },
    );
  }
}
