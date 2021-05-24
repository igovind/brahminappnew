import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:brahminapp/app/home/Chat/Global/Colors.dart' as myColors;
class ChatPageView extends StatefulWidget {
  final String? username;
  final String? dp;
  final String buid;
  final String? uid;
  final String? display;
  final String? uida;
  final String? pic;
  final String? utoken;

  const ChatPageView({
    Key? key,
    this.utoken,this.username, this.dp,required this.uid,required this.buid,this.display,this.uida,this.pic
  }) : super(key: key);

  @override
  _ChatPageViewState createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  TextEditingController _text = new TextEditingController();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? messege;
  int counter=0;
  String? tokenA;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messaging.getToken().then((token) {
      setState(() {
        tokenA = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var dt=DateTime.now();
    var newFormat = DateFormat.jm().format(dt);
    return Scaffold(
      body: SafeArea(
        child: Container(

          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.deepOrange,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.username ?? "Jimi Cooke",
                                style: TextStyle(color: Colors.black54, fontSize: 15),
                              ),

                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                '${widget.dp}'
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    // height: 500,
                    child: Container(
                      padding: EdgeInsets.only(top: 40),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "images/chat-background-1.jpg"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.linearToSrgbGamma()),
                      ),
                      child: SingleChildScrollView(
                        reverse: true,
                        physics: ScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('messeges/${widget.uida}/samvad/${widget.uid}/chats').orderBy("timestrap").snapshots(),
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData){
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    final messeges = snapshot.data!.docs.reversed;
                                    List<Widget> messegeWidgets=[];
                                    for(var mess in messeges){
                                      final messegecontent=mess.get('content');
                                      final time= mess.get('time');
                                      final sender=mess.get('sender');
                                      if(sender==widget.display){
                                        final messagewidget=sendMessage(context, messegecontent, time);
                                        messegeWidgets.add(messagewidget);
                                      }
                                      else{
                                        final messagewidget=receivedMessage(context, messegecontent, time);
                                        messegeWidgets.add(messagewidget);
                                      }

                                    }
                                    return ListView(
                                        reverse: true,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: messegeWidgets
                                    );
                                  }
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 0, color: Colors.black26),
                  // SizedBox(
                  //   height: 50,
                  Container(
                    color: Colors.white,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        maxLines: 20,
                        controller: _text,
                        onChanged: (value){
                          setState(() {
                            messege=value;
                          });
                        },
                        decoration: InputDecoration(
                          // contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              print(widget.display);
                              setState(() {
                                counter++;
                              });
                              _text.clear();
                              FirebaseFirestore.instance.collection('messeges/${widget.uida}/samvad/${widget.uid}/chats').add({
                                'sender':'${widget.display}',
                                'reciver':'${widget.username}',
                                'time':newFormat,
                                'timestrap':FieldValue.serverTimestamp(),
                                'content':messege,
                                'token':'${widget.utoken}',
                                'image':'${widget.pic}',

                                
                              });
                              FirebaseFirestore.instance.doc('messeges/${widget.uida}/samvad/${widget.uid}').set({
                                'name':widget.username,
                                'photoUrl':widget.dp,
                                'lastMessage':messege,
                                'id':widget.uid,
                                'participants':FieldValue.arrayUnion(['${widget.display}','${widget.username}']),
                                'time':newFormat,
                                'hasUnreadMessage':false,
                                'newMesssageCount':0,
                                'token':widget.utoken,
                                'timestrap':FieldValue.serverTimestamp(),
                              });
                              FirebaseFirestore.instance.doc('users/${widget.uid}/samvad/${widget.uida}').set({
                                'name':widget.display,
                                'photoUrl':widget.pic,
                                'lastMessage':messege,
                                'id':widget.uida,
                                'time':newFormat,
                                'hasUnreadMessage':true,
                                'newMesssageCount':counter,
                                'token':tokenA,
                                'timestrap':FieldValue.serverTimestamp(),

                              });
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 1,horizontal: 15),
                          hintText: "enter your message",
                        ),
                      ),
                    ),
                  ),
                  // ),
                ],
              ),
             /* Positioned(
                top: height*0.08,
                left: width*0.3,
                right: width*0.3,
                child: Align(
                    alignment: Alignment(0, 0),
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      height: 25,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          )),
                      child: Center(
                          child: Text(
                            "Today",
                            style: TextStyle(fontSize: 11),
                          )),
                    )),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
  Widget sendMessage(BuildContext context, String content, String time){
    return Align(
      alignment: Alignment(1, 0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
              right: 8.0, left: 50.0, top: 4.0, bottom: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)),
            child: Container(
              color: myColors.blue[500],
              // margin: const EdgeInsets.only(left: 10.0),
              child: Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 14.0, left: 23.0, top: 8.0, bottom: 15.0),
                  child: Text(
                    content,
                  ),
                ),
                Positioned(
                  bottom: 1,
                  left: 5,
                  child: Text(
                    time,
                    style: TextStyle(
                        fontSize: 10, color: Colors.black.withOpacity(0.6)),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
  Widget receivedMessage(BuildContext context, String content, String time){
    return Align(
      alignment: Alignment(-1, 0),
      child: Container(
          child: Padding(
            padding:
            const EdgeInsets.only(right: 75.0, left: 8.0, top: 8.0, bottom: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)),
              child: Container(
                color: myColors.orange[700],
                child: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 23.0, left: 12.0, top: 8.0, bottom: 15.0),
                    child: Text(
                      content,
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 8,
                    child: Text(
                      time,
                      style: TextStyle(
                          fontSize: 10, color: Colors.black.withOpacity(0.6)),
                    ),
                  )
                ]),
              ),
            ),
          )),
    );
  }
}
