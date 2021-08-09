import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../../../languages.dart';

class PanchangCard extends StatefulWidget {
  final text;
  final DateTime date;
  final String bgImage;
  final AsyncSnapshot<DocumentSnapshot> userData;

  const PanchangCard(
      {Key? key,
      required this.bgImage,
      required this.userData,
      this.text,
      required this.date})
      : super(key: key);

  @override
  _PanchangCardState createState() => _PanchangCardState();
}

class _PanchangCardState extends State<PanchangCard> {
  bool loadingSharing = false;
  GlobalKey _ssglobalKey = GlobalKey();

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  _saveScreen() async {
    setState(() {
      loadingSharing = true;
    });
    _toastInfo("Download started");
    RenderRepaintBoundary boundary = _ssglobalKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image imageo = await boundary.toImage(pixelRatio: 10);

    ByteData? byteData =
        await (imageo.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);

      if (result["isSuccess"] == true) {
        setState(() {
          loadingSharing = false;
        });
        _toastInfo("Download successful");
        await WcFlutterShare.share(
            sharePopupTitle: 'share',
            subject: 'Download the app now',
            text: Language(text: [
              "For any type of worship, book me online now with Pooja Purohit Mobile App! Also get the material of worship at reasonable price.\n\n https://pujapurohit.in/#/profile?puid=${UserDetails(snapshot: widget.userData).uid} \n\n Download the app now\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit",
              "किसी भी प्रकार की पूजा करवाने क लिए अब मुझे ऑनलाइन बुक करे पूजा पुरोहित मोबाइल ऍप से! साथ ही पाए पूजा की सामग्री उचित मूल्य पर\n\nhttps://pujapurohit.in/#/profile?puid=${UserDetails(snapshot: widget.userData).uid} \n\n अभी ऐप डाउनलोड करें\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit",
              "যে কোনও ধরণের উপাসনার জন্য, আমাকে এখন অনলাইনে বুক করুন পূজা পুরোহিত মোবাইল অ্যাপ দিয়ে! যুক্তিসঙ্গত মূল্যে উপাসনার উপাদানও পান।\n\nhttps://pujapurohit.in/#/profile?puid=${UserDetails(snapshot: widget.userData).uid} \n\n এখনই অ্যাপটি ডাউনলোড করুন\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit",
              "எந்தவொரு வழிபாட்டிற்கும், பூஜா புரோஹித் மொபைல் பயன்பாட்டுடன் இப்போது என்னை ஆன்லைனில் பதிவுசெய்க! வழிபாட்டுப் பொருள்களையும் நியாயமான விலையில் பெறுங்கள்.\n\nhttps://pujapurohit.in/#/profile?puid=${UserDetails(snapshot: widget.userData).uid} \n\n பயன்பாட்டை இப்போது பதிவிறக்கவும்\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit",
              "ఏ రకమైన ఆరాధనకైనా, పూజా పురోహిత్ మొబైల్ అనువర్తనంతో ఇప్పుడు నన్ను ఆన్‌లైన్‌లో బుక్ చేసుకోండి! ఆరాధనను సరసమైన ధర వద్ద పొందండి.\n\nhttps://pujapurohit.in/#/profile?puid=${UserDetails(snapshot: widget.userData).uid} \n\n అనువర్తనాన్ని ఇప్పుడే డౌన్‌లోడ్ చేయండి\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit"
            ], code: UserDetails(snapshot: widget.userData).language)
                .getText,
            fileName: 'share.png',
            mimeType: 'image/png',
            bytesOfFile: byteData.buffer.asUint8List());
      } else {
        setState(() {
          loadingSharing = false;
        });
        _toastInfo("Download failed");
      }
    }
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  @override
  void initState() {
    _requestPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height(double h) =>
        MagicScreen(context: context, height: h).getHeight;


    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Column(
            children: [
              RepaintBoundary(
                key: _ssglobalKey,
                child: Container(
                    padding: EdgeInsets.all(height(10)),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black54, blurRadius: 3)
                      ],
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          widget.bgImage,

                        ),
                        Positioned(
                          top: height(40),
                          left: height(10),
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.deepOrangeAccent,
                                      blurRadius: 2)
                                ],
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "${UserDetails(snapshot: widget.userData).profilePhoto}"),
                                    fit: BoxFit.fitHeight)),
                            height: 50,
                            width: 50,
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Language(
                                      code: UserDetails(snapshot: widget.userData)
                                          .language,
                                      text: [
                                        "Today's Panchang",
                                        "आज का पंचांग ",
                                        "আজকের পঞ্চং",
                                        "இன்றைய பஞ்சங்",
                                        "నేటి పంచాంగ్"
                                      ]).getText,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      shadows: [
                                        BoxShadow(
                                            color: Colors.deepOrange,
                                            blurRadius: 3)
                                      ],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  color: Colors.white,
                                  child: Text(
                                    "${widget.date.day}-${widget.date.month}-${widget.date.year}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                /*Text("Today is the Chaturdashi Tithi of the Margashirsha Maas, Krishna Paksha (darker phase of the Lunar fortnight), Vikram Samvat 2077, a Raviwar (Sunday). It is a day dedicated to Surya Dev (the Sun God). Worship Surya Dev as well as Lord Vishnu. Donate jaggery and food grains today. Read the Aditya Hridayam Stotram thrice and offer food to a cow. Perform the parikrama of Lord Vishnu's temple. Some people observe a fast. The Surya (the Sun) shall continue to be in Vrischik Rashi (Scorpio), while the Moon will move from Tula Rashi (Libra) to Vrishchik Rashi (Scorpio). Today, the Anuradha Nakshatra shall prevail.",

                                  textAlign: TextAlign.center,style: TextStyle(color: Colors.black,shadows: [BoxShadow(color: Colors.deepOrange,blurRadius: 0.5)],fontWeight: FontWeight.w500),),

                            */
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  /*     child: Text(
                                    "आज 29 जुलाई 2021, दिन गुरुवार को श्रावण कृष्ण पक्ष षष्ठी, आनन्द संवत्सर विक्रम संवत 2078, शक संवत 1943 (प्लव संवत्सर), आषाढ़। षष्ठी तिथि देर रात 03 बजकर 54 मिनट तक उपरांत सप्तमी। नक्षत्र उत्तरभाद्रपदा दोपहर 12 बजकर 02 मिनट तक उपरांत रेवती। सुकर्मा योग रात 08 बजकर 02 मिनट तक, उसके बाद धृति योग। करण गर दोपहर 03 बजकर 16 मिनट तक, बाद वणिज देर सुबह 03 बजकर 54 मिनट तक, बाद विष्टि। चन्द्रमा मीन राशि पर संचार करेगा। \n आज सप्तमी तिथि 05:40 AM तक उपरांत अष्टमी | नक्षत्र रेवती 02:02 PM तक उपरांत अश्विनी | धृति योग 08:19 PM तक, उसके बाद शूल योग | करण विष्टि 04:43 PM तक, बाद बव 05:41 AM तक, बाद बालव | आज राहु काल का समय 10:55 AM - 12:33 PM है | आज 02:02 PM तक चन्द्रमा मीन उपरांत मेष राशि पर संचार करेगा |",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.deepOrange,
                                              blurRadius: 1)
                                        ],
                                        fontWeight: FontWeight.w500),
                                  ),*/
                                  child: Text(
                                   "${Language(code: UserDetails(snapshot: widget.userData).language,text: widget.text).getText}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.deepOrange,
                                              blurRadius: 1)
                                        ],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _saveScreen();
                    /*    Share.shareFiles(
                  ["file:///storage/emulated/0/Pictures/1627400247935.jpg"],
                  subject: 'Screenshot + Share',
                  text: 'Hey, check it out the sharefiles repo!',
                );*/
                  });
                },
                child: loadingSharing
                    ? CircularProgressIndicator()
                    : Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black54, blurRadius: 3)
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.indigo),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Language(
                                  code: UserDetails(snapshot: widget.userData)
                                      .language,
                                  text: [
                                    "Share",
                                    "शेयर",
                                    "ভাগ",
                                    "பகிர்",
                                    "పంచుకోండి"
                                  ]).getText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.share_outlined,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
              )
            ],
          )),
    );
  }
}
