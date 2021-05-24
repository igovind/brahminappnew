import 'package:brahminapp/app/bookings/booking_tile.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../languages.dart';

class BookingRequest extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot>? snapshot;
  final language;
  final UserId? userId;

  const BookingRequest({Key? key, this.snapshot, this.userId, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    String? url = userId!.photoUrl;
    if (snapshot!.data!.docs.isEmpty) {
      return Center(
        child: Text(
          Language(code: language, text: [
            "You don't have any booking request ",
            "आपके पास कोई बुकिंग अनुरोध नहीं है ",
            "আপনার কাছে কোনও বুকিংয়ের অনুরোধ নেই ",
            "உங்களிடம் எந்த முன்பதிவு கோரிக்கையும் இல்லை ",
            "మీకు బుకింగ్ అభ్యర్థన లేదు "
          ]).getText,
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot!.data!.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot ref = snapshot!.data!.docs[index];
        final String? service = ref.get('service');
        final String? client = ref.get('client');
        final String? tuid = ref.get('clientuid');
        final String? serviceId = ref.get('serviceId');
        final bool? accepted = ref.get('request');
        final bool cancel = ref.get('cancel');
        final String tid = ref.id;
        return BookingTiles(
          language: language,
          snapshot: snapshot!.data!.docs[index],
          onPressLocation: () {},
          child: cancel
              ? Container(
                  padding: EdgeInsets.all(1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Language(code: language, text: [
                          "Canceled by $client ",
                          "$client द्वारा रद्द किया गया ",
                          "$client দ্বারা বাতিল ",
                          "$client ரத்து செய்தார் ",
                          "$client రద్దు చేశారు "
                        ]).getText,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            FireStoreDatabase(uid: userId!.uid)
                                .deleteBooking(tid);
                          })
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                )
              : accepted!
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          Language(code:language, text: [
                            "Payment is pending ",
                            "भुगतान लंबित है ",
                            "অর্থ মুলতুবি রয়েছে ",
                            "கட்டணம் நிலுவையில் உள்ளது ",
                            "చెల్లింపు పెండింగ్‌లో ఉంది "
                          ]).getText,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomRaisedButton(
                          color: Colors.lightGreen,
                          child: Text(
                              Language(code:language, text: [
                                "Accept ",
                                "स्वीकार ",
                                "গ্রহণ ",
                                "ஏற்றுக்கொள் ",
                                "అంగీకరించు "
                              ]).getText,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          height: height(40),
                          onPressed: () {
                            FireStoreDatabase(uid: userId!.uid).updateBooking(
                                serviceId: serviceId,
                                service: service,
                                pPic: url,
                                tuid: tuid,
                                tid: tid,
                                bookingAccepted: true);
                            //TODO: botToast
                           /* BotToast.showText(text: Language(code:language, text: [
                              "Accepted ",
                              "स्वीकार किया ",
                              "স্বীকৃত ",
                              "ஏற்றுக்கொள்ளப்பட்டது ",
                              "ఆమోదించబడిన "
                            ]).getText,);*/
                          },
                        ),
                        CustomRaisedButton(
                          color: Colors.redAccent[100],
                          child: Text(
                              Language(code:language, text: [
                                "Reject ",
                                "अस्वीकार ",
                                "প্রত্যাখ্যান ",
                                "நிராகரி ",
                                "తిరస్కరించండి "
                              ]).getText,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          height: height(40),
                          onPressed: () {
                            FireStoreDatabase(uid: userId!.uid).updateBooking(
                                serviceId: serviceId,
                                pPic: url,
                                service: service,
                                tuid: tuid,
                                tid: tid,
                                bookingAccepted: false);
                            //TODO: botToast
                           /* BotToast.showText(text:  Language(code:language, text: [
                              "Rejected ",
                              "अस्वीकृत ",
                              "প্রত্যাখ্যাত ",
                              "நிராகரிக்கப்பட்டது ",
                              "తిరస్కరించబడింది "
                            ]).getText,);*/
                          },
                        )
                      ],
                    ),
        );
      },
    );
  }
}
