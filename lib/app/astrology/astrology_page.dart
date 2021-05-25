import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import '../../common_widgets/custom_multi_select_file.dart';
import '../languages.dart';

class AstrologyPage extends StatefulWidget {
  final language;
  final uid;
  final AsyncSnapshot<DocumentSnapshot>? snapshot;

  const AstrologyPage({Key? key, this.snapshot, this.uid, this.language})
      : super(key: key);

  @override
  _AstrologyPageState createState() => _AstrologyPageState();
}

class _AstrologyPageState extends State<AstrologyPage> {
  String? messagePrice = "0";
  String? audioPrice = "0";
  String? videoPrice = "0";
  String? description = "";
  String? expertise = "";
  String? experience = "";
  String? languages = "";
  bool astrologer = false;
  final _formKeyNK = GlobalKey<FormState>();
  List<DropdownMenuItem> dropdownMenuItem = [
    DropdownMenuItem(
      child: Text("Rs/- 3", style: TextStyle(fontWeight: FontWeight.w700)),
      value: "3",
    ),
    DropdownMenuItem(
      child: Text("Rs/- 5", style: TextStyle(fontWeight: FontWeight.w700)),
      value: "5",
    ),
    DropdownMenuItem(
      child: Text(
        "Rs/- 7",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
      ),
      value: "7",
    ),
  ];

