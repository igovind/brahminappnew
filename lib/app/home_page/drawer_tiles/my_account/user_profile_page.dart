import 'package:brahminapp/app/home_page/drawer_tiles/my_account/edit_profile_page.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final uid;

  const UserProfilePage({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(context) {
    String _firstName = ' ';
    String _lastName = ' ';
    String _profilePicUrl = 'null';
    String _aboutYou = ' ';
    double _swastik = 0.0;
    String _state = ' ';
    String _type = ' ';
    String _name = ' ';
    String _coverPicUrl;
    bool _verified = false;
    String _number = ' ';
    bool astro;
    String chat = ' ';
    String call = ' ';
    String video = ' ';
    String descp;
    String exp;
    String lang;
    String lName;
    String expert;
    Widget _buildAppBar(context) {
      return AppBar(
        toolbarHeight: 120,
        iconTheme: new IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          'My account',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (contex) => EditProfilePage(
                      astro: astro,
                      call: call,
                      chat: chat,
                      video: video,
                      uid: uid,
                      description: descp,
                      language: lang,
                      experience: exp,
                      expertise: expert,
                      userFirstName: _firstName,
                      //    userLastName: _lastName,
                      userState: _state,
                      userContactNumber: _number,
                      userBio: _aboutYou,
                      userType: _type,
                      userProfilePicUrl: _profilePicUrl,
                      userCoverPicUrl: _coverPicUrl)));
            },
          )
        ],
        centerTitle: true,
      );
    }

    return Scaffold(
      //backgroundColor: Colors.deepOrange[50],
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .doc('punditUsers/$uid/user_profile/user_data')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              _firstName = snapshot.data.data()['firstName'];
              // _lastName = snapshot.data.data()['lastName'];
              _profilePicUrl = snapshot.data.data()['profilePicUrl'];
              _aboutYou = snapshot.data.data()['aboutYou'];
              _swastik = snapshot.data.data()['swastik'].toDouble();
              _state = snapshot.data.data()['state'];
              _type = snapshot.data.data()['type'];
              _coverPicUrl = snapshot.data.data()['coverpic'];
              _name = _firstName + ' ' + _lastName;
              _verified = snapshot.data.data()['verified'];
              _number = snapshot.data.data()['number'];
              astro = snapshot.data.data()['astrologer'] == null
                  ? false
                  : snapshot.data.data()['astrologer'];
              call = snapshot.data.data()['call'];
              video = snapshot.data.data()['video'];
              chat = snapshot.data.data()['chat'];
              descp = snapshot.data.data()['description'];
              expert = snapshot.data.data()['expertise'];
              exp = snapshot.data.data()['experience'];
              lang = snapshot.data.data()['language'];

              print(
                  "????????????????????????////////////////////////////////////$astro ${snapshot.data.data()['astrologer']}");
              return SingleChildScrollView(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.pink,
                            child: _coverPicUrl == null
                                ? Image.asset(
                                    'images/placeholder.jpg',
                                    fit: BoxFit.fitWidth,
                                  )
                                : Image.network(
                                    _coverPicUrl,
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                          Positioned(
                            top: 100,
                            left: ((MediaQuery.of(context).size.width * 0.5) -
                                80),
                            child: Center(
                              child: CircularProfileAvatar(
                                'G',
                                animateFromOldImageOnUrlChange: true,
                                child: _profilePicUrl == null
                                    ? Image.asset(
                                        'images/placeholder.jpg',
                                      )
                                    : Image.network(
                                        _profilePicUrl,
                                        loadingBuilder: (context, Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                radius: 80,
                                borderWidth: 1,
                                borderColor: Colors.white,
                                elevation: 4,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 260,
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 0.5,
                              color: Colors.deepOrange[100],
                              style: BorderStyle.solid),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      _name,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  _verified
                                      ? Icon(
                                          Icons.verified,
                                          color: Color(0XFFffbd59),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              Text(
                                '($_type)',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                              Text(
                                '$_aboutYou',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.deepOrange[100],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0XFFffbd59),
                                    ),
                                    Text(
                                      '$_state',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    ),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    Text(
                                      '$_swastik',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    ),
                                    Icon(Icons.favorite,
                                        color: Color(0XFFffbd59),
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                  ],
                                ),
                              ),
                              Text('$_number',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05)),
                              SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
