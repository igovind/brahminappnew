import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestingPage extends StatelessWidget {
  final uid;

  const TestingPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Avaliable_pundit")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            }
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .doc("inventories/Folder")
                    .snapshots(),
                builder: (context, snapshotA) {
                  if (snapshotA.data == null) {
                    return CircularProgressIndicator();
                  }
                  return Center(
                      child: FlatButton(
                    onPressed: () async {
                      print("hii ${snapshot.data.size}");
                      for (int i = 0; i < snapshot.data.size; i++) {
                        String uid = snapshot.data.docs[i].id;
                        String refralCode = "G" + (100 + i).toString();
                        String punditId =
                            "RK${DateTime.now().year}${100 + i}${DateTime.now().month}${DateTime.now().day}";
                        FirebaseFirestore.instance
                            .collection("referal")
                            .doc(refralCode)
                            .set({
                          "uid": uid,
                          "name": snapshot.data.docs[i].data()["firstName"],
                          "image":
                              snapshot.data.docs[i].data()["profilePicUrl"],
                          "token": snapshot.data.docs[i].data()["token"],
                          "punditID": punditId
                        });
                        FirebaseFirestore.instance
                            .doc("punditUsers/$uid/user_profile/user_data")
                            .update({
                          "refCode": refralCode,
                          "punditID": punditId,
                        });
                        FirebaseFirestore.instance
                            .doc("Avaliable_pundit/$uid")
                            .update({
                          "refCode": refralCode,
                          "punditID": punditId,
                        });
                      }
                      /* String code =
                          snapshotA.data.data()["available_code"].toString();
                      FireStoreDatabase(uid: null).setAvailableCode();
                      print("MMMMMM $code");*/
                    },
                    child: Text("press"),
                  ));
                });
          }),
    );
  }
}