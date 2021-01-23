import 'package:brahminapp/app/home_page/tab_bar/dashboard/pichart.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelClass extends StatelessWidget {
  final uid;

  const ModelClass({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FireStoreDatabase(uid: uid).getOrderdPujaOfferingListBySubscriber,
        builder: (context, subscriberSnapshot) {
          if (subscriberSnapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder<QuerySnapshot>(
              stream:
                  FireStoreDatabase(uid: uid).getOrderdPujaOfferingListByProfit,
              builder: (context, profitSnapshot) {
                if (profitSnapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (profitSnapshot.data.docs.length < 5 ||
                    profitSnapshot.data.docs.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Icon(
                          Icons.not_interested,
                          color: Colors.black54,
                          size: 100,
                        ),
                        Expanded(
                          child: Text(
                            'You are not applicable for this feature please add at least 5 puja',
                            style: TextStyle(color: Colors.black54, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Statistic(
                  profitSnapshot: profitSnapshot,
                  subscriberSnapshot: subscriberSnapshot,
                  uid: uid,
                );
              });
        });
  }
}
