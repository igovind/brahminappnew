import 'package:brahminapp/app/home_page/drawer_tiles/client_detail_page.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  final String uid;

  const Payment({Key key, @required this.uid}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool payment = true;
  bool rewards = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: widget.uid).getPaymentHistory,
        builder: (context, snapshot2) {
          if (snapshot2.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          payment = true;
                          rewards = false;
                        });
                      },
                      child: Text(
                        'Payments',
                        style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            color: payment ? Colors.deepOrange : Colors.black54,
                            fontWeight: payment ? FontWeight.bold : null),
                      )),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          payment = false;
                          rewards = true;
                        });
                      },
                      child: Text(
                        'Rewards',
                        style: TextStyle(
                            color: rewards ? Colors.deepOrange : Colors.black54,
                            fontWeight: rewards ? FontWeight.bold : null),
                      ))
                ],
              ),
              Divider(
                thickness: 1,
                color: Colors.deepOrange,
              ),
              payment
                  ? Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot2.data.docs.reversed.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot ref =
                                snapshot2.data.docs[index];
                            final String date = ref.data()['date'];
                            final String time = ref.data()['time'];
                            final String pic = ref.data()['pic'];
                            final String service = ref.data()['service'];
                            final String client = ref.data()['client'];
                            final String location = ref.data()['Location'];
                            final bool paid = ref.data()['payment'];
                            dynamic cod = ref.data()['cod'];
                            final String serviceId = ref.id;
                            final double rate = (ref.data()['price']);
                            return Container(
                              padding: EdgeInsets.all(8),
                              child: GestureDetector(
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.check_box,
                                          size: 30,
                                          color: Colors.deepOrange,
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '\₹ ${rate.roundToDouble()}',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              ' is successfully received by ',
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              '$date $time',
                                              style: TextStyle(
                                                  color: Colors.black54, fontSize:12),
                                            ),
                                            Text(
                                              ' $client ',
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              '$service',
                                              style: TextStyle(
                                                  color: Colors.deepOrange,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              'Booking Id: $serviceId',
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      color: Colors.deepOrange,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FireStoreDatabase(uid: widget.uid).getRewadsList,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        childAspectRatio: 1.0 / 1),
                                itemCount: snapshot.data.docs.reversed.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot ref =
                                      snapshot.data.docs[index];
                                  final date = ref.data()['date'];

                                  final DateTime tdate = date.toDate();
                                  final String d =
                                      'on ${tdate.day}/${tdate.month}/${tdate.year} at ${tdate.hour}:${tdate.minute}';

                                  final double reward = ref.data()['reward'];
                                  final double won = reward.roundToDouble();
                                  return GestureDetector(
                                    child: Stack(
                                      children: [
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              border: Border.all(
                                                  color: Colors.deepOrange,
                                                  width: 1),
                                            ),
                                            child: Image.asset(
                                              'images/paisa.jpg',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Text(
                                                'You Won',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.deepPurple,
                                                    fontWeight: FontWeight.w700,
                                                    backgroundColor:
                                                        Colors.white),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '\₹ $won',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    backgroundColor:
                                                        Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(),
                                              Text(
                                                d == null ? ' ' : d,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    backgroundColor:
                                                        Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );
                      }),
            ],
          );
        });
  }
}
