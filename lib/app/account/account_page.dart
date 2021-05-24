import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/account/bank_details.dart';
import 'package:brahminapp/app/account/choose_language.dart';
import 'package:brahminapp/app/account/edit_profile.dart';
import 'package:brahminapp/app/account/gallery_page.dart';
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/common_widgets/circular_profile_pic.dart';
import 'package:brahminapp/common_widgets/platform_alert_dialog.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'adhaar_details_page.dart';

class AccountPage extends StatefulWidget {
  final UserId? userId;
  final AsyncSnapshot<DocumentSnapshot>? snapshot;
  final AsyncSnapshot<DocumentSnapshot>? adhaarSnapshot;
  final AsyncSnapshot<DocumentSnapshot>? bankSnapshot;

  const AccountPage(
      {Key? key,
      this.userId,
      this.snapshot,
      this.adhaarSnapshot,
      this.bankSnapshot})
      : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Position? userLocation;
  bool locationLoading = false;
  Geoflutterfire geo = Geoflutterfire();
  GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;

  Future<void> _signOut(context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: Language(
              code: UserDetails(snapshot: widget.snapshot).language,
              text: ["Logout", "लॉग आउट", "প্রস্থান", "வெளியேறு", "లాగ్ అవుట్"])
          .getText,
      content: Language(
          code: UserDetails(snapshot: widget.snapshot).language,
          text: [
            "Are you sure that you want to logout?",
            "क्या आप वाकई लॉगआउट करना चाहते हैं?",
            "আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?",
            "நீங்கள் வெளியேற விரும்புகிறீர்களா?",
            "మీరు లాగ్ అవుట్ చేయాలనుకుంటున్నారా?"
          ]).getText,
      cancelActionText: Language(
          code: UserDetails(snapshot: widget.snapshot).language,
          text: [
            "Cancel",
            "रद्द करें",
            "বাতিল",
            "ரத்துசெய்",
            "రద్దు చేయండి"
          ]).getText,
      defaultActionText: Language(
              code: UserDetails(snapshot: widget.snapshot).language,
              text: ["Logout", "लॉग आउट", "প্রস্থান", "வெளியேறு", "లాగ్ అవుట్"])
          .getText,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<Position?> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
      print(e);
    }
    return currentLocation;
  }

  addGeoPoint() {
    if (userLocation == null) {
      return null;
    }
    GeoFirePoint point = geo.point(
        latitude: userLocation!.latitude, longitude: userLocation!.longitude);
    return point.data;
  }

  updateLocation() async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: Language(
          code: UserDetails(snapshot: widget.snapshot).language,
          text: [
            "Update location ",
            "स्थान अपडेट करें ",
            "আপডেট অবস্থান ",
            "இருப்பிடத்தைப் புதுப்பிக்கவும் ",
            "స్థానాన్ని నవీకరించండి "
          ]).getText,
      content: Language(
          code: UserDetails(snapshot: widget.snapshot).language,
          text: [
            "Are you sure that you want to update your current location? ",
            "क्या आप वाकई अपने वर्तमान स्थान को अपडेट करना चाहते हैं? ",
            "আপনি কি নিশ্চিত যে আপনি আপনার বর্তমান অবস্থান আপডেট করতে চান? ",
            "உங்கள் தற்போதைய இருப்பிடத்தைப் புதுப்பிக்க விரும்புகிறீர்களா? ",
            "మీరు మీ ప్రస్తుత స్థానాన్ని నవీకరించాలనుకుంటున్నారా? "
          ]).getText,
      cancelActionText: Language(
          code: UserDetails(snapshot: widget.snapshot).language,
          text: [
            "Cancel ",
            "रद्द करें ",
            "বাতিল ",
            "ரத்துசெய் ",
            "రద్దు చేయండి "
          ]).getText,
      defaultActionText: Language(
          code: UserDetails(snapshot: widget.snapshot).language,
          text: [
            "Update ",
            "अपडेट करें ",
            "হালনাগাদ ",
            "புதுப்பிப்பு ",
            "నవీకరణ "
          ]).getText,
    ).show(context);
    if (didRequestSignOut == true) {
      setState(() {
        locationLoading = true;
      });
      _getLocation().whenComplete(() {
        FireStoreDatabase(uid: widget.userId!.uid).updateData(data: {
          'location': addGeoPoint(),
        }).whenComplete(() {
          setState(() {
            locationLoading = false;
          });

           BotToast.showText(
              text: Language(
                  code: UserDetails(snapshot: widget.snapshot).language,
                  text: [
                "Location is updated ",
                "स्थान अपडेट किया गया है ",
                "অবস্থান আপডেট হয়েছে ",
                "இடம் புதுப்பிக்கப்பட்டது ",
                "స్థానం నవీకరించబడింది "
              ]).getText);
        });
      });
    }
  }

  @override
  void initState() {
    _getLocation().then((position) {
      userLocation = position;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }

    return Scaffold(
        //  backgroundColor: Colors.grey[100],
        body: locationLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height(430),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            height: height(200),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54, blurRadius: 5)
                                ],
                                image: DecorationImage(
                                    image: NetworkImage(
                                        UserDetails(snapshot: widget.snapshot)
                                            .coverPhoto!),
                                    fit: BoxFit.fitWidth),
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50))),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  //TODO:problem
                                   showDialog(
                                    //backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight:
                                                      Radius.circular(30))),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.95,
                                          child: EditProfile(

                                            uid: widget.userId!.uid,
                                            snapshot: widget.snapshot,
                                          ));
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black54,
                                            blurRadius: 3)
                                      ],
                                      color: Colors.deepOrangeAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    Language(
                                        code: UserDetails(
                                                snapshot: widget.snapshot)
                                            .language,
                                        text: [
                                          "Edit profile ",
                                          "प्रोफ़ाइल संपादित करें ",
                                          "জীবন বৃত্তান্ত সম্পাদনা ",
                                          "சுயவிவரத்தைத் திருத்து ",
                                          "ప్రొఫైల్‌ను సవరించండి "
                                        ]).getText,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              height: height(300),
                              width: width(300),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black54, blurRadius: 5)
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height(20),
                                  ),
                                  CircularProfilePic(
                                      imageUrl:
                                          UserDetails(snapshot: widget.snapshot)
                                              .profilePhoto,
                                      ),
                                  SizedBox(
                                    height: height(10),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${UserDetails(snapshot: widget.snapshot).name}",
                                        style: TextStyle(
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      UserDetails(snapshot: widget.snapshot)
                                              .verified!
                                          ? Icon(
                                              Icons.verified,
                                              color: Colors.deepOrangeAccent,
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  Text(
                                    "${UserDetails(snapshot: widget.snapshot).type}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${UserDetails(snapshot: widget.snapshot).swastik}  ",
                                        style: TextStyle(
                                            color: Colors.deepOrangeAccent),
                                      ),
                                      Icon(
                                        Icons.star_border,
                                        color: Colors.deepOrangeAccent,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.place,
                                        size: height(16),
                                        color: Colors.red,
                                      ),
                                      Text(
                                          "${UserDetails(snapshot: widget.snapshot).state}, "),
                                      Text(
                                          "${UserDetails(snapshot: widget.snapshot).city}"),
                                    ],
                                  ),
                                  Text(
                                    "${UserDetails(snapshot: widget.snapshot).aboutYou}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 20, context: context).getHeight,
                    ),
                    AccountTile(
                      title: Language(
                          code: UserDetails(snapshot: widget.snapshot).language,
                          text: [
                            "Gallery ",
                            "गेलरी ",
                            "গ্যালারী ",
                            "கேலரி ",
                            "గ్యాలరీ "
                          ]).getText,
                      icon: Icons.photo_camera,
                      child: GalleryPage(
                        language:
                            UserDetails(snapshot: widget.snapshot).language,
                        uid: widget.userId!.uid,
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 20, context: context).getHeight,
                    ),
                    AccountTile(
                      height: widget.bankSnapshot!.data!.data() == null
                          ? MagicScreen(height: 500, context: context).getHeight
                          : MagicScreen(height: 400, context: context)
                              .getHeight,
                      title: Language(
                          code: UserDetails(snapshot: widget.snapshot).language,
                          text: [
                            "Bank Details ",
                            "बैंक विवरण ",
                            "ব্যাংক বিবরণ ",
                            "வங்கி விவரங்கள் ",
                            "బ్యాంక్ వివరములు "
                          ]).getText,
                      icon: Icons.home_repair_service,
                      child: BankDetailsPage(
                        language:
                            UserDetails(snapshot: widget.snapshot).language,
                        uid: widget.userId!.uid,
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 20, context: context).getHeight,
                    ),
                    AccountTile(
                      height: widget.adhaarSnapshot!.data!.data() == null
                          ? MagicScreen(height: 660, context: context).getHeight
                          : MagicScreen(height: 500, context: context)
                              .getHeight,
                      title: Language(
                          code: UserDetails(snapshot: widget.snapshot).language,
                          text: [
                            "Adhaar details ",
                            "अधार विवरण ",
                            "আধার বিবরণ ",
                            "ஆதார் விவரங்கள் ",
                            "అధార్ వివరాలు "
                          ]).getText,
                      icon: Icons.file_copy_rounded,
                      child: AdhaarDetailsPage(
                        language:
                            UserDetails(snapshot: widget.snapshot).language,
                        uid: widget.userId!.uid,
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 20, context: context).getHeight,
                    ),
                    AccountTile(
                        height: MagicScreen(height: 300, context: context)
                            .getHeight,
                        title: Language(
                            code:
                                UserDetails(snapshot: widget.snapshot).language,
                            text: [
                              "Language ",
                              "भाषा ",
                              "ভাষা ",
                              "மொழி ",
                              "భాష "
                            ]).getText,
                        icon: Icons.language,
                        child: ChooseLanguage(
                          uid: widget.userId!.uid,
                          language:
                              UserDetails(snapshot: widget.snapshot).language,
                        )),
                    SizedBox(
                      height:
                          MagicScreen(height: 20, context: context).getHeight,
                    ),
                    AccountTile(
                      title: Language(
                          code: UserDetails(snapshot: widget.snapshot).language,
                          text: [
                            "Logout ",
                            "लॉग आउट ",
                            "প্রস্থান ",
                            "வெளியேறு ",
                            "లాగ్ అవుట్ "
                          ]).getText,
                      icon: Icons.logout,
                      onPress: () {
                        _confirmSignOut(context);
                      },
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 40, context: context).getHeight,
                    ),
                    AccountTile(
                      icon: Icons.add_location_alt,
                      title: Language(
                          code: UserDetails(snapshot: widget.snapshot).language,
                          text: [
                            "Tap to update location ",
                            "स्थान अपडेट करने के लिए टैप करें ",
                            "অবস্থান আপডেট করতে আলতো চাপুন ",
                            "இருப்பிடத்தைப் புதுப்பிக்க தட்டவும் ",
                            "స్థానాన్ని నవీకరించడానికి నొక్కండి "
                          ]).getText,
                      onPress: () {
                        updateLocation();
                      },
                    )
                  ],
                ),
              ));
  }
}

class AccountTile extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Widget? child;
  final VoidCallback? onPress;
  final double? height;

  const AccountTile(
      {Key? key, this.icon, this.title, this.child, this.onPress, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress ??
          () {
            /* showMaterialModalBottomSheet(
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
                    height: MagicScreen(height: height ?? 660, context: context)
                        .getHeight,
                    child: child);
              },
            );*/
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => child!));
          },
      child: Row(
        children: [
          SizedBox(
            width: MagicScreen(context: context, height: 20).getHeight,
          ),
          Icon(
            icon,
            color: Colors.deepOrangeAccent,
          ),
          Text(
            "  $title",
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
