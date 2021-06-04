import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class TestingPage extends StatelessWidget {
  final uid;

  const TestingPage({Key? key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("punditUsers/03xFw11ALsUQzuC6fTWUjVddhQw2/puja_offering")
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
                      child: ElevatedButton(
                    onPressed: () async {

                    },
                    child: Text("press"),
                  ));
                });
          }),
    );
  }
}
