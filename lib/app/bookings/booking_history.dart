import 'package:brahminapp/app/bookings/star_rating.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../languages.dart';
import 'booking_tile.dart';

class BookingHistory extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final UserId userId;
  final language;

  const BookingHistory({Key key, this.snapshot, this.userId, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    /*   double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }*/

    if (snapshot.data.docs.isEmpty) {
      return Center(
        child: Text(
          Language(code: language, text: [
            "You did not complete any puja ",
            "आप ने कोई पूजा सम्पूर्ण नहीं किआ  ",
            "আপনি কোন পূজা সম্পূর্ণ করেন নি ",
            "நீங்கள் எந்த வழிபாட்டையும் முடிக்கவில்லை ",
            "మీరు ఏ ఆరాధనను పూర్తి చేయలేదు "
          ]).getText,
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot ref = snapshot.data.docs[index];
        final double swastik = ref.data()['swastik'];
        final String contact = ref.data()['contact'];
        dynamic cod = ref.data()['cod'];
        return BookingTiles(
          snapshot: snapshot.data.docs[index],
          onPressLocation: () {},
          child: Column(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "  $swastik",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  StarRating(
                    swastik: swastik,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
