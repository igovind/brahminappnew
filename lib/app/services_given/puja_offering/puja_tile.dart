import 'package:brahminapp/app/services_given/puja_offering/x_puja_edit_page.dart';
import 'package:brahminapp/services/media_querry.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../languages.dart';

class PujaTile extends StatelessWidget {
  final image;
  final name;
  final description;
  final price;
  final duration;
  final pjid;
  final languageCode;
  final uid;
  final keyword;
  final type;
  final mainSamagriList;
  final List<dynamic>? samagri;

  const PujaTile(
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
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double h) =>
        MagicScreen(height: h, context: context).getHeight;
    return Container(
      // height: 100,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        //HexColor("#F9F9D7"),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 3)],
        borderRadius: BorderRadius.circular(10),
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
        /*  border: Border.all(
              style: BorderStyle.solid,
              color: Colors.deepOrangeAccent,
              width: 0.5)*/
      ),
      child: Column(
        children: [
          Image.network(
            image,
            height: height(150),
          ),
          Text(
            "$name",
            style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: height(20)),
          ),
          Text(
            "$description",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: height(20),
          ),
          DottedBorder(
            color: Colors.black54,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      Language(text: [
                        "Price",
                        "मूल्य",
                        "দাম",
                        "மதிப்பு",
                        "విలువ"
                      ], code: languageCode)
                          .getText,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$price₹",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      Language(text: [
                        "Duration",
                        "समयांतराल",
                        "সময়কাল ",
                        "காலம்",
                        "వ్యవధి"
                      ], code: languageCode)
                          .getText,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$duration",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: height(10),
          ),
          Text("ID $pjid"),
          SizedBox(
            height: height(10),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PujaEditTile(
                      languageCode: languageCode,
                      uid: uid,
                      edit: false,
                      keyword: keyword,
                      type: type,
                      mainSamagriList: mainSamagriList,
                      samagri: samagri,
                      name: name,
                      description: description,
                      image: image,
                      duration: duration,
                      pjid: pjid,
                      adDes: "",
                      price: "2000",
                      serviceIdL: '',
                    ))),
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 2)
                    ]),
                child: Text(
                  Language(text: [
                    "Add this puja",
                    "इस पूजा को जोड़ें",
                    "এই পূজা যোগ করুন",
                    "இந்த பூஜையைச் சேர்க்கவும்",
                    "ఈ పూజను జోడించండి"
                  ], code: languageCode)
                      .getText,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          ),
          SizedBox(
            height: height(10),
          ),
        ],
      ),
    );
  }
}
