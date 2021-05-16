import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/common_widgets/CustomSearchableDropdown.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/common_widgets/platform_alert_dialog.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brahminapp/app/languages.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class RegistrationForm extends StatefulWidget {
  final uid;
  final language;
  final AsyncSnapshot<DocumentSnapshot> snapshot;

  const RegistrationForm({Key key, this.uid, this.snapshot, this.language})
      : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _sTFormKey = GlobalKey<FormState>();
  File userProfilePicFile;
  File userCoverPicFile;
  bool inProcess = false;
  bool loading = false;
  String fullName;
  String aboutYou;
  String state;
  String city;
  String contact;
  String profilePicUrl;
  String coverPicUrl;
  String punditType;
  String refBy;

  Position userLocation;
  bool locationLoading = false;
  Geoflutterfire geo = Geoflutterfire();
  GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;
  String tokens;
  bool found;
  String refName;
  String refPicUrl;
  String refAbt;
  String refUID;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  bool _validateAndSaveForm() {
    final form = _sTFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<Position> _getLocation() async {
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
        latitude: userLocation.latitude, longitude: userLocation.longitude);
    return point.data;
  }

  updateLocation() async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Update location',
      content: 'Are you sure that you want to update your current location?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Update',
    ).show(context);
    if (didRequestSignOut == true) {
      setState(() {
        locationLoading = true;
      });
      _getLocation().whenComplete(() {
        FireStoreDatabase(uid: widget.uid).updateData(data: {
          'location': addGeoPoint(),
        }).whenComplete(() {
          setState(() {
            locationLoading = false;
          });
          BotToast.showText(text: "Location is updated");
        });
      });
    }
  }

  getProfilePic({ImageSource source}) async {
    this.setState(() {
      inProcess = true;
    });
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image = await ImagePicker.platform.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
      );

      this.setState(() {
        userProfilePicFile = cropped;
        inProcess = false;
      });
    } else {
      this.setState(() {
        inProcess = false;
      });
    }
  }

  getCoverPic({ImageSource source}) async {
    this.setState(() {
      inProcess = true;
    });
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image = await ImagePicker.platform.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
      );

      this.setState(() {
        userCoverPicFile = cropped;
        inProcess = false;
      });
    } else {
      this.setState(() {
        inProcess = false;
      });
    }
  }

  Future<String> submitCoverPic() async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('Users/${widget.uid}/coverPicFile');
    StorageUploadTask uploadTask = reference.putFile(userCoverPicFile);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    coverPicUrl = url;
    return downloadUrl.toString();
  }

  Future<String> submitProfilePic() async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('Users/${widget.uid}/profilePicFile');
    StorageUploadTask uploadTask = reference.putFile(userProfilePicFile);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    profilePicUrl = url;
    return downloadUrl.toString();
  }

  String _availableCode() {
    String code = widget.snapshot.data.data()["available_code"].toString();
    return code;
  }

  _submit() async {
    if (_validateAndSaveForm() &&
        (userCoverPicFile != null) &&
        (userProfilePicFile != null)) {
      setState(() {
        loading = true;
      });
      String profileUrl = await submitProfilePic();
      String coverUrl = await submitCoverPic();
      String code = _availableCode();
      FireStoreDatabase(uid: widget.uid).setData(data: {
        'firstName': capitalize(fullName),
        'aboutYou': aboutYou,
        'number': contact,
        'state': state,
        'type': punditType,
        'refCode': "G" + code,
        'profilePicUrl': profileUrl,
        'coverpic': coverUrl,
        'searchKey': fullName[0].toUpperCase().toString(),
        'lastName': city,
        'punditID':
            "RK${DateTime.now().year}$code${DateTime.now().month}${DateTime.now().day}",
        'location': addGeoPoint() ?? null,
        'token': tokens,
        'setReward': 0,
        'setPrice': 0.0,
        'uid': widget.uid,
        'dateOfBirth': 'no',
        'swastik': 0.0,
        'verified': false,
        'ready': false,
        'reName': refName,
        'refUID': refUID,
        'refImg': refPicUrl,
        'PujaKeywords': '#',
        "index": 1,
        "langCode": widget.language,
        "lang": Language(code: widget.language).getLang,
        "dateOfProfileCreation": FieldValue.serverTimestamp(),
        "dateOfProfileUpdate":
            FieldValue.arrayUnion([DateTime.now()])
      }).whenComplete(() {
        Auth().updateUser("$fullName", profileUrl);
        FireStoreDatabase(uid: widget.uid).setAvailableCode();
        FireStoreDatabase(uid: widget.uid).setRefCode(ref: "G" + code, data: {
          'name': capitalize(fullName),
          'image': profileUrl,
          'punditID':
              "RK${DateTime.now().year}$code${DateTime.now().month}${DateTime.now().day}",
          'token': tokens,
          'uid': widget.uid
        });
      }).whenComplete(() async {
        if (refBy.isNotEmpty) {
          DocumentSnapshot snap =
              await FirebaseFirestore.instance.doc("referal/$refBy").get();
          String refUid = snap.data()["uid"];
          String qtoken = snap.data()["token"];
          String image = profileUrl;
          String sender = "Referral code applied";
          String content =
              "Your referral code has used by $fullName from $state";
          if (snap.data() != null) {
            FirebaseFirestore.instance
                .collection("punditUsers/$refUid/referrals")
                .doc(widget.uid)
                .set({
              'firstName': capitalize(fullName),
              'aboutYou': aboutYou,
              'number': contact,
              'state': state,
              'type': punditType,
              'refCode': "G" + code,
              'profilePicUrl': profileUrl,
              'coverpic': coverUrl,
              'searchKey': fullName[0].toUpperCase().toString(),
              'lastName': city,
              'token': qtoken,
              'image': image,
              'sender': sender,
              'content': content,
              'punditID':
                  "RK${DateTime.now().year}$code${DateTime.now().month}${DateTime.now().day}",
            });
          }
        }
      }).whenComplete(() async {
        if (this.mounted) {
          setState(() {
            loading = true;
            BotToast.showText(
              text: Language(code: widget.language, text: [
                "Information saved ",
                "पूरा हुआ ",
                "সমাপ্ত ",
                "நிறைவு ",
                "పూర్తయింది "
              ]).getText,
            );
          });
        }
      });
    } else {
      if (userProfilePicFile == null && userProfilePicFile == null) {
        BotToast.showText(
          text: Language(code: widget.language, text: [
            "Please add profile and cover picture ",
            "कृपया प्रोफ़ाइल और कवर चित्र जोड़ें ",
            "দয়া করে প্রোফাইল এবং কভার ছবি যুক্ত করুন ",
            "சுயவிவரம் மற்றும் அட்டைப் படத்தைச் சேர்க்கவும் ",
            "దయచేసి ప్రొఫైల్ మరియు కవర్ చిత్రాన్ని జోడించండి "
          ]).getText,
        );
      } else {
        if (userProfilePicFile == null) {
          BotToast.showText(
            text: Language(code: widget.language, text: [
              "Please add profile picture ",
              "कृपया प्रोफ़ाइल चित्र जोड़ें ",
              "দয়া করে প্রোফাইল ছবি যুক্ত করুন ",
              "சுயவிவரப் படத்தைச் சேர்க்கவும் ",
              "దయచేసి ప్రొఫైల్ చిత్రాన్ని జోడించండి "
            ]).getText,
          );
        }
        if (userCoverPicFile == null) {
          BotToast.showText(
            text: Language(code: widget.language, text: [
              "Please add cover picture ",
              "কভার ছবি যোগ করুন ",
              "कृपया कवर चित्र जोड़ें ",
              "அட்டைப் படத்தைச் சேர்க்கவும் ",
              "కవర్ చిత్రాన్ని జోడించండి "
            ]).getText,
          );
        }
      }
    }
  }

  @override
  void initState() {
    _messaging.getToken().then((token) {
      setState(() {
        tokens = token;
      });
    });
    _getLocation().then((position) {
      userLocation = position;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 30,
          actions: [
            loading
                ? SizedBox()
                : FlatButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black54, blurRadius: 3)
                          ],
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        Language(code: widget.language, text: [
                          "Next",
                          "आगे बढ़ें",
                          "এগিয়ে যান",
                          "மேலே செல்லுங்கள்",
                          "ముందుకి వెళ్ళు"
                        ]).getText,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                  )
          ],
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _sTFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: MagicScreen(height: 270, context: context)
                              .getHeight,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  getCoverPic(source: ImageSource.gallery);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 15),
                                  height:
                                      MagicScreen(height: 200, context: context)
                                          .getHeight,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black54,
                                            blurRadius: 5)
                                      ],
                                      image: DecorationImage(
                                          image: userCoverPicFile == null
                                              ? AssetImage(
                                                  "images/cover_image.jpg")
                                              : FileImage(userCoverPicFile),
                                          fit: BoxFit.fitWidth),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(25),
                                          bottomRight: Radius.circular(25))),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: CircularProfileAvatar(
                                  "",
                                  child: userProfilePicFile == null
                                      ? Image.asset("images/placeholder.jpg")
                                      : Image.file(userProfilePicFile),
                                  radius:
                                      MagicScreen(context: context, height: 60)
                                          .getHeight,
                                  elevation: 8,
                                  onTap: () {
                                    getProfilePic(source: ImageSource.gallery);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MagicScreen(context: context, height: 10)
                                .getHeight),
                        CustomContainer(
                          radius: 10,
                          child: TextFormField(
                              maxLength: 30,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  border: InputBorder.none,
                                  labelText:
                                      Language(code: widget.language, text: [
                                    "*Your full name",
                                    "*आपका पूरा नाम",
                                    "*আপনার পূর্ণ নাম",
                                    "*உன் முழு பெயர்",
                                    "*మీ పూర్తి పేరు"
                                  ]).getText),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return Language(code: widget.language, text: [
                                    "This field is required",
                                    "यह फ़ील्ड आवश्यक है",
                                    "ঘরটি অবশ্যই পূরণ করতে হবে",
                                    "இந்த புலம் தேவை",
                                    "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                  ]).getText;
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  fullName = value;
                                });
                              } //_benefits = value,
                              ),
                        ),
                        SizedBox(
                            height: MagicScreen(context: context, height: 10)
                                .getHeight),
                        CustomContainer(
                          radius: 10,
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  border: InputBorder.none,
                                  labelText: Language(
                                      code: widget.language,
                                      text: [
                                        "Mobile Number",
                                        "मोबाइल नंबर",
                                        "মোবাইল নম্বর",
                                        "கைபேசி எண்",
                                        "మొబైల్ సంఖ్య"
                                      ]).getText),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return Language(code: widget.language, text: [
                                    "This field is required",
                                    "यह फ़ील्ड आवश्यक है",
                                    "ঘরটি অবশ্যই পূরণ করতে হবে",
                                    "இந்த புலம் தேவை",
                                    "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                  ]).getText;
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  contact = value;
                                });
                              } //_benefits = value,
                              ),
                        ),
                        SizedBox(
                            height: MagicScreen(context: context, height: 10)
                                .getHeight),
                        CustomContainer(
                          radius: 10,
                          child: TextFormField(
                              maxLength: 100,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  border: InputBorder.none,
                                  labelText: Language(
                                      code: widget.language,
                                      text: [
                                        "About you",
                                        "आपके बारे में",
                                        "তোমার সম্পর্কে",
                                        "உன்னை பற்றி",
                                        "నీ గురించి"
                                      ]).getText),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return Language(code: widget.language, text: [
                                    "This field is required",
                                    "यह फ़ील्ड आवश्यक है",
                                    "ঘরটি অবশ্যই পূরণ করতে হবে",
                                    "இந்த புலம் தேவை",
                                    "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                  ]).getText;
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  aboutYou = value;
                                });
                              } //_benefits = value,
                              ),
                        ),
                        SizedBox(
                            height: MagicScreen(context: context, height: 10)
                                .getHeight),
                        CustomContainer(
                            radius: 10,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: FireStoreDatabase(uid: widget.uid)
                                      .getStates,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    List<dynamic> statesArray =
                                        snapshot.data.data()['states'];
                                    List<DropdownMenuItem<String>> statesList =
                                        [];
                                    for (int i = 0;
                                        i < statesArray.length;
                                        i++) {
                                      String name = statesArray[i];
                                      statesList.add(DropdownMenuItem(
                                        value: name,
                                        child: Text(name),
                                      ));
                                    }
                                    return CustomSearchableDropdown.single(
                                      key: UniqueKey(),
                                      validator: (String value) {
                                        value = value == null
                                            ? UserDetails(snapshot: null).state
                                            : value;
                                        if (value == null) {
                                          return Language(
                                              code: widget.language,
                                              text: [
                                                "This field is required",
                                                "यह फ़ील्ड आवश्यक है",
                                                "ঘরটি অবশ্যই পূরণ করতে হবে",
                                                "இந்த புலம் தேவை",
                                                "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                              ]).getText;
                                        }
                                        return null;
                                      },
                                      underline: SizedBox(),
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      items: statesList,

                                      label: Language(
                                          code: widget.language,
                                          text: [
                                            "Select your state",
                                            "अपना राज्य चुनें",
                                            "আপনার রাষ্ট্র নির্বাচন করুন",
                                            "உங்கள் மாநிலத்தைத் தேர்ந்தெடுக்கவும்",
                                            "మీ రాష్ట్రాన్ని ఎంచుకోండి"
                                          ]).getText,
                                      lableColor: Colors.black54,
                                      isExpanded: true,
                                      //icon: Icon(Icons.description),
                                      displayClearIcon: false,
                                      hint: state ??
                                          "${UserDetails(snapshot: null).state}",
                                      //underline: false,
                                      searchHint: Language(
                                          code: widget.language,
                                          text: [
                                            "Select one ",
                                            "एक का चयन करें ",
                                            "একটা নির্বাচন করুন ",
                                            "ஒன்றை தேர்ந்தெடு ",
                                            "ఒకటి ఎంచుకో "
                                          ]).getText,
                                      onChanged: (String value) {
                                        setState(() {
                                          state = value;
                                        });
                                      },
                                    );
                                  }),
                            )),
                        SizedBox(
                            height: MagicScreen(context: context, height: 10)
                                .getHeight),
                        CustomContainer(
                          radius: 10,
                          child: TextFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return Language(code: widget.language, text: [
                                    "This field is required",
                                    "यह फ़ील्ड आवश्यक है",
                                    "ঘরটি অবশ্যই পূরণ করতে হবে",
                                    "இந்த புலம் தேவை",
                                    "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                  ]).getText;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                border: InputBorder.none,
                                labelText: Language(
                                    code: widget.language,
                                    text: [
                                      "Your city ",
                                      "आपका शहर  ",
                                      "তোমার শহর ",
                                      "உங்கள் நகரம் ",
                                      "మీ నగరం "
                                    ]).getText,
                              ),
                              onSaved: (value) {
                                setState(() {
                                  city = value;
                                });
                              } //_benefits = value,
                              ),
                        ),
                        SizedBox(
                            height: MagicScreen(context: context, height: 10)
                                .getHeight),
                        CustomContainer(
                          radius: 10,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FireStoreDatabase(uid: widget.uid)
                                    .getPunditTypes,
                                builder: (context, snapshot1) {
                                  if (snapshot1.data == null) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  List<dynamic> typeArray =
                                      snapshot1.data.data()['punditTypes'];

                                  List<DropdownMenuItem<String>> typeList = [];
                                  for (int i = 0; i < typeArray.length; i++) {
                                    String name = typeArray[i];
                                    typeList.add(DropdownMenuItem(
                                      value: name,
                                      child: Text(name),
                                    ));
                                  }
                                  return CustomSearchableDropdown.single(
                                    disabledHint: true,
                                    validator: (String value) {
                                      value = value == null
                                          ? UserDetails(snapshot: null).type
                                          : value;
                                      if (value == null) {
                                        return Language(
                                            code: widget.language,
                                            text: [
                                              "This field is required",
                                              "यह फ़ील्ड आवश्यक है",
                                              "ঘরটি অবশ্যই পূরণ করতে হবে",
                                              "இந்த புலம் தேவை",
                                              "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                            ]).getText;
                                      }
                                      return null;
                                    },
                                    label:
                                        Language(code: widget.language, text: [
                                      "Select Pandit Type ",
                                      "पंडित प्रकार का चयन करें ",
                                      "পন্ডিত প্রকার নির্বাচন করুন ",
                                      "பண்டிட் வகையைத் தேர்ந்தெடுக்கவும் ",
                                      "పండిట్ రకాన్ని ఎంచుకోండి "
                                    ]).getText,
                                    lableColor: Colors.black54,
                                    icon: Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    underline: SizedBox(),
                                    items: typeList,

                                    isExpanded: true,
                                    //icon: Icon(Icons.description),
                                    displayClearIcon: false,

                                    //underline: false,
                                    searchHint:
                                        Language(code: widget.language, text: [
                                      "Select one ",
                                      "एक का चयन करें ",
                                      "একটা নির্বাচন করুন ",
                                      "ஒன்றை தேர்ந்தெடு ",
                                      "ఒకటి ఎంచుకో "
                                    ]).getText,
                                    onChanged: (String value) {
                                      setState(() {
                                        punditType = value;
                                      });
                                    },
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                            height: MagicScreen(context: context, height: 30)
                                .getHeight),
                        found == null
                            ? SizedBox()
                            : found
                                ? Center(
                                    child: ListTile(
                                      title: Text(
                                        "$refName",
                                        style: TextStyle(
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      leading: CircularProfileAvatar(
                                        "$refPicUrl",
                                        radius: 20,
                                      ),
                                    ),
                                  )
                                : Text(
                                    Language(code: widget.language, text: [
                                      "invalid referral code ",
                                      "अमान्य रेफरल कोड ",
                                      "অবৈধ রেফারেল কোড ",
                                      "தவறான பரிந்துரை குறியீடு ",
                                      "చెల్లని రిఫెరల్ కోడ్ "
                                    ]).getText,
                                    style: TextStyle(
                                        color: Colors.deepOrangeAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                        SizedBox(
                            height: MagicScreen(context: context, height: 10)
                                .getHeight),
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 2,
                              child: CustomContainer(
                                radius: 30,
                                child: TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      border: InputBorder.none,
                                      labelText: Language(
                                          code: widget.language,
                                          text: [
                                            "referral code ",
                                            "रेफरल कोड ",
                                            "রেফারেল কোড ",
                                            "பரிந்துரை குறியீடு ",
                                            "రిఫెరల్ కోడ్ "
                                          ]).getText,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        refBy = value;
                                      });
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        if (value != null) {
                                          refBy = value;
                                        }
                                      });
                                    } //_benefits = value,
                                    ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: FlatButton(
                                  onPressed: () async {
                                    DocumentSnapshot snap =
                                        await FirebaseFirestore.instance
                                            .doc("referal/$refBy")
                                            .get();
                                    if (snap.data() != null) {
                                      String refUid = snap.data()["uid"];
                                      print("$refUid $refName");
                                      setState(() {
                                        found = true;
                                        refName = snap.data()["name"];
                                        refPicUrl = snap.data()["image"];
                                        refUID = snap.data()["uid"];
                                        refAbt = snap.data()["aboutYou"];
                                      });
                                    } else {
                                      setState(() {
                                        found = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    Language(code: widget.language, text: [
                                      "Check ",
                                      "जाँच करे ",
                                      "করে চেক ",
                                      "கரே சரிபார்க்கவும் ",
                                      "కరే తనిఖీ చేయండి "
                                    ]).getText,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }

  func() async {}
}
