import 'dart:typed_data';
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class ShareProfile extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot> userData;

  const ShareProfile({Key? key, required this.userData}) : super(key: key);

  @override
  _ShareProfileState createState() => _ShareProfileState();
}

class _ShareProfileState extends State<ShareProfile> {
  UserDetails? userDetails;
  String image =
      "https://firebasestorage.googleapis.com/v0/b/swastik13-8242d.appspot.com/o/inventories%2Fimportent%20images%2Fpujapurohit.in-2.png?alt=media&token=60f1a713-816a-406f-a0e4-f97984ae2e77";

  String profilePic =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/The_Uttar_Pradesh_Chief_Minister%2C_Shri_Yogi_Adityanath_meeting_the_President%2C_Shri_Ram_Nath_Kovind%2C_at_Rashtrapati_Bhavan%2C_in_New_Delhi_on_February_10%2C_2018_%28cropped%29.jpg/220px-thumbnail.jpg";

  String name = "योगी आदित्यनाथ";
  bool loading = false;
  GlobalKey _ssglobalKey = GlobalKey();
  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  _saveScreen() async {
    setState(() {
      loading = true;
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
          loading = false;
        });
        _toastInfo("Download successful");
        await WcFlutterShare.share(
            sharePopupTitle: 'share',
            subject: 'Download the app now',
            text: Language(text: [
              "For any type of worship, book me online now with Pooja Purohit Mobile App! Also get the material of worship at reasonable price.\n\n https://pujapurohit.in/#/profile?puid=${userDetails!.uid} \n\n Download the app now\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit",
              "किसी भी प्रकार की पूजा करवाने क लिए अब मुझे ऑनलाइन बुक करे पूजा पुरोहित मोबाइल ऍप से! साथ ही पाए पूजा की सामग्री उचित मूल्य पर\n\nhttps://pujapurohit.in/#/profile?puid=${userDetails!.uid} \n\n अभी ऐप डाउनलोड करें\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit",
              "যে কোনও ধরণের উপাসনার জন্য, আমাকে এখন অনলাইনে বুক করুন পূজা পুরোহিত মোবাইল অ্যাপ দিয়ে! যুক্তিসঙ্গত মূল্যে উপাসনার উপাদানও পান।\n\nhttps://pujapurohit.in/#/profile?puid=${userDetails!.uid} \n\n এখনই অ্যাপটি ডাউনলোড করুন\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit",
              "எந்தவொரு வழிபாட்டிற்கும், பூஜா புரோஹித் மொபைல் பயன்பாட்டுடன் இப்போது என்னை ஆன்லைனில் பதிவுசெய்க! வழிபாட்டுப் பொருள்களையும் நியாயமான விலையில் பெறுங்கள்.\n\nhttps://pujapurohit.in/#/profile?puid=${userDetails!.uid} \n\n பயன்பாட்டை இப்போது பதிவிறக்கவும்\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit",
              "ఏ రకమైన ఆరాధనకైనా, పూజా పురోహిత్ మొబైల్ అనువర్తనంతో ఇప్పుడు నన్ను ఆన్‌లైన్‌లో బుక్ చేసుకోండి! ఆరాధనను సరసమైన ధర వద్ద పొందండి.\n\nhttps://pujapurohit.in/#/profile?puid=${userDetails!.uid} \n\n అనువర్తనాన్ని ఇప్పుడే డౌన్‌లోడ్ చేయండి\n-->https://play.google.com/store/apps/details?id=com.pujapurohit.android.infopujapurohit"
            ], code: userDetails!.language)
                .getText,
            fileName: 'share.png',
            mimeType: 'image/png',
            bytesOfFile: byteData.buffer.asUint8List());
      } else {
        setState(() {
          loading = false;
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
    userDetails = UserDetails(snapshot: widget.userData);
    _requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height(double h) =>
        MagicScreen(context: context, height: h).getHeight;
    double width(double h) => MagicScreen(context: context, width: h).getWidth;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height(20),
            ),
            RepaintBoundary(
              key: _ssglobalKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Colors.black38,
                    )
                  ], color: Colors.white),
                  child: Stack(
                    children: [
                      Image.network(image),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: height(20),
                                ),
                                Container(
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
                                              userDetails!.profilePhoto!),
                                          fit: BoxFit.fitHeight)),
                                  height: height(150),
                                  width: width(150),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(height: height(180)),
                              Container(
                                  padding: EdgeInsets.all(20),
                                  // height: height(200),
                                  width: width(280),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.deepOrangeAccent,
                                            blurRadius: 1)
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Text(
                                            Language(text: [
                                              "Puja Purohit Certified Pandit",
                                              "पूजा पुरोहित प्रमाणित पंडित",
                                              "পূজা পুরোহিত শংসিত পণ্ডিত",
                                              "பூஜா புரோஹித் சான்றளிக்கப்பட்ட பண்டிட்",
                                              "పూజా పురోహిత్ సర్టిఫైడ్ పండిట్"
                                            ], code: userDetails!.language)
                                                .getText,
                                            style: TextStyle(
                                                color: Colors.deepOrange,
                                                shadows: [
                                                  BoxShadow(
                                                      color: Colors.black38,
                                                      blurRadius: 1)
                                                ]),
                                          ),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        color: Colors.orange[50],
                                        width: 300,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: width(20),
                                          ),
                                          Text(
                                            "${userDetails!.name}",
                                            style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontSize: 20,
                                                shadows: [
                                                  BoxShadow(
                                                      color: Colors.black38,
                                                      blurRadius: 3)
                                                ]),
                                          ),
                                          SizedBox(
                                            width: width(8),
                                          ),
                                          userDetails!.verified!
                                              ? Icon(
                                                  Icons.verified,
                                                  color: Colors.blueAccent,
                                                  size: 30,
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 20,
                                            color: Colors.deepOrange,
                                          ),
                                          Text("${userDetails!.state}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.call,
                                            size: 20,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              "${userDetails!.contact!.substring(0, 4)}XXXXX"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.language,
                                            size: height(20),
                                            color: Colors.deepPurple,
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            "${userDetails!.languageSpoken}",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(Language(text: [
                                            "Experience",
                                            "अनुभव",
                                            "অভিজ্ঞতা",
                                            "அனுபவம்",
                                            "అనుభవం"
                                          ], code: userDetails!.language)
                                              .getText),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("${userDetails!.experience}"),
                                        ],
                                      ),
                                    ],
                                  )),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
            // Image.file(File("file:///storage/emulated/0/Pictures/1627400247935.jpg")),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
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
                child: loading
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
              ),
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}
