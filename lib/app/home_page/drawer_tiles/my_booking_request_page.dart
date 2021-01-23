import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'client_detail_page.dart';
import 'empty_content.dart';

class MyBookingRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserId>(
          stream: Auth().onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return StreamBuilder<QuerySnapshot>(
                stream:
                    FireStoreDatabase(uid: snapshot.data.uid).getBookingRequest,
                builder: (context, snapshot1) {
                  if (snapshot1.data == null) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot1.data.docs.isEmpty) {
                    return EmptyContent();
                  }

                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .doc(
                              'punditUsers/${snapshot.data.uid}/user_profile/user_data')
                          .snapshots(),
                      builder: (context, snapshot3) {
                        if (snapshot3.data == null) {
                          return CircularProgressIndicator();
                        }
                        final url = snapshot3.data.data()['profilePicUrl'];
                        return Scaffold(
                          appBar: AppBar(
                            toolbarHeight: 100,
                            iconTheme:
                                new IconThemeData(color: Colors.deepOrange),
                            backgroundColor: Colors.white,
                            elevation: 0,
                            title: Text(
                              'Booking request',
                              style: TextStyle(color: Colors.deepOrange),
                            ),
                            centerTitle: true,
                          ),
                          backgroundColor: Colors.grey[100],
                          body: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ListView.builder(
                                itemCount: snapshot1.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ref =
                                      snapshot1.data.docs[index];
                                  final String date = ref.data()['date'];
                                  final String time = ref.data()['time'];
                                  final String pic = ref.data()['pic'];
                                  final String service = ref.data()['service'];
                                  final String client = ref.data()['client'];
                                  final String tuid = ref.data()['clientuid'];
                                  final bool paid = ref.data()['payment'];
                                  final String location =
                                      ref.data()['Location'];
                                  final String serviceId =
                                      ref.data()['serviceId'];
                                  final bool accepted = ref.data()['request'];
                                  final bool cancel = ref.data()['cancel'];
                                  final String tid = ref.id;

                                  return Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      cancel
                                          ? Positioned(
                                              top: 20,
                                              child: Text(
                                                'Canceled by user',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                          : SizedBox(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 6),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Opacity(
                                              opacity: cancel ? 0.5 : 1,
                                              child: Row(
                                                children: <Widget>[
                                                  CircularProfileAvatar(
                                                    '',
                                                    child: Image.network(pic),
                                                    borderWidth: 1,
                                                    radius: 40,
                                                    borderColor:
                                                        Colors.deepOrange,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                            child:
                                                                ClientDetailPage(
                                                              cod: false,
                                                              bookingId: tid,
                                                              name: client,
                                                              service: service,
                                                              paid: paid,
                                                              pic: pic,
                                                              date: date,
                                                              time: time,
                                                              location:
                                                                  location,
                                                            ),
                                                            context: context);
                                                      },
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(client,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              maxLines: 3,
                                                              softWrap: true),
                                                          Text(service,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              maxLines: 3,
                                                              softWrap: true),
                                                          Text('$date $time',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black54),
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              maxLines: 3,
                                                              softWrap: true),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  cancel
                                                      ? SizedBox()
                                                      : accepted
                                                          ? Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              color: Colors.red,
                                                              child: Center(
                                                                child: Text(
                                                                  'Payment \n  is\n pending',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            )
                                                          : Column(
                                                              children: <
                                                                  Widget>[
                                                                FlatButton(
                                                                  child: Text(
                                                                    'Accept',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    FireStoreDatabase(uid: snapshot.data.uid).updateBooking(
                                                                        serviceId:
                                                                            serviceId,
                                                                        service:
                                                                            service,
                                                                        pPic:
                                                                            url,
                                                                        tuid:
                                                                            tuid,
                                                                        tid:
                                                                            tid,
                                                                        bookingAccepted:
                                                                            true);
                                                                    // print('$subscriber,$tuid');
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text(
                                                                    'Reject',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    FireStoreDatabase(uid: snapshot.data.uid).updateBooking(
                                                                        serviceId:
                                                                            serviceId,
                                                                        pPic:
                                                                            url,
                                                                        service:
                                                                            service,
                                                                        tuid:
                                                                            tuid,
                                                                        tid:
                                                                            tid,
                                                                        bookingAccepted:
                                                                            false);
                                                                  },
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
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        );
                      });
                });
          }),
    );
  }
}
