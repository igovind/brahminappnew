import 'package:brahminapp/app/create_profile/edit_bank_details.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BankDetailsPage extends StatelessWidget {
  final uid;

  const BankDetailsPage({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    /* double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }*/

    String name;
    String bankName;
    // ignore: non_constant_identifier_names
    String IFSC;
    String accountNumber;
    return StreamBuilder<DocumentSnapshot>(
        stream: FireStoreDatabase(uid: uid).getBankDetails,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.data() == null) {
            return EditBankDetails(uid: uid);
          }

          if (snapshot.data.data() != null) {
            name = snapshot.data.data()['name'];
            bankName = snapshot.data.data()['bankName'];
            IFSC = snapshot.data.data()['IFSC'];
            accountNumber = snapshot.data.data()['accountNumber'];
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              toolbarHeight: height(30),
              /*  title: Text(
                'Bank details',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),*/
              actions: [
                FlatButton(
                  onPressed: () {
                    showMaterialModalBottomSheet(
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
                      'Edit',
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
                              children: [Text('Name'), Text("$name")],
                            ),
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text('Bank name'), Text("$bankName")],
                            ),
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Account number'),
                                Text('$accountNumber'),
                              ],
                            ),
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text('IFSC Code'), Text("$IFSC")],
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
