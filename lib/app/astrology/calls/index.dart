import 'dart:async';
import 'package:brahminapp/app/astrology/calls/audio_call.dart';
import 'package:brahminapp/app/astrology/calls/video_call.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class IndexPage extends StatefulWidget {
  final UserId userId;
  final String bid;
  final String channelName;
  final String callType;

  /// Creates a call page with given channel name.
  const IndexPage(
      {Key key, this.channelName, this.userId, this.bid, this.callType})
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

    String profilePic =
        "https://a10.gaanacdn.com/images/albums/4/1879604/crop_175x175_1879604.jpg";
    String kundaliPic = "https://i.stack.imgur.com/vKpJn.jpg";
    String rightHand =
        "https://m0.her.ie/wp-content/uploads/2016/08/09170056/HandLines1.jpg";
    String leftHand =
        "https://m0.her.ie/wp-content/uploads/2016/08/09170056/HandLines1.jpg";
    String name = "govind mishra";
    Timestamp time;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FireStoreDatabase(uid: widget.userId.uid).getTempCall,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            print(
                "yes this is present?????????????????????????????????????????????/${snapshot.data}");
            if (snapshot.data.docs.isNotEmpty) {
              DocumentSnapshot documentSnapshot = snapshot.data.docs[0];
              profilePic = documentSnapshot.data()["image"];
              kundaliPic = documentSnapshot.data()["kundali"];
              rightHand = documentSnapshot.data()["righthand"];
              leftHand = documentSnapshot.data()["lefthand"];
              name = documentSnapshot.data()["sender"];
              time = documentSnapshot.data()["time"];
              print(
                  "yes this is present?????????????????????????????????????????????/");
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height(50),
                    ),
                    CircularProfileAvatar(profilePic),
                    Text("$name"),
                    SizedBox(
                      height: height(5),
                    ),
                   // Text("$time"),
                    SizedBox(
                      height: height(10),
                    ),
                    kundaliPic == null
                        ? SizedBox()
                        : ImageViev(
                            image: kundaliPic,
                            height: height(250),
                            width: height(400),
                          ),
                    SizedBox(
                      height: height(10),
                    ),
                    Row(
                      children: [
                        leftHand == null
                            ? SizedBox()
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
                            ? SizedBox()
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
                          child: RaisedButton(
                            onPressed: () {
                              onJoin();
                            },
                            child: Text('Accept'),
                            color: Colors.green,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              /* FirebaseFirestore.instance
                                  .collection(
                                      "punditUsers/${widget.userId.uid}/tempcall")
                                  .update({"reject": true});*/
                              Navigator.of(context).pop();
                            },
                            child: Text('Reject'),
                            color: Colors.red,
                            textColor: Colors.white,
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

  Future<void> onJoin() async {
    // update input validation
    print(
        'THis is channel text ......................................................${_channelController.text}');
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    // push video page with given channel name
    print("LL?????????????????????????????????????${widget.callType}");
    if (widget.callType == 'Video') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallPage(
                    bid: widget.bid,
                    userId: widget.userId.uid,
                    channelName: widget.channelName,
                    //role: ClientRole.Broadcaster,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VoiceCallPage(
                    bid: widget.bid,
                    userId: widget.userId.uid,
                    channelName: widget.channelName,
                    //role: ClientRole.Broadcaster,
                  )));
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

class ImageViev extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  const ImageViev({Key key, this.image, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
          backgroundColor: Colors.transparent,
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
                child: PhotoView(
                  tightMode: true,
                  imageProvider: NetworkImage(image),
                ));
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
            image: DecorationImage(image: NetworkImage(image))),
      ),
    );
  }
}
