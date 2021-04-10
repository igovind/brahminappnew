import 'package:brahminapp/app/create_profile/edit_bank_details.dart';
import 'package:brahminapp/app/account/edit_adhaar_details.dart';
import 'package:brahminapp/app/create_profile/registration_form.dart';
import 'package:brahminapp/app/astrology/astrology_page.dart';

import 'package:brahminapp/app/services_given/puja_offering.dart';
import 'package:brahminapp/services/database.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../account/gallery_page.dart';

class RegistrationPage extends StatefulWidget {
  final uid;
  final int startingIndex;
  final AsyncSnapshot<DocumentSnapshot> snapshot;

  const RegistrationPage(
      {Key key, @required this.uid, this.snapshot, this.startingIndex})
      : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool astrology = false;

  @override
  Widget build(BuildContext context) {
    int _currentIndex = widget.startingIndex;
    Widget body() {
      switch (_currentIndex) {
        case 0:
          return Container(
            padding: EdgeInsets.only(left: 8, right: 8),
            height: 630,
            child: RegistrationForm(
              uid: widget.uid,
            ),
          );
          break;
        case 1:
          return Container(
            child: astrology
                ? Column(
                    children: [
                      Container(
                          height: 610,
                          child: AstrologyPage(
                            uid: widget.uid,
                            snapshot: null,
                          )),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                        ),
                        Text(
                          "Are you a Astrologer?",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  astrology = true;
                                  FireStoreDatabase(uid: widget.uid)
                                      .updateData(data: {
                                    'astrologer': true,
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black54, blurRadius: 3)
                                    ],
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex++;
                                  FireStoreDatabase(uid: widget.uid)
                                      .updateData(data: {
                                    'astrologer': false,
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black54, blurRadius: 3)
                                    ],
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
          );
          break;
        case 2:
          return Column(
            children: [
              Container(height: 620, child: EditAdhaarDetails(uid: widget.uid)),
              FlatButton(
                  onPressed: () {
                    FireStoreDatabase(uid: widget.uid)
                        .updateData(data: {'initialIndex': 3});
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
          break;
        case 3:
          return Column(
            children: [
              Container(
                height: 620,
                child: EditBankDetails(
                  uid: widget.uid,
                ),
              ),
              FlatButton(
                  onPressed: () {
                    FireStoreDatabase(uid: widget.uid)
                        .updateData(data: {'initialIndex': 4});
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
          break;
        case 4:
          return Column(
            children: [
              Container(
                height: 620,
                child: GalleryPage(
                  uid: widget.uid,
                ),
              ),
              FlatButton(
                  onPressed: () {
                    FireStoreDatabase(uid: widget.uid)
                        .updateData(data: {'initialIndex': 5});
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
          break;
        case 5:
          return Column(
            children: [
              Container(
                height: 620,
                child: PujaOffering(
                  uid: widget.uid,
                ),
              ),
              FlatButton(
                  onPressed: () {
                    FireStoreDatabase(uid: widget.uid)
                        .updateData(data: {'ready': true});
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
          break;
      }
      return Text("error");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Registration",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: body(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DotsIndicator(
                onTap: (value) {
                  setState(() {
                    _currentIndex = value.toInt();
                  });
                },
                position: _currentIndex.toDouble(),
                dotsCount: 6,
                decorator: DotsDecorator(
                  size: Size.fromRadius(5),
                  color: Colors.black54,
                  activeColor: Colors.deepOrangeAccent,
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0)),
                )),
          )
        ],
      ),
    );
  }
}
