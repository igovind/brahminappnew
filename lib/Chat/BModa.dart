class BModal {
  final String name,type,region,searchKey,uid,photoUrl;
  final int experience;
  BModal({this.type, this.region, this.name, this.experience,this.searchKey,this.uid,this.photoUrl});
  factory BModal.fromMap(Map<String , dynamic>data){
    if (data==null){
      return null;
    }
    final String name = data['name'];
    final String type = data['type'];
    final int experience = data['experience'];
    final String region=data['region'];
    final String searchKey=data['searchKey'];
    final String uid=data['uid'];
    final String photoUrl=data['photoUrl'];
    return BModal(
      name: name,
      type: type,
      experience: experience,
      region: region,
      searchKey: searchKey,
      uid:uid,
        photoUrl: photoUrl
    );
  }
  Map<String,dynamic> toMap (){
    return
      {
        'uid':uid,
        'name':name,
        'type':type,
        'experience':experience,
        'region':region,
        'photoUrl':photoUrl,
        'searchKey':name[0].toUpperCase(),
      };
  }
}