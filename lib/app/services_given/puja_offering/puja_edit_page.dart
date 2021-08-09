/*
import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/app/services_given/puja_offering/puja_class.dart';
import 'package:brahminapp/common_widgets/new_custom_multiple_search.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PujaEditTile extends StatefulWidget {
  final image;
  final name;
  final description;
  final price;
  final duration;
  final uid;
  final keyword;
  final type;
  final pjid;
  final bool edit;
  final String adDes;
  final String serviceIdL;
  final languageCode;
  final List<dynamic>? mainSamagriList;
  final List<dynamic>? samagri;

  const PujaEditTile(
      {Key? key,
      this.image,
      this.name,
      this.description,
      this.price,
      this.duration,
      this.pjid,
      this.samagri,
      this.mainSamagriList,
      this.languageCode,
      this.uid,
      this.keyword,
      this.type,
      required this.serviceIdL,
      required this.adDes,
      required this.edit})
      : super(key: key);

  @override
  _PujaEditTileState createState() => _PujaEditTileState();
}

class _PujaEditTileState extends State<PujaEditTile> {
  final _aFormKey = GlobalKey<FormState>();

  List<DropdownMenuItem> samagriItems = [];
  List<int> selectedSamagriIndex = [];
  Map<dynamic, dynamic> quantityList = {};
  List<Map<dynamic, dynamic>> selectedSamagriList = [];
  Map<dynamic, dynamic> quantityIdMap = {};
  String? _additionalDescription;
  bool editSam = false;
  String? _name;
  String? _description;
  String? _price;
  String? _duration;

  @override
  void initState() {
_price="${widget.price}";
    widget.samagri!.forEach((element) {
      quantityIdMap.addAll({"${element["id"]}": "${element["quantity"]}"});
    });


    for (int i = 0; i < widget.mainSamagriList!.length; i++) {
      samagriItems.add(DropdownMenuItem(
          value: "${widget.mainSamagriList![i]["name"][1]}",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${widget.mainSamagriList![i]["name"][1]}"),
            ],
          )));
    }
for (int i = 0; i < widget.samagri!.length; i++) {
  int? k = Samagri(
      listOfSamagri: widget.mainSamagriList,
      languageCode: widget.languageCode)
      .indexValue["${widget.samagri![i]["id"]}"];
  selectedSamagriIndex.add(k==null?0:k);
}
    super.initState();
  }

  _submit1() {
    if (_aFormKey.currentState!.validate()) {
      _aFormKey.currentState!.save();
      List<Map<dynamic, dynamic>> tempList = [];
      List<String> _sam1 = ["", "", "", "", ""];
      for (int i = 0; i < selectedSamagriIndex.length; i++) {
        _sam1[0] = _sam1[0] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][0]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        _sam1[1] = _sam1[1] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][1]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        _sam1[2] = _sam1[2] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][2]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        _sam1[3] = _sam1[3] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][3]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        _sam1[4] = _sam1[4] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][4]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        tempList.add({
          "id": "${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}",
          "quantity": quantityIdMap[
              "${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]
        });
      }
      try {
        final String serviceId = DateTime.now().toIso8601String();
        print(
            "\n\n\n\n\n\n >>>>>>>>>..${_sam1[0]} ${_sam1[1]} ${_sam1[2]} ${_sam1[3]}${_sam1[4]}");
        FireStoreDatabase(uid: widget.uid).setPujaOffering(data: {
          'puja': _name,
          'price': double.parse(_price!),
          'Benefit': _additionalDescription,
          'swastik': 0,
          'PanditD': _description,
          'Pujan Samagri': _sam1[0],
          'samagri1': [_sam1[0], _sam1[1], _sam1[2], _sam1[3], _sam1[4]],
          'samagri2': FieldValue.arrayUnion(tempList),
          'pjid': widget.pjid,
          'time': _duration,
          'keyword': widget.keyword,
          'subscriber': 0,
          'profit': 0.1,
          'serviceId': serviceId,
          'rates': 0,
          'np': double.parse(_price!) + 300,
          'reviews': 0,
          'image': widget.image,
          'type': widget.type,
          'offer': 'Physical'
        }, pid: serviceId).whenComplete(() {
          //new
          FirebaseFirestore.instance
              .doc("Avaliable_pundit/${widget.uid}/Category/${widget.type}")
              .set({'items': 0, 'name': widget.type, 'type': widget.type})
              .whenComplete(
                  () => FireStoreDatabase(uid: widget.uid).updateKeyword(
                        widget.keyword,
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
            text: Language(code: widget.languageCode, text: [
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
  }

  _submit2() {
    if (_aFormKey.currentState!.validate()) {
      _aFormKey.currentState!.save();
      List<Map<dynamic, dynamic>> tempList = [];
      List<String> _sam1 = ["", "", "", "", ""];
      for (int i = 0; i < (selectedSamagriIndex.length); i++) {
        _sam1[0] = _sam1[0] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][0]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        _sam1[1] = _sam1[1] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][1]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        _sam1[2] = _sam1[2] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][2]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        _sam1[3] = _sam1[3] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][3]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        _sam1[4] = _sam1[4] +
            "${widget.mainSamagriList![selectedSamagriIndex[i]]["name"][4]} -- ${quantityIdMap["${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]}" +
            ", ";
        tempList.add({
          "id": "${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}",
          "quantity": quantityIdMap[
              "${widget.mainSamagriList![selectedSamagriIndex[i]]["sid"]}"]
        });
      }
      try {
        // FireStoreDatabase(uid: widget.uid).updatePujaOffering(data: {
        //'samagri2': FieldValue.delete(),
        //}, pid: widget.serviceIdL).whenComplete(() {
        FireStoreDatabase(uid: widget.uid).updatePujaOffering(data: {
          'puja': _name,
          'price': double.parse(_price!),
          'Benefit': _additionalDescription,
          'PanditD': _description,
          'Pujan Samagri': _sam1[0],
          'samagri1': _sam1,
          'samagri2': tempList,
          'time': _duration,
          'serviceId': widget.serviceIdL,
          'np': double.parse(_price!) + 300,
        }, pid: widget.serviceIdL).whenComplete(() {
          BotToast.showText(
              text: Language(code: widget.languageCode, text: [
            "$_name is updated ",
            "$_name अपडेट किया गया है ",
            "$_name আপডেট হয়েছে ",
            "$_name புதுப்பிக்கப்பட்டது ",
            "$_name నవీకరించబడింది "
          ]).getText);
        });
        // });

      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height(double h) =>
        MagicScreen(height: h, context: context).getHeight;
    double width(double h) => MagicScreen(width: h, context: context).getWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                widget.edit ? _submit2() : _submit1();
                Navigator.of(context).pop();
              },
              child: Text(
                Language(code: widget.languageCode, text: [
                  "Save ",
                  "पूर्ण ",
                  "সম্পন্ন ",
                  "முடிந்தது ",
                  "పూర్తి "
                ]).getText,
                style: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _aFormKey,
          child: Container(
            // height: 100,
            padding: EdgeInsets.all(10),

            child: Column(
              children: [
                Image.network(
                  widget.image,
                  height: MagicScreen(context: context, height: height(250))
                      .getHeight,
                ),
                TextFormField(
                  cursorColor: Colors.deepOrange,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  initialValue: "${widget.name}",
                  onSaved: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : Language(code: widget.languageCode, text: [
                          "This field is required",
                          "यह फ़ील्ड आवश्यक है",
                          "ঘরটি অবশ্যই পূরণ করতে হবে",
                          "இந்த புலம் தேவை",
                          "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                        ]).getText,
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: height(20)),
                ),
                TextFormField(
                  //textAlign: TextAlign.center,
                  onSaved: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: "${widget.description}",
                  validator: (value) => value!.isNotEmpty
                      ? null
                      : Language(code: widget.languageCode, text: [
                          "This field is required",
                          "यह फ़ील्ड आवश्यक है",
                          "ঘরটি অবশ্যই পূরণ করতে হবে",
                          "இந்த புலம் தேவை",
                          "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                        ]).getText,
                ),
                SizedBox(
                  height: height(20),
                ),
                DottedBorder(
                  color: Colors.black54,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              child: Text(
                                Language(text: [
                                  "Price",
                                  "मूल्य",
                                  "দাম",
                                  "மதிப்பு",
                                  "విలువ"
                                ], code: widget.languageCode)
                                    .getText,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            TextFormField(
                              autofocus: true,
                              initialValue: _price,
                              cursorColor: Colors.deepOrange,
                              keyboardType: TextInputType.numberWithOptions(
                                signed: false,
                                decimal: false,
                              ),
                              onSaved: (value) {
                                setState(() {
                                  _price = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              //maxLength: null,
                              showCursor: true,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                              validator: (value) => value!.isNotEmpty
                                  ? null
                                  : Language(code: widget.languageCode, text: [
                                      "This field is required",
                                      "यह फ़ील्ड आवश्यक है",
                                      "ঘরটি অবশ্যই পূরণ করতে হবে",
                                      "இந்த புலம் தேவை",
                                      "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                    ]).getText,
                            ),
                          ],
                        ),
                        height: height(70),
                        width: width(100),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              child: Text(
                                Language(text: [
                                  "Duration",
                                  "समयांतराल",
                                  "সময়কাল ",
                                  "காலம்",
                                  "వ్యవధి"
                                ], code: widget.languageCode)
                                    .getText,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            TextFormField(
                              initialValue: "${widget.duration}",
                              keyboardType: TextInputType.numberWithOptions(
                                signed: false,
                                decimal: false,
                              ),
                              onSaved: (value) {
                                setState(() {
                                  _duration = value;
                                });
                              },
                              cursorColor: Colors.deepOrange,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              //maxLength: null,
                              showCursor: true,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                              validator: (value) => value!.isNotEmpty
                                  ? null
                                  : Language(code: widget.languageCode, text: [
                                      "This field is required",
                                      "यह फ़ील्ड आवश्यक है",
                                      "ঘরটি অবশ্যই পূরণ করতে হবে",
                                      "இந்த புலம் தேவை",
                                      "ఈ ఖాళీని తప్పనిసరిగా పూరించవలెను"
                                    ]).getText,
                            ),
                          ],
                        ),
                        height: height(70),
                        width: width(100),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height(20),
                ),
                Text(
                  Language(code: widget.languageCode, text: [
                    "Puja samagri ",
                    "पूजा की सामग्री  ",
                    "পূজা উপাদান ",
                    "பூஜை பொருள் ",
                    "పూజా పదార్థం "
                  ]).getText,
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height(10),
                ),
                editSam
                    ? DottedBorder(
                        color: Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Language(code: widget.languageCode, text: [
                                      "Samagri ",
                                      "सामग्री  ",
                                      "উপাদান ",
                                      "பொருள் ",
                                      "పదార్థం "
                                    ]).getText,
                                  ),
                                  Text(Language(
                                      code: widget.languageCode,
                                      text: [
                                        "Quantity ",
                                        "मात्रा  ",
                                        "পরিমাণ ",
                                        "அளவு ",
                                        "పరిమాణం "
                                      ]).getText)
                                ],
                              ),
                              SizedBox(
                                height: height(10),
                              ),
                              Container(
                                  height: height(250),
                                  child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: height(5),
                                          ),
                                      itemCount: selectedSamagriIndex.length,
                                      itemBuilder: (context, index) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${widget.mainSamagriList![selectedSamagriIndex[index]]["name"][1]}"),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors
                                                            .deepOrangeAccent,
                                                        width: 0.5,
                                                        style:
                                                            BorderStyle.solid)),
                                                height: height(50),
                                                width: width(100),
                                                child: TextFormField(
                                                  initialValue:
                                                      "${quantityIdMap["${widget.mainSamagriList![index]["sid"]}"] == null ? "" : quantityIdMap["${widget.mainSamagriList![index]["sid"]}"]}",
                                                  cursorColor:
                                                      Colors.deepOrange,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  maxLength: null,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  onChanged: (value) {
                                                    quantityIdMap[
                                                            "${widget.mainSamagriList![index]["sid"]}"] =
                                                        value;
                                                  },
                                                  //maxLength: null,
                                                  showCursor: true,
                                                  style: TextStyle(
                                                      fontSize: height(13)),
                                                ),
                                              )
                                            ],
                                          ))),
                              Container(
                                child: SingleChildScrollView(
                                  child: NewSearchChoices.multiple(
                                    isExpanded: true,
                                    displayClearIcon: false,
                                    underline: SizedBox(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSamagriIndex = value;
                                      });
                                    },
                                    autofocus: false,
                                    selectedItems: selectedSamagriIndex,
                                    closeButton: (selectedItems) {
                                      return (selectedItems.isNotEmpty
                                          ? "Save ${selectedItems.length == 1 ? '"' + samagriItems[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                                          : "Save without selection");
                                    },
                                    items: samagriItems,
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                                // height: 200,
                              ),
                            ],
                          ),
                        ))
                    : DottedBorder(
                        color: Colors.black54,
                        child: Container(
                          height: height(200),
                          child: ListView.builder(
                              itemCount: selectedSamagriIndex.length,
                              itemBuilder: (context, index) => Text(
                                  "${index + 1}-     ${widget.mainSamagriList![selectedSamagriIndex[index]]["name"][1]} ------ ${quantityIdMap["${widget.mainSamagriList![index]["sid"]}"] == null ? "" : quantityIdMap["${widget.mainSamagriList![index]["sid"]}"]} ")),
                        )),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          editSam = !editSam;
                        });
                      },
                      child: editSam
                          ? Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              Language(code: widget.languageCode, text: [
                                "Edit ",
                                "संपादित करें ",
                                "সম্পাদনা করুন ",
                                "தொகு ",
                                "సవరించండి "
                              ]).getText,
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold),
                            ),
                    )),
                SizedBox(
                  height: height(10),
                ),
                Text(
                  Language(code: widget.languageCode, text: [
                    "Any additional information? ",
                    "कोई अतिरिक्त जानकारी ? ",
                    "কোন অতিরিক্ত তথ্য? ",
                    "கூடுதல் தகவல் ஏதேனும் உள்ளதா? ",
                    "ఏదైనా అదనపు సమాచారం ఉందా? "
                  ]).getText,
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height(10),
                ),
                DottedBorder(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.deepOrange,
                      initialValue: widget.adDes,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSaved: (value) => _additionalDescription = value,
                    ),
                  ),
                ),
                SizedBox(
                  height: height(10),
                ),
                Text("${widget.pjid}"),
                SizedBox(
                  height: height(10),
                ),
                SizedBox(
                  height: height(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
