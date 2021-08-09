class ChatListModal{
  final id;
  final String? token;
  final String? photoUrl;
  final String? name;
  final String? lastMessage;
  final String? time;
  final bool? hasUnreadMessage;
  final int? newMesssageCount;

 ChatListModal({this.token,this.photoUrl,this.name,this.lastMessage,this.time,this.hasUnreadMessage,this.newMesssageCount,this.id});

  factory ChatListModal.fromMap(Map<String , dynamic>data){
    // ignore: unnecessary_null_comparison
    if (data==null){
      return ChatListModal();
    }
    final String? token=data['token'];
    final String? photoUrl=data['photoUrl'];
    final String? name=data['name'];
    final String? lastMessage=data['lastMessage'];
    final String? time=data['time'];
    final String? id=data['id'];
    final bool? hasUnreadMessage=data['hasUnreadMessage'];
    final int? newMesssageCount=data['newMesssageCount'];
    return ChatListModal(
        token: token,
        name:name,
        photoUrl:photoUrl,
        lastMessage:lastMessage,
        time:time,
        id: id,
        hasUnreadMessage:hasUnreadMessage,
        newMesssageCount:newMesssageCount
    );
  }
  Map<String,dynamic> toMap (){
    return
      {
        'token':token,
        'name':name,
        'photoUrl':photoUrl,
        'lastMessage':lastMessage,
        'time':time,
        'id':id,
        'hasUnreadMessage':hasUnreadMessage,
        'newMesssageCount':newMesssageCount
      };
  }
}