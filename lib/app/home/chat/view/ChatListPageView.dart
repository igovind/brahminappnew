import 'package:brahminapp/app/home/chat/widget/ChatListViewItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/auth.dart';

import '../ChatListModal.dart';

class Chat extends StatefulWidget {
  final UserId? user;
  final DatabaseL? databaseL;

  const Chat({Key? key, required this.user, required this.databaseL})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(context) {
    final database = Provider.of<DatabaseL>(context, listen: false);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Inbox',
            style: TextStyle(color: Color(0XFFffbd59)),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Container(
            /* decoration: BoxDecoration(
                color: myColors.backGround,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),*/
            color: Colors.white,
            child: StreamBuilder<List<ChatListModal>>(
                stream:
                    database.readChatlist() ,//?? widget.databaseL!.readChatlist(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data!.isEmpty == true) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset(
                              "images/no_message.png",
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            Text(
                              'No Message',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    if (snapshot.data != null) {
                      final pd = snapshot.data!;
                      final pdata = pd
                          .map((chatListModal) => ChatListViewItem(
                                chatListModal: chatListModal,
                                tuser: widget.user,
                              ))
                          .toList();
                      return ListView(shrinkWrap: true, children: pdata);
                    } else {
                      return Scaffold(
                        body: Container(
                          child: Center(
                            child: Text('Empty.........'),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text('Loading........'),
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
