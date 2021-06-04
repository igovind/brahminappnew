import 'dart:async';
import 'package:brahminapp/app/account/okay_button.dart';
import 'package:brahminapp/app/astrology/calls/audio_call.dart';
import 'package:brahminapp/app/astrology/calls/video_call.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  final UserId? userId;
  final String? bid;
  final String? channelName;
  final String? callType;

  /// Creates a call page with given channel name.
  const IndexPage(
      {Key? key, this.channelName, this.userId, this.bid, this.callType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    String? profilePic;
    String? kundaliPic;
    String? rightHand;
    String? leftHand;
    String? name;
    String? place = "Not given";
    Timestamp? time;
    String? timeDate = "Not Given";
    Future<void> onJoin() async {
      // update input validation
      print(
          'THis is channel text ......................................................${_channelController.text}');
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      print("LL?????????????????????????????????????${widget.callType}");
      if (widget.callType == 'Video') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CallPage(
                  bid: widget.bid,
                  userId: widget.userId!.uid,
                  channelName: widget.channelName,
                  name: name,
                  place: place,
                  kundali: kundaliPic,
                  leftHand: leftHand,
                  rightHand: rightHand,
                  time: timeDate, //role: ClientRole.Broadcaster,
                )));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VoiceCallPage(
                  name: name,
                  place: place,
                  time: timeDate,
                  kundali: kundaliPic,
                  leftHand: leftHand,
                  rightHand: rightHand,
                  userId: widget.userId!.uid,
                  channelName: widget.channelName,
                  //role: ClientRole.Broadcaster,
                )));
      }
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FireStoreDatabase(uid: widget.userId!.uid).getTempCall,
          builder: (context, snapshot) {
            if (snapshot == null) {}
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isNotEmpty) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[0];
              profilePic = documentSnapshot.get("image");
              kundaliPic = documentSnapshot.get("kundali");
              rightHand = documentSnapshot.get("righthand");
              leftHand = documentSnapshot.get("lefthand");
              name = documentSnapshot.get("sender");
              time = documentSnapshot.get("time");
              place = documentSnapshot.get(("place")) ?? "Not given";
              DateTime? timestamp = time!.toDate();
              timeDate =
                  "${timestamp.day}/${timestamp.month}/${timestamp.year} - ${timestamp.hour}:${timestamp.minute}";
            }
            if (name == null) {
              return Center(
                child: Text("NO CALL IS HERE"),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height(30),
                    ),
                    Container(
                      height: height(120),
                      decoration: BoxDecoration(
                          color: Colors.black38,
                          image:
                              DecorationImage(image: NetworkImage(profilePic!)),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black54, blurRadius: 4)
                          ]),
                      // url: image,
                    ),
                    SizedBox(
                      height: height(10),
                    ),
                    Text(
                      "$name",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      "DOB $timeDate",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text(
                      "Place of Birth: $place",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [],
                    ),
                    SizedBox(
                      height: height(10),
                    ),
                    kundaliPic == null
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(10)),
                            height: height(200),
                            width: height(400),
                            child: Center(
                                child: Text(
                              "Kundali is not available",
                              style: TextStyle(color: Colors.white),
                            )),
                          )
                        : ImageViev(
                            image: kundaliPic,
                            height: height(250),
                            width: height(400),
                          ),
                    SizedBox(
                      height: height(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        leftHand == null
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(10)),
                                height: height(200),
                                width: height(100),
                                child: Center(
                                    child: Text(
                                  "Left hand image is not available",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                              )
                            : Expanded(
                                child: ImageViev(
                                  image: leftHand,
                                  height: height(200),
                                  width: height(100),
                                ),
                              ),
                        SizedBox(
                          width: height(20),
                        ),
                        rightHand == null
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(10)),
                                height: height(200),
                                width: height(100),
                                child: Center(
                                    child: Text(
                                  "Right hand image is not available",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                )),
                              )
                            : Expanded(
                                child: ImageViev(
                                  image: rightHand,
                                  height: height(200),
                                  width: height(100),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: height(10),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomRaisedButton(
                            onPressed: () {
                              onJoin();
                            },
                            child: Text('Accept'),
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: height(20),
                        ),
                        Expanded(
                          child: CustomRaisedButton(
                            onPressed: () {
                              /*FirebaseFirestore.instance
                                  .doc(
                                      "punditUsers/${widget.userId!.uid}/tempcall/${widget.channelName}")
                                  .update({"reject": true});*/
                              FirebaseFirestore.instance
                                  .doc(
                                  "punditUsers/${widget.userId!.uid}/tempcall/${widget.channelName}")
                                  .delete();
                             // Navigator.of(context).pop();
                            },
                            child: Text('Reject'),
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

class ImageViev extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;

  const ImageViev({Key? key, this.image, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Image.network(image!),
            );
          },
        );
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 3)],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.black54, style: BorderStyle.solid, width: 0.5),
            image: DecorationImage(image: NetworkImage(image!))),
      ),
    );
  }
}
