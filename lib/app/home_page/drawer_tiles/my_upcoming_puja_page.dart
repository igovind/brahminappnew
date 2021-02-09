import 'package:brahminapp/app/home_page/drawer_tiles/claim_reward.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/common_widgets/hexa_color.dart';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'client_detail_page.dart';
import 'empty_content.dart';

class Schedule extends StatelessWidget {
  final uid;

  const Schedule({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: uid).getUpComingPuja,
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
          return Scaffold(

            appBar: AppBar(
              
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'Upcoming puja',
                style: TextStyle(color: Color(0XFFffbd59)),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
              child: ListView.builder(
                  itemCount: snapshot1.data.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot ref =
                        snapshot1.data.docs[index];
                    final String date = ref.data()['date'];
                    final String time = ref.data()['time'];
                    final String pic = ref.data()['pic'];
                    final String service = ref.data()['service'];
                    final String client = ref.data()['client'];
                    final String location = ref.data()['Location'];
                    final String link = ref.data()['Link'];
                    final bool paid = ref.data()['payment'];
                    final String otp = ref.data()['otp'];
                    dynamic cod = ref.data()['cod'];
                    final bool samagri = ref.data()['samagri'];
                    final double samagriPrice = ref.data()['samagri_price'];
                    final String tuid = ref.data()['clientuid'];
                    final double net=ref.data()['benefit'];
                    final String serviceId = ref.id;
                    final String contact=ref.data()['contact'];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                                  link:link,
                                  date: date,
                                  time: time,
                                  pic: pic,
                                  paid: paid,
                                  cod: cod, bookingId: serviceId,
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
                                  borderColor: Color(0XFFffbd59),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(client),
                                    Text(service),
                                    Text('$date  $time'),
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
                                            ? 'COD'
                                            : 'Online',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Text('PH: $contact'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: CustomRaisedButton(
                                          child: Text(
                                            'Mark as done',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          color: HexColor("#540D6E"),
                                          borderRadius: 12,
                                          height: 30,
                                          onPressed: () => showDialog(
                                              context: context,
                                              child: ClaimReward(
                                                realOTP: otp,
                                                uid: uid,
                                                tuid: tuid,
                                                samagri: samagri,
                                                net: net,
                                                samagriPrice: samagriPrice,
                                                serviceId: serviceId,
                                              ))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            color: Color(0XFFffbd59),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
