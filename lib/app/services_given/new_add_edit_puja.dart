import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/services_given/catagories.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../languages.dart';

List<Category> trendingPujaList = [];
List<String> trendingPujaNameList = [];

class NewAddAndEditPuja extends StatefulWidget {
  final uid;
  final DocumentSnapshot docSnap;
  final language;

  const NewAddAndEditPuja(
      {Key key, @required this.uid, @required this.docSnap, this.language})
      : super(key: key);

  @override
  _NewAddAndEditPujaState createState() => _NewAddAndEditPujaState();
}

class _NewAddAndEditPujaState extends State<NewAddAndEditPuja> {
  final _formKey = GlobalKey<FormState>();
  String puja = "Select puja";
  bool other = false;
  String _name;
  double _rate;
  String _benefits;
  String samagri;
  String _additionalDisctription;
  String _time;
  String hr;
  Map keymap = {};
  Map samMap = {};
  dynamic keyword;

  int index = 0;

  //String _serviceId=widget.database
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    try {
      final String serviceId = DateTime.now().toIso8601String();
      FireStoreDatabase(uid: widget.uid)
          .setPujaOffering(data: {
            'puja': _name,
            'price': _rate,
            'Benefit': _benefits,
            'swastik': 0,
            'PanditD': _additionalDisctription,
            'Pujan Samagri': samagri,
            'time': _time,
            'keyword': keyword == null ? '#' + _name + '/' : keyword,
            'subscriber': 0,
            'profit': 0.1,
            'serviceId': serviceId,
          }, pid: serviceId)
          .whenComplete(() => FireStoreDatabase(uid: widget.uid).updateKeyword(
                keyword == null ? '#' + _name + '/' : keyword,
              ))
          .whenComplete(() {
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
      }, pid: widget.docSnap.id);
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
/*    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }*/

    if (widget.docSnap != null) {
      _name = widget.docSnap.data()['puja'];
      _rate = widget.docSnap.data()['price'];
      _benefits = widget.docSnap.data()['Benefit'];
      samagri = widget.docSnap.data()['Pujan Samagri'];
      _additionalDisctription = widget.docSnap.data()['PanditD'];
      _time = widget.docSnap.data()['time'];
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: FlatButton(
                onPressed: () {
                  if (widget.docSnap == null) {
                    if (_validateAndSaveForm() && keyword != null) {
                      _submit();
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
                )),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: _buildContents()),
        ],
      ),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(8.0), child: _buildForm()),
    );
  }

  Widget _buildForm() {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: widget.uid).getTrendingList,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          trendingPujaNameList.clear();
          keymap.clear();

          snapshot.data.docs.forEach((element) {
            keymap.addAll({element.data()['name']: element.id});
            samMap.addAll({element.data()['name']: element.data()['Samagri']});
          });
          print(keymap);
          keymap.forEach((key, value) {
            trendingPujaNameList.add(key);
          });
          //trendingPujaNameList.add('Others');
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildFormChildren(),
            ),
          );
        });
  }

  List<Widget> _buildFormChildren() {
    return [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black54, width: 0.5, style: BorderStyle.solid),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
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
          validator: (value) => value.isNotEmpty
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
        height: MagicScreen(height: 5, context: context).getHeight,
      ),
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black54, width: 0.5, style: BorderStyle.solid),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
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
          validator: (value) => value.isNotEmpty
              ? null
              : Language(code: widget.language, text: [
                  "This field is required",
                  "यह फ़ील्ड आवश्यक है",
                  "ঘরটি অবশ্যই পূরণ করতে হবে",
                  "இந்த புலம் தேவை",
                  "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                ]).getText,
          onSaved: (value) => _rate = double.tryParse(value) ?? 0,
        ),
      ),
      SizedBox(
        height: MagicScreen(height: 5, context: context).getHeight,
      ),
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black54, width: 0.5, style: BorderStyle.solid),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
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
          validator: (value) => value.isNotEmpty
              ? null
              : Language(code: widget.language, text: [
                  "This field is required",
                  "यह फ़ील्ड आवश्यक है",
                  "ঘরটি অবশ্যই পূরণ করতে হবে",
                  "இந்த புலம் தேவை",
                  "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                ]).getText,
          onSaved: (value) => _time = value, // = int.tryParse(value) ?? 0,
        ),
      ),
      SizedBox(
        height: MagicScreen(height: 5, context: context).getHeight,
      ),
      other
          ? Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black54,
                    width: 0.5,
                    style: BorderStyle.solid),
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: Language(code: widget.language, text: [
                      "Puja samagri ",
                      "पूजा की सामग्री  ",
                      "পূজা উপাদান ",
                      "பூஜை பொருள் ",
                      "పూజా పదార్థం "
                    ]).getText),
                initialValue: samagri,
                validator: (value) => value.isNotEmpty
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
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black54, width: 0.5, style: BorderStyle.solid),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
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
        height: MagicScreen(height: 5, context: context).getHeight,
      ),
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black54, width: 0.5, style: BorderStyle.solid),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
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
        height: MagicScreen(height: 20, context: context).getHeight,
      ),
      widget.docSnap != null
          ? SizedBox()
          : Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.black54,
                      width: 0.5,
                      style: BorderStyle.solid)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Language(code: widget.language, text: [
                      "What type of puja is this? ",
                      "यह पूजा किस प्रकार की है ? ",
                      "এটি কোন ধরণের উপাসনা? ",
                      "இது என்ன வகையான வழிபாடு? ",
                      "ఇది ఏ రకమైన ఆరాధన? "
                    ]).getText,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(width: 25),
                  SearchableDropdown.single(
                    hint: Text(Language(code: widget.language, text: [
                      "Type of puja ",
                      "पूजा का प्रकार ",
                      "পূজা টাইপ ",
                      "பூஜை வகை ",
                      "పూజ రకం "
                    ]).getText),
                    isExpanded: true,
                    displayClearIcon: false,
                    items:
                        trendingPujaNameList.map((String dropDownStringItem) {
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
                            other = false;
                          });
                        }
                      });
                    },
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
        height: MagicScreen(height: 10, context: context).getHeight,
      ),
      widget.docSnap != null
          ? SizedBox()
          : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                      color: Colors.black54,
                      width: 0.5,
                      style: BorderStyle.solid)),
              padding: EdgeInsets.all(8),
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
        height: MagicScreen(height: 100, context: context).getHeight,
      ),
    ];
  }
}