  List<DropdownMenuItem> items = [
    DropdownMenuItem(
      value: 1,
      child: Text('Hindi'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('English'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Kannada'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Malayalam'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Odia'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Punjabi'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Gujarati'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Urdu'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Tamil'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Telugu'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Marathi'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Bengali'),
    ),
  ];

  List<int> _selectedValues = [];

  @override
  void initState() {
    // TODO: implement initState
    messagePrice =
        widget.snapshot == null ? null : widget.snapshot!.data!.get("chat");
    audioPrice =
        widget.snapshot == null ? null : widget.snapshot!.data!.get("call");
    videoPrice =
        widget.snapshot == null ? null : widget.snapshot!.data!.get("video");
    description = widget.snapshot == null
        ? null
        : widget.snapshot!.data!.get("description");
    expertise = widget.snapshot == null
        ? null
        : widget.snapshot!.data!.get("expertise");
    experience = widget.snapshot == null
        ? null
        : widget.snapshot!.data!.get("experience").toString();
    languages =
        widget.snapshot == null ? "" : widget.snapshot!.data!.get("language");
    super.initState();
  }

  bool _validateAndSaveForm() {
    final form = _formKeyNK.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _submit() {
    if (_validateAndSaveForm() && _selectedValues.isNotEmpty) {
      String string = "";
      //TODO: multiple
      /*   for (int i = 0; i < _selectedValues.length; i++) {
        string = elements[i].content + "," + string;
      }*/
      FirebaseFirestore.instance
          .doc("punditUsers/${widget.uid}/user_profile/user_data")
          .update({
        "chat": messagePrice,
        "call": audioPrice,
        "video": videoPrice,
        "description": description,
        "expertise": expertise,
        "experience": experience,
        "astrologer": true,
        "language": string,
        "index": 2,
        'online': true,
        'chatOk': true,
        'callOk': true,
        'videoOk': true,
      }).whenComplete(() {
        FirebaseFirestore.instance
            .collection('Avaliable_pundit/${widget.uid}/astro')
            .doc('#astro')
            .set({
          'detail': description ?? 'Not Available',
          'name': 'Astrology',
          'offer': description ?? 'Not Available',
          'keyword': '#astro',
          'image':
              'https://assets.teenvogue.com/photos/5f31a0d6861f578bcc3baf40/16:9/w_2560%2Cc_limit/GettyImages-1192843057.jpg'
        });
        FirebaseFirestore.instance
            .doc("Avaliable_pundit/${widget.uid}")
            .update({
          "chat": messagePrice,
          "call": audioPrice,
          "video": videoPrice,
          "description": description,
          "expertise": expertise,
          "experience": experience,
          "astrologer": true,
          "language": string,
          "index": 2,
          'online': true,
          'chatOk': true,
          'callOk': true,
          'videoOk': true,
        });
        if (widget.snapshot != null) {
          Navigator.of(context).pop();
        }
      });
    } else {
      if (_selectedValues.isEmpty) {
        //TODO: botToast
        /* BotToast.showText(
          text: Language(code: widget.language, text: [
            "Please select your languages ",
            "कृपया अपनी भाषाओं का चयन करें ",
            "আপনার ভাষা নির্বাচন করুন ",
            "உங்கள் மொழிகளைத் தேர்ந்தெடுக்கவும் ",
            "దయచేసి మీ భాషలను ఎంచుకోండి "
          ]).getText,
        );*/
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> dropdownMenuItemExperience =
        List<DropdownMenuItem>.generate(
            80,
            (index) => DropdownMenuItem(
                  child: Text(
                    "${index + 2} " +
                        "${Language(code: widget.language, text: [
                              "Year ",
                              "साल ",
                              "বছর ",
                              "ஆண்டு ",
                              "సంవత్సరం "
                            ]).getText}",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  value: "${index + 2} Years",
                ));
    return astrologer
        ? Scaffold(
            appBar: AppBar(
              leading: widget.snapshot == null
                  ? IconButton(
                      icon: Icon(Icons.arrow_back_outlined),
                      onPressed: () {
                        setState(() {
                          astrologer = false;
                        });
                      })
                  : null,
              iconTheme: IconThemeData(color: Colors.black),
              toolbarHeight: 50,
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKeyNK,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomContainer(
                        radius: 10,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Language(code: widget.language, text: [
                                    "Price per 10 message ",
                                    "संदेश का मूल्य प्रति 10 संदेश ",
                                    "প্রতি 10 বার্তা বার্তার দাম",
                                    "10 செய்திக்கு செய்தி விலை ",
                                    "10 సందేశానికి సందేశ ధర"
                                  ]).getText,
                                ),
                                Container(
                                  width: 100,
                                  child: DropdownButtonFormField(
                                      validator: (dynamic value) {
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
                                      value: messagePrice,
                                      decoration: InputDecoration(
                                          enabledBorder: InputBorder.none),
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      style: TextStyle(color: Colors.green),
                                      //value: price,
                                      items: dropdownMenuItem,
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          messagePrice = value;
                                        });
                                      }),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Language(code: widget.language, text: [
                                    "Audio call price per minute ",
                                    "ऑडियो कॉल की कीमत प्रति मिनट ",
                                    "প্রতি মিনিটে অডিও কল মূল্য ",
                                    "நிமிடத்திற்கு ஆடியோ அழைப்பு விலை ",
                                    "నిమిషానికి ఆడియో కాల్ ధర "
                                  ]).getText,
                                ),
                                Container(
                                  width: 100,
                                  child: DropdownButtonFormField(
                                      validator: (dynamic value) {
                                        if (value == null) {
                                          Language(
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
                                      value: audioPrice,
                                      decoration: InputDecoration(
                                          enabledBorder: InputBorder.none),
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      style: TextStyle(color: Colors.green),
                                      //value: price,
                                      items: dropdownMenuItem,
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          audioPrice = value;
                                        });
                                      }),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Language(code: widget.language, text: [
                                    "Video call price per minute ",
                                    "वीडियो कॉल की कीमत प्रति मिनट ",
                                    "প্রতি মিনিটে ভিডিও কল মূল্য ",
                                    "நிமிடத்திற்கு வீடியோ அழைப்பு விலை ",
                                    "నిమిషానికి వీడియో కాల్ ధర "
                                  ]).getText,
                                ),
                                Container(
                                  width: 100,
                                  child: DropdownButtonFormField(
                                      validator: (dynamic value) {
                                        if (value == null) {
                                          Language(
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
                                      value: videoPrice,
                                      decoration: InputDecoration(
                                          enabledBorder: InputBorder.none),
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      style: TextStyle(color: Colors.green),
                                      //value: price,
                                      items: dropdownMenuItem,
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          videoPrice = value;
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomContainer(
                        radius: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Language(code: widget.language, text: [
                                "Year of experience ",
                                "अनुभव का वर्ष ",
                                "অভিজ্ঞতার বছর ",
                                "அனுபவ ஆண்டு ",
                                "అనుభవం సంవత్సరం "
                              ]).getText,
                            ),
                            Container(
                              width: 100,
                              child: DropdownButtonFormField(
                                  validator: (dynamic value) {
                                    if (value == null) {
                                      Language(code: widget.language, text: [
                                        "This field is required",
                                        "यह फ़ील्ड आवश्यक है",
                                        "ঘরটি অবশ্যই পূরণ করতে হবে",
                                        "இந்த புலம் தேவை",
                                        "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                      ]).getText;
                                    }
                                    return null;
                                  },
                                  value: experience,
                                  decoration: InputDecoration(
                                      enabledBorder: InputBorder.none),
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  style: TextStyle(color: Colors.green),
                                  //value: price,
                                  items: dropdownMenuItemExperience,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      experience = value;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomContainer(
                        radius: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Language(code: widget.language, text: [
                                "language ",
                                "भाषा ",
                                "ভাষা ",
                                "மொழி ",
                                "భాష "
                              ]).getText,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("$languages",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                            SearchChoices.multiple(
                              icon: Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                color: Colors.deepOrangeAccent,
                              ),
                              items: items,
                              underline: SizedBox(),
                              selectedItems: _selectedValues,
                              hint: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("Select any"),
                              ),
                              searchHint: "Select any",
                              onChanged: (value) {
                                setState(() {
                                  _selectedValues = value;
                                });
                              },
                              closeButton: (selectedItems) {
                                return (selectedItems.isNotEmpty
                                    ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                                    : "Save without selection");
                              },
                              isExpanded: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomContainer(
                          radius: 10,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: Language(code: widget.language, text: [
                                "Expertise ",
                                "विशेषज्ञता ",
                                "দক্ষতা ",
                                "நிபுணத்துவம் ",
                                "నైపుణ్యం "
                              ]).getText,
                            ),
                            initialValue: expertise,

                            onSaved: (value) {
                              setState(() {
                                expertise = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                Language(code: widget.language, text: [
                                  "This field is required",
                                  "यह फ़ील्ड आवश्यक है",
                                  "ঘরটি অবশ্যই পূরণ করতে হবে",
                                  "இந்த புலம் தேவை",
                                  "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                ]).getText;
                              }
                              return null;
                            }, //_benefits = value,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      CustomContainer(
                          radius: 10,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: Language(code: widget.language, text: [
                                "Additional description ",
                                "अतिरिक्त विवरण ",
                                "অতিরিক্ত বিবরণ ",
                                "கூடுதல் விளக்கம் ",
                                "అదనపు వివరణ "
                              ]).getText,
                            ),
                            initialValue: description,

                            onSaved: (value) {
                              setState(() {
                                description = value;
                              });
                            }, //_benefits = value,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      /*Row(
                  children: [
                    Text(
                      "Vastu shastra",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CustomContainer(
                  radius: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "At home",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomContainer(
                          radius: 10,
                          child: Column(
                            children: [
                              TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Rate per kilometer"),
                                  initialValue: "0",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                              TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Description"),
                                  initialValue: "this is description",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "On video call",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomContainer(
                          radius: 10,
                          child: Column(
                            children: [
                              TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Rate"),
                                  initialValue: "0",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                              TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Description"),
                                  initialValue: "this is description",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "With map",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomContainer(
                          radius: 10,
                          child: Column(
                            children: [
                              TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Rate"),
                                  initialValue: "0",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                              TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Description"),
                                  initialValue: "this is description",
                                  onSaved: (value) {} //_benefits = value,
                                  ),
                            ],
                          )),
                    ],
                  ),
                )*/
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Text(
                  Language(code: widget.language, text: [
                    "Are you a Astrologer? ",
                    "क्या आप एक ज्योतिषी हैं? ",
                    "আপনি কি একজন জ্যোতিষী? ",
                    "நீங்கள் ஒரு ஜோதிடரா? ",
                    "మీరు జ్యోతిష్కులా? "
                  ]).getText,
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        FireStoreDatabase(uid: widget.uid).updateData(data: {
                          'astrologer': true,
                        });
                        setState(() {
                          astrologer = true;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black54, blurRadius: 3)
                            ],
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          Language(code: widget.language, text: [
                            "Yes ",
                            "हाँ ",
                            "হ্যাঁ ",
                            "ஆம் ",
                            "हाँ "
                          ]).getText,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.snapshot != null) {
                          Navigator.of(context).pop();
                        }
                        FireStoreDatabase(uid: widget.uid).updateData(data: {
                          'astrologer': false,
                          'index': 2,
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black54, blurRadius: 3)
                            ],
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          Language(code: widget.language, text: [
                            "No ",
                            "नहीं ",
                            "না ",
                            "இல்லை ",
                            "కాదు "
                          ]).getText,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
