import 'package:brahminapp/app/account/edit_adhaar_details.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AdhaarDetailsPage extends StatelessWidget {
  final uid;

  const AdhaarDetailsPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name;
    String address;
    String adhaarNumber;
    String front;
    String back;
    return StreamBuilder<DocumentSnapshot>(
        stream: FireStoreDatabase(uid: uid).getAdhaarDetails,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.data() == null) {
            return EditAdhaarDetails(
              uid: uid,
            );
          } else {
            name = snapshot.data.data()["name"];
            address = snapshot.data.data()["address"];
            adhaarNumber = snapshot.data.data()["adhaarNumber"];
            front = snapshot.data.data()["frontAdhaarPicUrl"];
            back = snapshot.data.data()["backAdhaarPicUrl"];
          }
          return Scaffold(
              appBar: AppBar(
                toolbarHeight: 40,
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  FlatButton(
                    onPressed: () {
                      showMaterialModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              height: MagicScreen(height: 700, context: context)
                                  .height,
                              child: EditAdhaarDetails(
                                adhaarName: name,
                                adhaarNumber: adhaarNumber,
                                frontAdhaarUrl: front,
                                backAdhaarUrl: back,
                                address: address,
                                uid: uid,
                              ));
                        },
                      );
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
                        "Edit",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              body: CustomContainer(
                  radius: 10,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MagicScreen(width: 145, context: context)
                                .getWidth,
                            height: MagicScreen(height: 115, context: context)
                                .getHeight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54, blurRadius: 4)
                                ],
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(front ??
                                        "https://5.imimg.com/data5/UF/GX/GLADMIN-63025529/adhar-card-service-500x500.png"))),
                          ),
                          SizedBox(
                            width: MagicScreen(width: 20,context: context).getWidth,
                          ),
                          Container(
                            width: MagicScreen(width: 150, context: context)
                                .getWidth,
                            height: MagicScreen(height: 120, context: context)
                                .getHeight,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54, blurRadius: 4)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(back ??
                                        "https://5.imimg.com/data5/UF/GX/GLADMIN-63025529/adhar-card-service-500x500.png"))),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MagicScreen(height: 10,context: context).getHeight,
                      ),
                      Text(
                        "$name",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$adhaarNumber",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on),
                          Text(
                            "$address",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )));
        });
  }
}
