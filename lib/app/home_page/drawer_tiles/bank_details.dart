import 'package:brahminapp/app/home_page/drawer_tiles/edit_bank_details.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BankDetailsPage extends StatelessWidget {
  final uid;

  const BankDetailsPage({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

          name = snapshot.data.data()['name'];
          bankName = snapshot.data.data()['bankName'];
          IFSC = snapshot.data.data()['IFSC'];
          accountNumber = snapshot.data.data()['accountNumber'];
          return Scaffold(
            backgroundColor: Colors.deepOrange[50],
            appBar: AppBar(
              toolbarHeight: 100,
              title: Text('Bank details'),
              actions: [
                FlatButton(
                    onPressed: () => showDialog(
                        context: context,
                        child: EditBankDetails(
                          uid: uid,
                          name: name,
                          bankName: bankName,
                          ifscCode: IFSC,
                          accountNumber: accountNumber,
                        )),
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(14),
              child: Container(
                padding: EdgeInsets.all(8),
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black54,
                        width: 2,
                        style: BorderStyle.solid)),
                child: snapshot.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Name'), Text(name)],
                          ),
                          Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Bank name'), Text(bankName)],
                          ),
                          Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Account number'),
                              Text(
                                  '${accountNumber.replaceRange(0, accountNumber.length - 4, 'X')}'),
                            ],
                          ),
                          Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('IFSC Code'), Text(IFSC)],
                          )
                        ],
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
