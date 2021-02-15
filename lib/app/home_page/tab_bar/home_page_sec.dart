import 'package:brahminapp/app/home_page/tab_bar/newsfeed_tile.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePageSec extends StatefulWidget {
  final String uid;
  final int num;
  final double net;

  const HomePageSec({Key key, @required this.uid, this.num, this.net})
      : super(key: key);

  @override
  _HomePageSecState createState() => _HomePageSecState();
}

class _HomePageSecState extends State<HomePageSec> {
  @override
  Widget build(BuildContext context) {
    print('wiggggggggggggggggggggggggggggggggggg ${widget.num}');
    int reward=widget.num;
    double _net = widget.net;
    bool claimed = false;
    return StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: widget.uid).getTrendingPujaList,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>Call))
                              },
                              child: Icon(
                                Icons.local_fire_department_outlined,
                                color: Color(0XFFffbd59),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Trending pooja',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height*0.25,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 80,
                                width: 200,
                               decoration: BoxDecoration(
                                 color: Colors.transparent,
                                 borderRadius: BorderRadius.circular(10)
                               ),

                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: Container(
                                        height: 120,
                                        width: 200,
                                      ),
                                      bottom: 0,
                                    ),
                                    Positioned(
                                      child: Image.network(
                                        snapshot.data.docs[index]
                                            .data()['image'],
                                        height: 150,
                                        width: 180,
                                        fit: BoxFit.fill,
                                      ),
                                      top: 0,
                                    ),
                                    Positioned(
                                      child: Container(

                                        child: Text(
                                          '${snapshot.data.docs[index].data()['name']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold
                                             ),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      bottom: 5,
                                      left: 3,
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                width: 7,
                                height: 100,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            thickness: 0.5,
                            color: Color(0XFFffbd59),
                          ),
                        ),
                        reward==null?Container(
                          width: 350,
                          height: 70,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 5,),
                                Icon(
                                  Icons.local_offer_sharp,
                                  color: Color(0XFFffbd59),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  'Complete 7 puja and claim your reward',
                                  style: TextStyle(color: Color(0XFFffbd59),fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                        ):reward >= 7
                            ? Container(
                          height: 70,
                          child: SingleChildScrollView
                            (
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 5,),
                                Icon(
                                  Icons.local_offer_sharp,
                                  color: Color(0XFFffbd59),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  'Criteria fulfilled claim your reward',
                                  style: TextStyle(color: Colors.green,fontSize: 12),
                                ),

                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        claimed = true;
                                      });
                                      showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            title: Text('Reward Claimed'),
                                            content: Text(
                                                'We will soon add your reward'),
                                          ));
                                      FirebaseFirestore.instance
                                          .collection('rewardClaim')
                                          .doc('${DateTime.now()}')
                                          .set({
                                        'date':FieldValue.serverTimestamp(),
                                        'uid': widget.uid,
                                        'reward':
                                        ((_net / (widget.num)) * 7),
                                        'done': false
                                      })
                                          .whenComplete(() => {
                                        FirebaseFirestore.instance
                                            .doc(
                                            'punditUsers/${widget.uid}/user_profile/user_data')
                                            .update({
                                          'setReward':
                                          widget.num - 7,
                                          'setPrice': (_net -
                                              (_net /
                                                  (widget
                                                      .num)) *
                                                  7),
                                        })
                                      })
                                          .whenComplete(() {
                                        setState(() {
                                          claimed = false;
                                        });
                                      });
                                    },
                                    child: Text(
                                      claimed ? 'Claimed' : 'Claim Reward',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w800),
                                    ))
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                        )
                            : Container(
                          width: 350,
                          height: 70,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 5,),
                                Icon(
                                  Icons.local_offer_sharp,
                                  color: Color(0XFFffbd59),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  'Complete 7 puja and claim your reward',
                                  style: TextStyle(color:Colors.black54,fontSize: 12,fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: Row(
                            children: [
                              Text('Notifications',style: TextStyle(color:Colors.black54,fontWeight:FontWeight.bold),),
                              SizedBox(width:10),
                              Icon(Icons.notification_important,color: Color(0XFFffbd59),)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(
                                'punditUsers/${widget.uid}/newsFeed')
                                .orderBy('date', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return SizedBox();
                              }
                              return Container(
                                
                                padding: EdgeInsets.all(8),
                                height: MediaQuery.of(context).size.height*0.4,
                                child: ListView.builder(
                                    itemCount: snapshot.data.size,
                                    itemBuilder: (context, index) {
                                      final title = snapshot.data.docs[index]
                                          .data()['title'];
                                      final subtitle = snapshot.data.docs[index]
                                          .data()['subtitle'];
                                      final description = snapshot
                                          .data.docs[index]
                                          .data()['description'];
                                      final Timestamp date = snapshot
                                          .data.docs[index]
                                          .data()['date'];
                                      final DateTime tdate = date.toDate();
                                      final String d =
                                          'on ${tdate.day}/${tdate.month}/${tdate.year} at ${tdate.hour}:${tdate.minute}';

                                      final imageUrl = snapshot.data.docs[index]
                                          .data()['imageUrl'];
                                      return NewsFeedTile(
                                        imageUrl: imageUrl,
                                        title: title,
                                        subtitle: subtitle,
                                        date: d,
                                        description: description,
                                      );
                                    }),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5)
                                  //border: Border.all(color: Colors.deepOrange,width: 1.0,style: BorderStyle.solid),borderRadius: BorderRadius.circular(10)
                                ),
                              );
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

String monthName(int month) {
  if (month == 1) {
    return "January";
  } else if (month == 2) {
    return "Febrary";
  } else if (month == 3) {
    return "March";
  } else if (month == 4) {
    return "April";
  } else if (month == 5) {
    return "May";
  } else if (month == 6) {
    return "June";
  } else if (month == 7) {
    return "July";
  } else if (month == 8) {
    return "August";
  } else if (month == 9) {
    return "September";
  } else if (month == 10) {
    return "October";
  } else if (month == 11) {
    return "November";
  } else if (month == 12) {
    return "December";
  } else {
    return null;
  }
}

String weekName(int week) {
  if (week == 1) {
    return "Sunday";
  } else if (week == 2) {
    return "Monday";
  } else if (week == 3) {
    return "Tuesday";
  } else if (week == 4) {
    return "Wednesday";
  } else if (week == 5) {
    return "Thursday";
  } else if (week == 6) {
    return "Friday";
  } else if (week == 7) {
    return "Saturday";
  } else {
    return null;
  }
}
/*
*    */