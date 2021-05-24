import 'package:brahminapp/app/services_given/claim_reward.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/common_widgets/hexa_color.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../languages.dart';
import 'booking_tile.dart';

class Upcoming extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot>? snapshot;
  final UserId? userId;
  final language;

  const Upcoming({Key? key, this.snapshot, this.userId, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    if (snapshot!.data!.docs.isEmpty) {
      return Center(
        child: Text(
          Language(code: language, text: [
            "You don't have any upcoming puja ",
            "आपके पास कोई आगामी पूजा नहीं है ",
            "আপনার কোনও আসন্ন পূজা নেই ",
            "உங்களிடம் வரவிருக்கும் பூஜைகள் எதுவும் இல்லை ",
            "మీకు రాబోయే పూజలు లేవు "
          ]).getText,
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot!.data!.docs.length,
      itemBuilder: (context, index) {
        final DocumentSnapshot ref = snapshot!.data!.docs[index];
        final String? link = ref.get('Link');
        final String? otp = ref.get('otp');
        dynamic cod = ref.get('cod');
        final bool? samagri = ref.get('samagri');
        final double? samagriPrice = ref.get('samagri_price');
        final String? tuid = ref.get('clientuid');
        final double? net = ref.get('benefit');
        final String serviceId = ref.id;
        final String? contact = ref.get('contact');

        return Column(
          children: [
            BookingTiles(
                snapshot: snapshot!.data!.docs[index],
                onPressLocation: () async {
                  var url = '$link';
                  if (await canLaunch(url)) {
                    await launch(url);
                    //TODO: botToast
                  /*  BotToast.showText(
                      text: Language(code: language, text: [
                        "Google Maps is opening ",
                        "Google मानचित्र खुल रहा है ",
                        "গুগল ম্যাপস খুলছে ",
                        "கூகிள் மேப்ஸ் திறக்கிறது ",
                        "గూగుల్ మ్యాప్స్ తెరవబడుతున్నాయి "
                      ]).getText,
                    );*/
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
                        Text(
                          Language(code: language, text: [
                            "Payment mode ",
                            "भुगतान का प्रकार ",
                            "পরিশোধের মাধ্যম ",
                            "கட்டண முறை ",
                            "చెల్లింపు మోడ్ "
                          ]).getText,
                        ),
                        Text(
                          cod != null && cod == true
                              ? Language(code: language, text: [
                                  "Cash at home ",
                                  "घर पर नकदी ",
                                  "বাড়িতে নগদ ",
                                  "வீட்டில் பணம் ",
                                  "ఇంట్లో నగదు "
                                ]).getText
                              : Language(code: language, text: [
                                  "Online ",
                                  "ऑनलाइन ",
                                  "অনলাইন ",
                                  "நிகழ்நிலை ",
                                  "ఆన్‌లైన్ "
                                ]).getText,
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
                              Language(code: language, text: [
                                "Mark as done ",
                                "पूर्ण के रूप में चिह्नित करें ",
                                "সম্পন্ন হিসাবে চিহ্নিত করুন ",
                                "முடிந்தது என குறி ",
                                "ఐపోయినట్టుగా ముద్రించు "
                              ]).getText,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: HexColor("#540D6E"),
                            //borderRadius: 12,
                            height: height(40),
                            onPressed: () => showDialog(
                                context: context,
        builder:(context)=> ClaimReward(
                                  realOTP: otp,
                                  uid: userId!.uid,
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
                                  //TODO: botToast
                                  /*BotToast.showText(text: "calling $contact");*/
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
