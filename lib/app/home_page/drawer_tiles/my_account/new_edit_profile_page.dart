import 'dart:io';
import 'package:brahminapp/app/home_page/drawer_tiles/my_account/profile_buttons.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../edit_bank_details.dart';
import 'edit_adhaar_details.dart';

bool infoEdit = false;
bool loading = false;
bool loadingLocation = false;
bool inProcess = false;
File profilePicFile;
String fName = '';
String lName = '';
String aboutYou = '';
String punditType = 'Pundit type';
String state = '';
String profilePicUrl;
String pujaPicUrl;
bool verified = false;
File pujaPicFile;
String coverPicUrl;
double swastika;
File coverPicFile;
String number = ' ';
bool loadingCvr = false;
bool loadingProfile = false;
DateTime dateOfBirth;
Geoflutterfire geo = Geoflutterfire();
GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;
final FirebaseMessaging _messaging = FirebaseMessaging();

Position userLocation;
String tokens;

class NewEditProfilePgae extends StatefulWidget {
  final uid;
  final added;

  const NewEditProfilePgae({Key key, @required this.uid, this.added})
      : super(key: key);

  @override
  _NewEditProfilePgaeState createState() => _NewEditProfilePgaeState();
}

class _NewEditProfilePgaeState extends State<NewEditProfilePgae> {
  final GlobalKey<FormState> _formKeyE = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _messaging.getToken().then((token) {
      setState(() {
        tokens = token;
      });
    });
    _getLocation().then((position) {
      userLocation = position;
    });
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
      print(e);
    }
    return currentLocation;
  }

  addGeoPoint() {
    if (userLocation == null) {
      return null;
    }
    GeoFirePoint point = geo.point(
        latitude: userLocation.latitude, longitude: userLocation.longitude);
    return point.data;
  }

  getProfilePic({ImageSource source}) async {
    this.setState(() {
      inProcess = true;
    });
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image = await ImagePicker.platform.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
      );

      this.setState(() {
        profilePicFile = cropped;
        inProcess = false;
      });
    } else {
      this.setState(() {
        inProcess = false;
      });
    }
  }

  getCoverPic({ImageSource source}) async {
    this.setState(() {
      inProcess = true;
    });
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image = await ImagePicker.platform.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
      );

      this.setState(() {
        coverPicFile = cropped;
        inProcess = false;
      });
    } else {
      this.setState(() {
        inProcess = false;
      });
    }
  }

  Widget _buildFirstName() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        height: 100,
        color: Colors.white,
        child: !infoEdit
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      'First Name  ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFFffbd59)),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      fName,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                ],
              )
            : TextFormField(
                initialValue: fName,
                decoration: InputDecoration(labelText: 'First name'),
                maxLength: 20,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'First name is Required';
                  }
                  return null;
                },
                onSaved: (String value) {
                  setState(() {
                    fName = value;
                  });
                  print('checking...........$fName $value');
                },
              ),
      ),
    );
  }

  Widget _buildNumber() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        height: 100,
        color: Colors.white,
        child: !infoEdit
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      'Contact number  ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFFffbd59)),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      '$number',
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                ],
              )
            : TextFormField(
                initialValue: number,
                decoration: InputDecoration(labelText: 'Contact number'),
                maxLength: 10,
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Contact number is Required';
                  }
                  return null;
                },
                onSaved: (String value) {
                  setState(() {
                    number = value;
                  });
                },
              ),
      ),
    );
  }

  Widget _buildLastName() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        height: 100,
        color: Colors.white,
        child: !infoEdit
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      'City',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFFffbd59)),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      lName,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                ],
              )
            : TextFormField(
                initialValue: lName,
                decoration: InputDecoration(labelText: 'City'),
                maxLength: 18,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'City is Required';
                  }
                  return null;
                },
                onSaved: (String value) {
                  setState(() {
                    lName = value;
                  });
                },
              ),
      ),
    );
  }

  Widget _buildAboutYou() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        height: 100,
        color: Colors.white,
        child: !infoEdit
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      'About You  ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFFffbd59)),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      aboutYou,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )
                ],
              )
            : TextFormField(
                initialValue: aboutYou,
                decoration: InputDecoration(labelText: 'About You'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'About you is Required';
                  }

                  return null;
                },
                onSaved: (String value) {
                  setState(() {
                    aboutYou = value;
                  });
                },
              ),
      ),
    );
  }

  submitForm() {
    if (_formKeyE.currentState.validate() && punditType != null) {
      _formKeyE.currentState.save();
      setState(() {
        loading = true;
      });
      FireStoreDatabase(uid: widget.uid).updateData(data: {
        'firstName': fName,
        'location': addGeoPoint(),
        'token': tokens,
        'lastName': lName,
        'aboutYou': aboutYou,
        'number': number,
        'uid': widget.uid,
        'state': state,
        'dateOfBirth': 'no',
        'type': punditType,
        'searchKey': fName[0].toString(),
      }).whenComplete(() {
        Auth().updateUser(fName, profilePicUrl);
      }).whenComplete(() {
        setState(() {
          infoEdit = !infoEdit;
          loading = false;
        });
      });
    }
  }

  submitCoverPic() {
    setState(() {
      loadingCvr = true;
    });
    _getLocation().whenComplete(() async {
      StorageReference reference = FirebaseStorage.instance
          .ref()
          .child('Users/${widget.uid}/coverPicFile');
      StorageUploadTask uploadTask = reference.putFile(coverPicFile);
      var downloadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = downloadUrl.toString();
      coverPicUrl = url;
    }).whenComplete(() {
      FireStoreDatabase(uid: widget.uid).updateData(data: {
        'coverpic': coverPicUrl,
        'location': addGeoPoint(),
        'token': tokens,
      });
    }).whenComplete(() {
      setState(() {
        coverPicFile = null;
        loadingCvr = false;
      });
    });
  }

  submitProfilePic() {
    setState(() {
      loadingProfile = true;
    });
    _getLocation().whenComplete(() async {
      StorageReference reference = FirebaseStorage.instance
          .ref()
          .child('Users/${widget.uid}/profilePicFile');
      StorageUploadTask uploadTask = reference.putFile(coverPicFile);
      var downloadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      var url = downloadUrl.toString();
      profilePicUrl = url;
    }).whenComplete(() {
      FireStoreDatabase(uid: widget.uid).updateData(data: {
        'profilePicUrl': profilePicUrl,
        'location': addGeoPoint(),
        'token': tokens,
      });
    }).whenComplete(() {
      Auth().updateUserphoto(profilePicUrl);
    }).whenComplete(() {
      setState(() {
        profilePicFile = null;
        loadingProfile = false;
      });
    });
  }

  updateLocation() {
    setState(() {
      loadingLocation = true;
    });
    _getLocation().whenComplete(() {
      FireStoreDatabase(uid: widget.uid).updateData(data: {
        'location': addGeoPoint(),
      }).whenComplete(() {
        setState(() {
          loadingLocation = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit your profile'),
        toolbarHeight: 100,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FireStoreDatabase(uid: widget.uid).getUserData,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.data() != null) {
              pujaPicUrl = snapshot.data.data()['pujaPicUrl'];
              fName = snapshot.data.data()['firstName'];
              lName = snapshot.data.data()['lastName'];
              aboutYou = snapshot.data.data()['aboutYou'];
              punditType = snapshot.data.data()['type'];
              state = snapshot.data.data()['state'];
              profilePicUrl = snapshot.data.data()['profilePicUrl'];
              coverPicUrl = snapshot.data.data()['coverpic'];
              verified = snapshot.data.data()['verified'];
              number = snapshot.data.data()['number'];
            }
            if (snapshot.data.data() == null) {
              /* setState(() {
                infoEdit = !infoEdit;
              });*/
            }
            return Padding(
              padding: EdgeInsets.all(6),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Opacity(
                      opacity: infoEdit ? 0.5 : 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: loadingCvr
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : coverPicFile == null
                                    ? (coverPicUrl == null
                                        ? Image.asset(
                                            'images/newback.jpg',
                                            fit: BoxFit.fitWidth,
                                          )
                                        : netImg(coverPicUrl))
                                    : Image.file(
                                        coverPicFile,
                                        fit: BoxFit.fitWidth,
                                      ),
                          ),
                          Positioned(
                            child: loadingCvr
                                ? SizedBox()
                                : Container(
                                    //padding: EdgeInsets.all(),
                                    child: coverPicFile != null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FlatButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      coverPicFile = null;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    color: Colors.white,
                                                    child: Text(
                                                      'Cancel  ',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                              FlatButton(
                                                  onPressed: () {
                                                    submitCoverPic();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    color: Colors.white,
                                                    child: Text(
                                                      'Submit  ',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                            ],
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(5),
                                            color: Colors.white,
                                            child: IconButton(
                                                color: Color(0XFFffbd59),
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  getCoverPic(
                                                      source:
                                                          ImageSource.gallery);
                                                }),
                                          ),
                                  ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.175,
                            left: ((MediaQuery.of(context).size.width * 0.5) -
                                120),
                            child: Column(
                              children: [
                                CircularProfileAvatar(
                                  '',
                                  child: loadingProfile
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : profilePicFile == null
                                          ? (profilePicUrl == null
                                              ? Image.asset(
                                                  'images/placeholder.jpg')
                                              : netImg(profilePicUrl))
                                          : Image.file(profilePicFile),
                                  radius: 70,
                                  borderColor: Colors.white,
                                  elevation: 8,
                                  borderWidth: 1,
                                ),
                                Container(
                                  width: 200,
                                  // color: Colors.white,
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      loadingProfile
                                          ? SizedBox()
                                          : profilePicFile != null
                                              ? FlatButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      profilePicFile = null;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    color: Colors.white,
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                              : IconButton(
                                                  icon: Icon(Icons.camera),
                                                  iconSize: 30,
                                                  color: Colors.deepOrange,
                                                  onPressed: () =>
                                                      getProfilePic(
                                                        source:
                                                            ImageSource.camera,
                                                      )),
                                      loadingProfile
                                          ? SizedBox()
                                          : profilePicFile != null
                                              ? FlatButton(
                                                  onPressed: () {
                                                    submitProfilePic();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    color: Colors.white,
                                                    child: Text(
                                                      'Submit',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                              : IconButton(
                                                  icon: Icon(Icons.photo),
                                                  iconSize: 30,
                                                  color: Colors.deepOrange,
                                                  onPressed: () =>
                                                      getProfilePic(
                                                        source:
                                                            ImageSource.gallery,
                                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        'Tap to update your current location so that people can easily find you in their nearby location'),
                    SizedBox(
                      height: 20,
                    ),
                    loadingLocation
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomRaisedButton(
                            onPressed: () {
                              updateLocation();
                            },
                            color: Colors.lightGreen,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_location,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    'Update Your Current Location',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        loading
                            ? SizedBox()
                            : infoEdit
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              infoEdit = !infoEdit;
                                            });
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      FlatButton(
                                          onPressed: () {
                                            submitForm();
                                          },
                                          child: Text(
                                            'Submit',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  )
                                : FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        infoEdit = !infoEdit;
                                      });
                                    },
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              border: Border.all(
                                  color:
                                      infoEdit ? Colors.green : Colors.black26,
                                  style: BorderStyle.solid,
                                  width: 2)),
                          child: loading
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Form(
                                    key: _formKeyE,
                                    child: Column(
                                      children: [
                                        _buildFirstName(),
                                        _buildLastName(),
                                        _buildNumber(),
                                        _buildAboutYou(),
                                        //_buildType(),
                                        //_buildState(),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Opacity(
                        opacity: infoEdit ? 0.5 : 1,
                        child: Text(
                            'Adhaar details are required in order to verify your account to protect our community from spams.')),
                    SizedBox(
                      height: 15,
                    ),
                    Opacity(
                      opacity: infoEdit ? 0.5 : 1,
                      child: ProfileButtons(
                        icon: Icon(
                          Icons.insert_drive_file,
                          color: Colors.white,
                        ),
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: FireStoreDatabase(uid: widget.uid)
                                .getAdhaarDetails,
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.data.data() == null) {
                                return EditAdhaarDetails(
                                  uid: widget.uid,
                                  added: false,
                                );
                              }
                              return EditAdhaarDetails(
                                uid: widget.uid,
                                added: true,
                                address: snapshot.data.data()['address'],
                                adhaarName: snapshot.data.data()['name'],
                                adhaarNumber:
                                    snapshot.data.data()['adhaarNumber'],
                                frontAdhaarUrl:
                                    snapshot.data.data()['frontAdhaarPicUrl'],
                                backAdhaarUrl:
                                    snapshot.data.data()['backAdhaarPicUrl'],
                              );
                            }),
                        title: 'Adhaar details',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(height: 30),
                    Opacity(
                        opacity: infoEdit ? 0.5 : 1,
                        child: Text(
                            'Bank details will be required in order to get rewards and and payments from your jajmaan ')),
                    SizedBox(height: 15),
                    Opacity(
                      opacity: infoEdit ? 0.5 : 1,
                      child: ProfileButtons(
                        icon: Icon(
                          Icons.account_balance,
                          color: Colors.white,
                        ),
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: FireStoreDatabase(uid: widget.uid)
                                .getBankDetails,
                            builder: (context, snapshot1) {
                              if (snapshot1.data == null) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!snapshot1.data.exists ||
                                  snapshot1.data == null) {
                                return EditBankDetails(
                                  uid: widget.uid,
                                );
                              }
                              return EditBankDetails(
                                uid: widget.uid,
                                bankName: snapshot1.data.data()['bankName'],
                                name: snapshot1.data.data()['name'],
                                accountNumber:
                                    snapshot1.data.data()['accountNumber'],
                                ifscCode: snapshot1.data.data()['IFSC'],
                              );
                            }),
                        title: 'Bank details',
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

Widget netImg(String url) {
  return Image.network(
    url,
    fit: BoxFit.fitWidth,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
              : null,
        ),
      );
    },
  );
}
