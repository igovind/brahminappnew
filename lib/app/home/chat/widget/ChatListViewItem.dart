import 'package:brahminapp/app/home/chat/view/ChatPageView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/app/home/Chat/Global/Colors.dart' as myColors;
import '../ChatListModal.dart';

class ChatListViewItem extends StatelessWidget {
  final ChatListModal? chatListModal;
  final UserId? tuser;

  const ChatListViewItem({this.chatListModal, required this.tuser});

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.now();
    var newFormat = DateFormat.jm().format(dt);
    final user = tuser;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: ListTile(
                  title: Text(
                    chatListModal!.name!,
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    chatListModal!.lastMessage!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chatListModal!.photoUrl!),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        chatListModal!.time!,
                        style: TextStyle(fontSize: 12),
                      ),
                      chatListModal!.hasUnreadMessage!
                          ? Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                  color: myColors.orange,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  )),
                              child: Center(
                                  child: Text(
                                chatListModal!.newMesssageCount.toString(),
                                style: TextStyle(fontSize: 11),
                              )),
                            )
                          : SizedBox()
                    ],
                  ),
                  onTap: () {
                    final UserId user = tuser!;
                    FirebaseFirestore.instance
                        .doc('messeges/${user.uid}/samvad/${chatListModal!.id}')
                        .update({
                      'time': newFormat,
                      'hasUnreadMessage': false,
                      'newMesssageCount': 0,
                      'timestrap': FieldValue.serverTimestamp(),
                    });
                    showDialog(
                      //backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: ChatPageView(
                              utoken: chatListModal!.token,
                              buid: user.uid,
                              pic: user.photoUrl,
                              uida: user.uid,
                              display: user.displayName,
                              username: chatListModal!.name,
                              dp: chatListModal!.photoUrl,
                              uid: chatListModal!.id,
                            ));
                      },
                    );
                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPageView(utoken:chatListModal.token,buid:user.uid,pic:user.photoUrl,uida:user.uid ,display:user.displayName,username: chatListModal.name,dp: chatListModal.photoUrl,uid: chatListModal.id,)));
                  },
                ),
              ),
            ],
          ),
          Divider(
            endIndent: 12.0,
            indent: 12.0,
            height: 0,
          ),
        ],
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.black87,
          icon: Icons.delete,
          onTap: () async {
            await FirebaseFirestore.instance
                .doc('/messeges/${user!.uid}/samvad/${chatListModal!.id}')
                .delete();
          },
        )
      ],
    );
  }
}
