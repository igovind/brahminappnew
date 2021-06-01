import 'package:brahminapp/app/create_profile/edit_bank_details.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../languages.dart';

class BankDetailsPage extends StatelessWidget {
  final uid;
  final language;

  const BankDetailsPage({Key? key, required this.uid, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    String? name;
    String? bankName;
    // ignore: non_constant_identifier_names
    String? IFSC;
    String? accountNumber;
    return StreamBuilder<DocumentSnapshot>(
        stream: FireStoreDatabase(uid: uid).getBankDetails,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.data() == null) {
            return EditBankDetails(uid: uid,language: language,);
          }

          if (snapshot.data!.data() != null) {
            name = snapshot.data!.get('name');
            bankName = snapshot.data!.get('bankName');
            IFSC = snapshot.data!.get('IFSC');
            accountNumber = snapshot.data!.get('accountNumber');
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              /*  title: Text(
                'Bank details',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),*/
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditBankDetails(
                      uid: uid,
                      name: name,
                      bankName: bankName,
                      ifscCode: IFSC,
                      accountNumber: accountNumber,
                      language: language,
                    ),));
                    showModalBottomSheet(
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
                          height: height(600),
                          child: EditBankDetails(
                            uid: uid,
                            name: name,
                            bankName: bankName,
                            ifscCode: IFSC,
                            accountNumber: accountNumber,
                            language: language,
                          ),
                        );
                      },
                    );
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
                      Language(code: language, text: [
                        "Edit ",
                        "संपादित करें ",
                        "সম্পাদনা করুন ",
                        "தொகு ",
                        "సవరించండి "
                      ]).getText,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: snapshot.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomContainer(
                        radius: 10,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height(10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Language(code: language, text: [
                                  "Name ",
                                  "नाम ",
                                  "নাম ",
                                  "பெயர் ",
                                  "పేరు "
                                ]).getText),
                                Text("$name")
                              ],
                            ),
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Language(code: language, text: [
                                  "Name of Bank ",
                                  "बैंक का नाम ",
                                  "ব্যাংকের নাম ",
                                  "வங்கியின் பெயர் ",
                                  "బ్యాంక్ పేరు "
                                ]).getText),
                                Text("$bankName")
                              ],
                            ),
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Language(code: language, text: [
                                  "Account number ",
                                  "खाता संख्या ",
                                  "হিসাব নাম্বার ",
                                  "கணக்கு எண் ",
                                  "ఖాతా సంఖ్య "
                                ]).getText),
                                Text('$accountNumber'),
                              ],
                            ),
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Language(code: language, text: [
                                  "IFSC Code ",
                                  "IFSC कोड ",
                                  "IFSC কোড ",
                                  "IFSC குறியீடு ",
                                  "IFSC కోడ్ "
                                ]).getText),
                                Text("$IFSC")
                              ],
                            )
                          ],
                        ),
                      ),
              ),
            ),
          );
        });
  }
}

/*String getAcc(String string) {
  int i;
  */ /*for (i = 0; i < string.length - 4; i++) {
    string[i]=''
  }*/ /*
  string.replaceRange(0, 5, "X");
  print(string);
  return string;
}*/
