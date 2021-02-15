import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:brahminapp/calls/video_call.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';




class IndexPage extends StatefulWidget {

  final String Userid;
  final String bid;
  final String channelName;
  /// Creates a call page with given channel name.
  const IndexPage({Key key, this.channelName, this.Userid, this.bid}) : super(key: key);
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;


  ClientRole _role = ClientRole.Broadcaster;



  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: onJoin,
                        child: Text('Join'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    print('THis is channel text ......................................................${_channelController.text}');
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    // push video page with given channel name
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CallPage(
      bid: widget.bid,
      Userid: widget.Userid,
      channelName:widget.channelName,
      //role: ClientRole.Broadcaster,
    )));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
