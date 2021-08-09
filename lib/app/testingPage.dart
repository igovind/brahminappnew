import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("hello");
    return Scaffold(
      appBar: AppBar(
        title: Text("Master"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .doc("inventories/listed_samagri")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            List<dynamic> list=snapshot.data!.get("samagri");
            return Center(
                child: ElevatedButton(
              onPressed: () {
             /*   for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  String uid = snapshot.data!.docs[i].id;
                  FirebaseFirestore.instance
                      .doc("punditUsers/$uid/user_profile/user_data")
                      .update({
                   // 'ready':true
*//*                    'lang': 'English',
                    'langCode': 'ENG',
                    'coins': 0,
                    "dateOfProfileUpdate":
                        FieldValue.arrayUnion([DateTime.now()]),
                    "dateOfProfileCreation": FieldValue.serverTimestamp(),*//*
                  });
                }
                //print("Hello ${snapshot.data!.docs[i].id} $i");*/

                print("hello");
                FirebaseFirestore.instance.doc("inventories/listed_puja").update(
                    {"listed_samagri":FieldValue.arrayUnion(list)});
              },
              child: Text("press"),
            ));
          }),
    );
  }
}
