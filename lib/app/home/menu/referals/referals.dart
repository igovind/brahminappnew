import 'package:brahminapp/app/account/okay_button.dart';
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Referals extends StatelessWidget {
  final AsyncSnapshot<DocumentSnapshot>? snapshot;
  final AsyncSnapshot<DocumentSnapshot>? refSnap;
  final language;

  const Referals({Key? key, this.snapshot, this.refSnap, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: UserDetails(snapshot: snapshot).uid)
            .getReferrals,
        builder: (context, refSnapshot) {
          if (refSnapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 20,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                Language(code: language, text: [
                  "Your code is ${UserDetails(snapshot: snapshot).refCode} ",
                  "आपका कोड ${UserDetails(snapshot: snapshot).refCode} है",
                  "আপনার কোড ${UserDetails(snapshot: snapshot).refCode} ",
                  "உங்கள் குறியீடு ${UserDetails(snapshot: snapshot).refCode} ஆகும் ",
                  "మీ కోడ్ ${UserDetails(snapshot: snapshot).refCode}  "
                ]).getText,
                style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16),
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: () {
                String st = Language(code: language, text: [
                  "${refSnap!.data!.get("ref_text1")} *${UserDetails(snapshot: snapshot).name}* ${refSnap!.data!.get("ref_text")} \n \n \n *Link:* ${refSnap!.data!.get("link")} \n\n REFERAL CODE: *${UserDetails(snapshot: snapshot).refCode}*  ",
                  "${refSnap!.data!.get("ref_text_hin1")} *${UserDetails(snapshot: snapshot).name}* ${refSnap!.data!.get("ref_text_hin")} \n \n \n *Link:* ${refSnap!.data!.get("link")} \n\n REFERAL CODE: *${UserDetails(snapshot: snapshot).refCode}*  ",
                  "${refSnap!.data!.get("ref_text_ben1")} *${UserDetails(snapshot: snapshot).name}* ${refSnap!.data!.get("ref_text_ben")} \n \n \n *Link:* ${refSnap!.data!.get("link")} \n\n REFERAL CODE: *${UserDetails(snapshot: snapshot).refCode}*  ",
                  "${refSnap!.data!.get("ref_text_tam1")} *${UserDetails(snapshot: snapshot).name}* ${refSnap!.data!.get("ref_text_tam")} \n \n \n *Link:* ${refSnap!.data!.get("link")} \n\n REFERAL CODE: *${UserDetails(snapshot: snapshot).refCode}*  ",
                  "${refSnap!.data!.get("ref_text_tel1")} *${UserDetails(snapshot: snapshot).name}* ${refSnap!.data!.get("ref_text_tel")} \n \n \n *Link:* ${refSnap!.data!.get("link")} \n\n REFERAL CODE: *${UserDetails(snapshot: snapshot).refCode}*  "
                ]).getText;
                Share.share(st);
                print(st);
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Language(code: language, text: [
                        "Refer ",
                        "आमंत्रण  ",
                        "আমন্ত্রণ জানান ",
                        "அழைக்கவும் ",
                        "ఆహ్వానించండి "
                      ]).getText,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.share_sharp,
                      color: Colors.white,
                    ),
                  ],
                ),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blueAccent[100],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            body: refSnapshot.data!.docs.isEmpty
                ? Center(
                    child: Text(
                      Language(code: language, text: [
                        "There is no Referal Please share this app with your contact for more benefits ",
                        "कोई रेफ़रल नहीं है कृपया अधिक लाभों के लिए इस ऐप को अपने संपर्क के साथ साझा करें ",
                        "কোনও রেফারাল নেই দয়া করে আরও সুবিধার জন্য এই অ্যাপটি আপনার যোগাযোগের সাথে ভাগ করুন ",
                        "ரெஃபரல் இல்லை மேலும் பல நன்மைகளுக்கு இந்த பயன்பாட்டை உங்கள் தொடர்புடன் பகிரவும் ",
                        "రెఫరల్ లేదు దయచేసి మరిన్ని ప్రయోజనాల కోసం ఈ అనువర్తనాన్ని మీ పరిచయంతో భాగస్వామ్యం చేయండి "
                      ]).getText,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: refSnapshot.data!.size,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.black38,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(refSnapshot
                                      .data!.docs[index]
                                      .get("profilePicUrl")))),
                        ),
                        title: Text(
                            "${refSnapshot.data!.docs[index].get("firstName")}",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "${refSnapshot.data!.docs[index].get("aboutYou")}",
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }),
          );
        });
  }
}
