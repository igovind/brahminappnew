import 'package:brahminapp/app/home/menu/dashboard/pichart.dart';
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
                        Image.asset(
                          "images/empty_dashboard.png",
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width * 0.6,
                        ),
                        Text(
                          "Data not available",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '*Add your 5 puja to use this feature',
                          style: TextStyle(color: Colors.redAccent),
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