import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/Chat/Global/Colors.dart' as myColors;
import 'package:brahminapp/Chat/Widget/ChatListViewItem.dart';
import 'package:brahminapp/Chat/ChatListModal.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/auth.dart';


class Chat extends StatefulWidget {
  final UserId user;
  final DatabaseL databaseL;

  const Chat({Key key, @required this.user, @required this.databaseL}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build( context) {
    final database=Provider.of<DatabaseL>(context,listen: false);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
       title: Text('Chats',style: TextStyle(color: Color(0XFFffbd59)),),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Container(
            decoration: BoxDecoration(
                color: myColors.backGround,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: StreamBuilder<List<ChatListModal>>(
                stream:database.readChatlist()??widget.databaseL.readChatlist(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.active){
                    if(snapshot.data!=null){
                      final pd=snapshot.data;
                      final pdata=pd.map((chatListModal) => ChatListViewItem(chatListModal: chatListModal,tuser:widget.user,)).toList();
                      return ListView(
                          shrinkWrap: true,
                          children:pdata
                      );
                    }
                    else{
                      return Scaffold(
                        body: Container(
                          child: Center(
                            child: Text('Empty.........'),
                          ),
                        ),
                      );
                    }
                  }
                  else{
                    return Scaffold(
                      body: Container(
                        child: Center(
                          child: Text('Loading........'),
                        ),
                      ),
                    );
                  }
                }
            ),
          ),
        ),
      ),
    );
  }
}
