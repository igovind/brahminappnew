class APIPath{
  static String update(String uid)=>'/users/$uid/detail/pdata';
  static String readChatlist(String? uid)=>'/messeges/$uid/samvad';
  static String recive(String uid)=>'/users/$uid/detail';
}