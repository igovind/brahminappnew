import 'package:brahminapp/app/home_page/drawer_tiles/my_account/new_edit_profile_page.dart';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_profile_page.dart';

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
    String _number=' ';

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .doc('punditUsers/$uid/user_profile/user_data')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.exists) {
            _firstName = snapshot.data.data()['firstName'];
            _lastName = snapshot.data.data()['lastName'];
            _profilePicUrl = snapshot.data.data()['profilePicUrl'];
            _aboutYou = snapshot.data.data()['aboutYou'];
            _swastik = snapshot.data.data()['swastik'].toDouble();
            _state = snapshot.data.data()['state'];
            _type = snapshot.data.data()['type'];
            _coverPicUrl = snapshot.data.data()['coverpic'];
            _name = _firstName + ' ' + _lastName;
            _verified = snapshot.data.data()['verified'];
            _number = snapshot.data.data()['number'];
          } else {
            return NewEditProfilePgae(
              uid: uid,
              added: false,
            );
          }
          return Scaffold(
            appBar: _buildAppBar(context),
            body: SingleChildScrollView(
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
                          left:
                              ((MediaQuery.of(context).size.width * 0.5) - 80),
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
                    Card(
                      color: Colors.deepOrange,
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
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.08),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                _verified
                                    ? Icon(
                                        Icons.verified,
                                        color: Colors.white,
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            Text(
                              '($_type)',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.05),
                            ),
                            Text(
                              _aboutYou,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.04),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    _state,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.05),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.3,
                                  ),
                                  Text(
                                    '$_swastik',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.05),
                                  ),
                                  Icon(Icons.favorite,
                                      color: Colors.white,
                                      size:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                ],
                              ),
                            ),
                            Text(_number,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.deepOrange,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: _buildPujaList(uid)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildAppBar(context) {
    return AppBar(
      toolbarHeight: 120,
      iconTheme: new IconThemeData(color: Colors.deepOrange),
      elevation: 0,
      title: Text(
        'My account',
        style: TextStyle(color: Colors.deepOrange),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          color: Colors.deepOrange,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (contex) => NewEditProfilePgae(
                  uid: uid,
                  added: true,
                )));
          },
        )
      ],
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}

Widget _buildPujaList(String uid) {
  String name;
  double rate;
  return StreamBuilder<QuerySnapshot>(
      stream: FireStoreDatabase(uid: uid).getPujaOfferingList,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data.docs.isEmpty) {
          return Center(
            child: Container(
              child: Text(
                'Add services',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
            ),
          );
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              name = snapshot.data.docs[index].data()['puja'];
              rate = snapshot.data.docs[index].data()['price'];
              return Container(
                child: ListTile(
                  leading: Icon(Icons.arrow_right,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.04),
                  title: Text(
                    name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  trailing: Text(
                    '₹$rate',
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                ),
              );
            });
      });
}
