import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'client_detail_page.dart';

class HistoryPage extends StatelessWidget {
  final uid;

  const HistoryPage({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('History'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: uid).getHistory,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot ref = snapshot.data.docs[index];
                  final String date = ref.data()['date'];
                  final String time = ref.data()['time'];
                  final String pic = ref.data()['pic'];
                  final String service = ref.data()['service'];
                  final String client = ref.data()['client'];
                  final String location = ref.data()['Location'];
                  final bool paid = ref.data()['payment'];
                  dynamic cod = ref.data()['cod'];
                  final String serviceId = ref.id;
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              child: ClientDetailPage(
                                name: client,
                                service: service,
                                location: location,
                                date: date,
                                time: time,
                                pic: pic,
                                paid: paid,
                                cod: cod,
                                bookingId: serviceId,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CircularProfileAvatar(
                                '',
                                child: Image.network(pic),
                                borderWidth: 1,
                                radius: 45,
                                borderColor: Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(client),
                                  Text(service),
                                  Text('$date  $time',softWrap: false,overflow:TextOverflow.ellipsis),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    color: cod != null && cod == true
                                        ? Colors.deepPurple
                                        : Colors.green,
                                    child: Text(
                                      cod != null && cod == true
                                          ? 'COH'
                                          : 'Paid',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
