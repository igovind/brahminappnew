import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/services_given/catagories.dart';
import 'package:brahminapp/common_widgets/CustomSearchableDropdown.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../languages.dart';

List<Category> trendingPujaList = [];
List<String> trendingPujaNameList = [];
final _formKey = GlobalKey<FormState>();

class NewAddAndEditPuja extends StatefulWidget {
  final uid;
  final DocumentSnapshot? docSnap;
  final language;

  const NewAddAndEditPuja(
      {Key? key, @required this.uid, @required this.docSnap, this.language})
      : super(key: key);

  @override
  _NewAddAndEditPujaState createState() => _NewAddAndEditPujaState();
}

class _NewAddAndEditPujaState extends State<NewAddAndEditPuja> {
  String puja = "Select puja";
  String nameOfPuja = "";
  bool other = false;
  String? _name;
  double? _rate;
  double? _onlineRate;
  String? _benefits;
  String? samagri;
  String? _additionalDisctription;
  String? _time;
  String? hr;
  bool? online = false;
  Map keymap = {};
  Map samMap = {};
  Map imgMap = {};
  Map typeMap = {};
  dynamic keyword;

  int index = 0;

  //String _serviceId=widget.database
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    try {
      final String serviceId = DateTime.now().toIso8601String();
      FireStoreDatabase(uid: widget.uid).setPujaOffering(data: {
        'puja': _name,
        'price': _rate,
        'Benefit': _benefits,
        'swastik': 0,
        'PanditD': _additionalDisctription,
        'Pujan Samagri': samagri,
        'time': _time,
        'keyword': keyword == null ? '#' + _name! + '/' : keyword,
        'subscriber': 0,
        'profit': 0.1,
        'serviceId': serviceId,
        'rates': 0,
        'np': _rate! + 300,
        'reviews': 0,
        'image': imgMap[nameOfPuja],
        'type': typeMap[nameOfPuja],
        'offer': 'Physical'
      }, pid: serviceId).whenComplete(() {
        //new
        FirebaseFirestore.instance
            .doc(
                "Avaliable_pundit/${widget.uid}/Category/${typeMap[nameOfPuja]}")
            .set({
              'items': 0,
              'name': typeMap[nameOfPuja],
              'type': typeMap[nameOfPuja]
            })
            .whenComplete(
                () => FireStoreDatabase(uid: widget.uid).updateKeyword(
                      keyword == null ? '#' + _name! + '/' : keyword,
                    ))
            .whenComplete(() {
              FirebaseFirestore.instance
                  .doc(
                      "Avaliable_pundit/${widget.uid}/puja_offering/$serviceId/reviews/Samagri")
                  .set({
                'name': 'Samagri',
                'rate': 0,
                'raters': 0,
                'type': 'specific'
              }).whenComplete(() {
                FirebaseFirestore.instance
                    .doc(
                        "Avaliable_pundit/${widget.uid}/puja_offering/$serviceId/reviews/cost")
                    .set({
                  'name': 'Cost efficient',
                  'rate': 0,
                  'raters': 0,
                  'type': 'specific'
                }).whenComplete(() {
                  FirebaseFirestore.instance
                      .doc(
                          "Avaliable_pundit/${widget.uid}/puja_offering/$serviceId/reviews/satisfaction")
                      .set({
                    'name': 'Satisfaction',
                    'rate': 0,
                    'raters': 0,
                    'type': 'specific'
                  });
                });
              });
            })
            .whenComplete(() {
              FirebaseFirestore.instance
                  .doc(
                      "punditUsers/${widget.uid}/puja_offering/$serviceId/reviews/Samagri")
                  .set({
                'name': 'Samagri',
                'rate': 0,
                'raters': 0,
                'type': 'specific',
              }).whenComplete(() {
                FirebaseFirestore.instance
                    .doc(
                        "punditUsers/${widget.uid}/puja_offering/$serviceId/reviews/cost")
                    .set({
                  'name': 'Cost efficient',
                  'rate': 0,
                  'raters': 0,
                  'type': 'specific',
                }).whenComplete(() {
                  FirebaseFirestore.instance
                      .doc(
                          "punditUsers/${widget.uid}/puja_offering/$serviceId/reviews/satisfaction")
                      .set({
                    'name': 'Satisfaction',
                    'rate': 0,
                    'raters': 0,
                    'type': 'specific',
                  });
                });
              });
            });
      }).whenComplete(() {
        BotToast.showText(
          text: Language(code: widget.language, text: [
            "$_name Added in your puja service ",
            "$_name आपकी पूजा सेवा में जोड़ा गया ",
            "$_name আপনার পূজা পরিষেবায় যুক্ত হয়েছে ",
            "$_name உங்கள் பூஜை சேவையில் சேர்க்கப்பட்டது ",
            "$_name మీ పూజా సేవలో చేర్చబడింది "
          ]).getText,
        );
      });
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _submit2() async {
    try {
      final String serviceId = DateTime.now().toIso8601String() + "%";
      FireStoreDatabase(uid: widget.uid).setPujaOffering(data: {
        'puja': _name,
        'price': _onlineRate,
        'Benefit': _benefits,
        'swastik': 0,
        'onlinePrice': _onlineRate,
        'PanditD': _additionalDisctription,
        'Pujan Samagri': samagri,
        'time': _time,
        'keyword': keyword == null ? '#' + _name! + '/' : keyword,
        'subscriber': 0,
        'profit': 0.1,
        'serviceId': serviceId,
        'rates': 0,
        'np': _rate! + 300,
        'reviews': 0,
        'image': imgMap[nameOfPuja],
        'offer': 'Online',
        'type': typeMap[nameOfPuja]
      }, pid: serviceId).whenComplete(() {
        //new
        FirebaseFirestore.instance
            .doc(
                "Avaliable_pundit/${widget.uid}/Category/${typeMap[nameOfPuja]}")
            .set({
              'items': 0,
              'name': typeMap[nameOfPuja],
              'type': typeMap[nameOfPuja]
            })
            .whenComplete(
                () => FireStoreDatabase(uid: widget.uid).updateKeyword(
                      keyword == null ? '#' + _name! + '/' : keyword,
                    ))
            .whenComplete(() {
              FirebaseFirestore.instance
                  .doc(
                      "Avaliable_pundit/${widget.uid}/puja_offering/$serviceId/reviews/Samagri")
                  .set({
                'name': 'Samagri',
                'rate': 0,
                'raters': 0,
                'type': 'specific'
              }).whenComplete(() {
                FirebaseFirestore.instance
                    .doc(
                        "Avaliable_pundit/${widget.uid}/puja_offering/$serviceId/reviews/cost")
                    .set({
                  'name': 'Cost efficient',
                  'rate': 0,
                  'raters': 0,
                  'type': 'specific'
                }).whenComplete(() {
                  FirebaseFirestore.instance
                      .doc(
                          "Avaliable_pundit/${widget.uid}/puja_offering/$serviceId/reviews/satisfaction")
                      .set({
                    'name': 'Satisfaction',
                    'rate': 0,
                    'raters': 0,
                    'type': 'specific'
                  });
                });
              });
            })
            .whenComplete(() {
              FirebaseFirestore.instance
                  .doc(
                      "punditUsers/${widget.uid}/puja_offering/$serviceId/reviews/Samagri")
                  .set({
                'name': 'Samagri',
                'rate': 0,
                'raters': 0,
                'type': 'specific',
              }).whenComplete(() {
                FirebaseFirestore.instance
                    .doc(
                        "punditUsers/${widget.uid}/puja_offering/$serviceId/reviews/cost")
                    .set({
                  'name': 'Cost efficient',
                  'rate': 0,
                  'raters': 0,
                  'type': 'specific',
                }).whenComplete(() {
                  FirebaseFirestore.instance
                      .doc(
                          "punditUsers/${widget.uid}/puja_offering/$serviceId/reviews/satisfaction")
                      .set({
                    'name': 'Satisfaction',
                    'rate': 0,
                    'raters': 0,
                    'type': 'specific',
                  });
                });
              });
            });
      }).whenComplete(() {
        BotToast.showText(
          text: Language(code: widget.language, text: [
            "$_name Added in your puja service ",
            "$_name आपकी पूजा सेवा में जोड़ा गया ",
            "$_name আপনার পূজা পরিষেবায় যুক্ত হয়েছে ",
            "$_name உங்கள் பூஜை சேவையில் சேர்க்கப்பட்டது ",
            "$_name మీ పూజా సేవలో చేర్చబడింది "
          ]).getText,
        );
      });
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _submit1() async {
    try {
      FireStoreDatabase(uid: widget.uid).updatePujaOffering(data: {
        'puja': _name,
        'price': _rate,
        'Benefit': _benefits,
        'PanditD': _additionalDisctription,
        'time': _time,
        'np': _rate! + 300,
      }, pid: widget.docSnap!.id);
      BotToast.showText(
          text: Language(code: widget.language, text: [
        "$_name is updated ",
        "$_name अपडेट किया गया है ",
        "$_name আপডেট হয়েছে ",
        "$_name புதுப்பிக்கப்பட்டது ",
        "$_name నవీకరించబడింది "
      ]).getText);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  void initState() {
    samagri = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.docSnap != null) {
      _name = widget.docSnap!.get('puja');
      _rate = widget.docSnap!.get('price');
      _benefits = widget.docSnap!.get('Benefit');
      samagri = widget.docSnap!.get('Pujan Samagri');
      _additionalDisctription = widget.docSnap!.get('PanditD');
      _time = widget.docSnap!.get('time');
      _onlineRate = widget.docSnap!.get('onlinePrice');
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                if (widget.docSnap == null) {
                  if (_validateAndSaveForm() && keyword != null) {
                    _submit();
                    if (online!) {
                      _submit2();
                    }
                    Navigator.of(context).pop();
                  }
                  if (keyword == null) {
                    BotToast.showText(
                        text: Language(code: widget.language, text: [
                      "Please select puja type ",
                      "कृपया पूजा प्रकार चुनें ",
                      "পূজা টাইপ নির্বাচন করুন ",
                      "பூஜா வகையைத் தேர்ந்தெடுக்கவும் ",
                      "దయచేసి పూజా రకాన్ని ఎంచుకోండి "
                    ]).getText);
                  }
                } else {
                  if (_validateAndSaveForm()) {
                    Navigator.of(context).pop();
                    _submit1();
                  }
                }
              },
              child: Text(
                Language(code: widget.language, text: [
                  "Save ",
                  "पूर्ण ",
                  "সম্পন্ন ",
                  "முடிந்தது ",
                  "పూర్తి "
                ]).getText,
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        blurRadius: 1,
                      )
                    ]),
              ))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FireStoreDatabase(uid: widget.uid).getTrendingList,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            trendingPujaNameList.clear();
            keymap.clear();
            snapshot.data!.docs.forEach((element) {
              keymap.addAll({element.get('name'): element.id});
              samMap.addAll({element.get('name'): element.get('Samagri')});
              imgMap.addAll({element.get('name'): element.get('image')});
              typeMap.addAll({element.get('name'): element.get('type')});
            });
            print(keymap);
            keymap.forEach((key, value) {
              trendingPujaNameList.add(key);
            });
            //trendingPujaNameList.add('Others');
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomContainer(
                      radius: 10,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: Language(code: widget.language, text: [
                            "Name of puja ",
                            "पूजा का नाम  ",
                            "নাম উপাসনা ",
                            "வழிபாட்டின் பெயர் ",
                            "ఆరాధన పేరు "
                          ]).getText,
                          border: InputBorder.none,
                        ),
                        initialValue: _name,
                        validator: (value) => value!.isNotEmpty
                            ? null
                            : Language(code: widget.language, text: [
                                "This field is required",
                                "यह फ़ील्ड आवश्यक है",
                                "ঘরটি অবশ্যই পূরণ করতে হবে",
                                "இந்த புலம் தேவை",
                                "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                              ]).getText,
                        onSaved: (value) => _name = value,
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 10, context: context).getHeight,
                    ),
                    CustomContainer(
                      radius: 10,
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: Language(code: widget.language, text: [
                              "Rate ",
                              "मूल्यांकन करें ",
                              "হার ",
                              "விகிதம் ",
                              "రేటు "
                            ]).getText,
                            prefixText: '₹'),
                        initialValue: _rate != null ? '$_rate' : '',
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        validator: (value) => value!.isNotEmpty
                            ? null
                            : Language(code: widget.language, text: [
                                "This field is required",
                                "यह फ़ील्ड आवश्यक है",
                                "ঘরটি অবশ্যই পূরণ করতে হবে",
                                "இந்த புலம் தேவை",
                                "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                              ]).getText,
                        onSaved: (value) =>
                            _rate = double.tryParse(value!) ?? 0,
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 10, context: context).getHeight,
                    ),
                    CustomContainer(
                      radius: 10,
                      child: TextFormField(
                        initialValue: _time,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: Language(code: widget.language, text: [
                              "How long will Puja last? ",
                              "पूजा कितने देर चलेगी ? ",
                              "পূজা আর কতক্ষণ চলবে? ",
                              "பூஜை எவ்வளவு காலம் நீடிக்கும்? ",
                              "పూజ ఎంతకాలం ఉంటుంది? "
                            ]).getText),
                        validator: (value) => value!.isNotEmpty
                            ? null
                            : Language(code: widget.language, text: [
                                "This field is required",
                                "यह फ़ील्ड आवश्यक है",
                                "ঘরটি অবশ্যই পূরণ করতে হবে",
                                "இந்த புலம் தேவை",
                                "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                              ]).getText,
                        onSaved: (value) =>
                            _time = value, // = int.tryParse(value) ?? 0,
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 10, context: context).getHeight,
                    ),
                    other
                        ? CustomContainer(
                            radius: 10,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText:
                                      Language(code: widget.language, text: [
                                    "Puja samagri ",
                                    "पूजा की सामग्री  ",
                                    "পূজা উপাদান ",
                                    "பூஜை பொருள் ",
                                    "పూజా పదార్థం "
                                  ]).getText),
                              initialValue: samagri,
                              validator: (value) => value!.isNotEmpty
                                  ? null
                                  : Language(code: widget.language, text: [
                                      "This field is required",
                                      "यह फ़ील्ड आवश्यक है",
                                      "ঘরটি অবশ্যই পূরণ করতে হবে",
                                      "இந்த புலம் தேவை",
                                      "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                    ]).getText,
                              onSaved: (value) => samagri = value,
                            ),
                          )
                        : SizedBox(),
                    CustomContainer(
                      radius: 10,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: Language(code: widget.language, text: [
                              "What are the benefits of doing this pooja? ",
                              "ये पूजा करने के क्या लाभ है?",
                              "এই পুজো করার সুবিধা কী? ",
                              "இந்த பூஜை செய்வதன் நன்மைகள் என்ன? ",
                              "ఈ పూజ చేయడం వల్ల కలిగే ప్రయోజనాలు ఏమిటి? "
                            ]).getText),
                        initialValue: _benefits,
                        onSaved: (value) => _benefits = value,
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 10, context: context).getHeight,
                    ),
                    CustomContainer(
                      radius: 10,
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: Language(code: widget.language, text: [
                              "Any additional information? ",
                              "कोई अतिरिक्त जानकारी ? ",
                              "কোন অতিরিক্ত তথ্য? ",
                              "கூடுதல் தகவல் ஏதேனும் உள்ளதா? ",
                              "ఏదైనా అదనపు సమాచారం ఉందా? "
                            ]).getText),
                        initialValue: _additionalDisctription,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onSaved: (value) => _additionalDisctription = value,
                      ),
                    ),
                    SizedBox(
                      height:
                          MagicScreen(height: 10, context: context).getHeight,
                    ),
                    widget.docSnap != null
                        ? SizedBox()
                        : CustomContainer(
                            radius: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SearchChoices.single(
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  underline: SizedBox(),
                                  label: Language(code: widget.language, text: [
                                    "What type of puja is this? ",
                                    "यह पूजा किस प्रकार की है ? ",
                                    "এটি কোন ধরণের উপাসনা? ",
                                    "இது என்ன வகையான வழிபாடு? ",
                                    "ఇది ఏ రకమైన ఆరాధన? "
                                  ]).getText,
                                  value: nameOfPuja,
                                  hint: Text(Language(
                                      code: widget.language,
                                      text: [
                                        "Type of puja ",
                                        "पूजा का प्रकार ",
                                        "পূজা টাইপ ",
                                        "பூஜை வகை ",
                                        "పూజ రకం "
                                      ]).getText),
                                  isExpanded: true,
                                  displayClearIcon: false,
                                  items: trendingPujaNameList
                                      .map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem),
                                    );
                                  }).toList(),
                                  onChanged: (String value) {
                                    setState(() {
                                      puja = value;
                                      if (value == "Others") {
                                        setState(() {
                                          other = true;
                                        });
                                      } else {
                                        setState(() {
                                          samagri = samMap[value];
                                          keyword = keymap[value];
                                          nameOfPuja = value;
                                          other = false;
                                        });
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  Language(code: widget.language, text: [
                                    "*Select this field very carefully as this field will decide pujan samagri* ",
                                    "* इस क्षेत्र का चयन बहुत सावधानी से करें क्योंकि यह क्षेत्र पूजा सामग्री तय करेगा * ",
                                    "* এই পিএলটি খুব গাড়ি চালিতভাবে নির্বাচন করুন এই পিএলভি ভিলা দেশি ভূজন সমাক্রি হিসাবে * ",
                                    "* இந்த புலம் வழிபாட்டுப் பொருட்களைத் தீர்மானிக்கும் என்பதால் இந்த துறையை மிகவும் கவனமாகத் தேர்ந்தெடுக்கவும் * ",
                                    "* ఈ పిఎల్‌టిని ఈ పిఎల్‌వి విల్లా దేశీతే భుజన్ సమాక్రీగా చాలా సరళంగా ఎంచుకోండి * "
                                  ]).getText,
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Language(code: widget.language, text: [
                                    "If the puja service you are adding is in this list or matches it, then please select it! If not, select \"Other\" ",
                                    "आप जो पूजा सेवा जोड़  रहे है अगर वो इस सूची में है या उससे मेल खाता है तो कृपया उसे सेलेक्ट करे! अगर नहीं है तो \"Other\" सेलेक्ट कीजिये  ",
                                    "আপনি যে পূজা সেবাটি যুক্ত করছেন তা যদি এই তালিকায় থাকে বা এটির সাথে মেলে, তবে দয়া করে এটি নির্বাচন করুন! যদি তা না হয় তবে \"Other\" নির্বাচন করুন ",
                                    "நீங்கள் சேர்க்கும் வழிபாட்டு சேவை இந்த பட்டியலில் இருந்தால் அல்லது பொருந்தினால், தயவுசெய்து அதைத் தேர்ந்தெடுக்கவும்! இல்லையென்றால், \"Other\" என்பதைத் தேர்ந்தெடுக்கவும் ",
                                    "మీరు జోడించే ఆరాధన సేవ ఈ జాబితాలో ఉంటే లేదా దానికి సరిపోలితే, దయచేసి దాన్ని ఎంచుకోండి! కాకపోతే, \"Other\" ఎంచుకోండి "
                                  ]).getText,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height:
                          MagicScreen(height: 10, context: context).getHeight,
                    ),
                    widget.docSnap != null
                        ? SizedBox()
                        : CustomContainer(
                            radius: 10,
                            child: Column(
                              children: [
                                Text(Language(code: widget.language, text: [
                                  "Samagri ",
                                  "सामग्री  ",
                                  "উপাদান ",
                                  "பொருள் ",
                                  "పదార్థం "
                                ]).getText),
                                keyword == null
                                    ? SizedBox()
                                    : TextFormField(
                                        key: Key(samagri.toString()),
                                        initialValue: samagri,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        onSaved: (value) => samagri = value,
                                      ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height:
                          MagicScreen(height: 50, context: context).getHeight,
                    ),
                    CustomContainer(
                      radius: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Language(code: widget.language, text: [
                              "Can this puja be done online? ",
                              "क्या ये पूजा ऑनलाइन की जा सकती हैं ? ",
                              "এই পুজো কি অনলাইনে করা যায়?",
                              "இந்த பூஜையை ஆன்லைனில் செய்ய முடியுமா?",
                              "ఈ పూజను ఆన్‌లైన్‌లో చేయవచ్చా?"
                            ]).getText,
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      online = true;
                                    });
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      online = false;
                                    });
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: MagicScreen(height: 10, context: context)
                                .getHeight,
                          ),
                          !online!
                              ? SizedBox()
                              : CustomContainer(
                                  radius: 10,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: Language(
                                                code: widget.language,
                                                text: [
                                                  "Rate ",
                                                  "ऑनलाइन रेट मूल्यांकन करें ",
                                                  "অনলাইন রেট",
                                                  "ஆன்லைன் வீதம்",
                                                  "ఆన్‌లైన్ రేటు "
                                                ]).getText,
                                            prefixText: '₹'),
                                        initialValue: _onlineRate != null
                                            ? '$_onlineRate'
                                            : '',
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                          signed: false,
                                          decimal: false,
                                        ),
                                        validator: (value) => value!.isNotEmpty
                                            ? null
                                            : Language(
                                                code: widget.language,
                                                text: [
                                                    "This field is required",
                                                    "यह फ़ील्ड आवश्यक है",
                                                    "ঘরটি অবশ্যই পূরণ করতে হবে",
                                                    "இந்த புலம் தேவை",
                                                    "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                                  ]).getText,
                                        onSaved: (value) => _onlineRate =
                                            double.tryParse(value!) ?? 0,
                                      ),
                                      Text(
                                        Language(code: widget.language, text: [
                                          "If this worship can be done online then write its price.",
                                          "यदि ये पूजा ऑनलाइन हो सकती हो तोह उसका दाम लिखें ",
                                          "যদি এই পূজাটি অনলাইনে করা যায় তবে তার দাম লিখুন।",
                                          "இந்த வழிபாட்டை ஆன்லைனில் செய்ய முடிந்தால் அதன் விலையை எழுதுங்கள்.",
                                          "ఈ ఆరాధన ఆన్‌లైన్‌లో చేయగలిగితే దాని ధర రాయండి. "
                                        ]).getText,
                                      )
                                    ],
                                  )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
