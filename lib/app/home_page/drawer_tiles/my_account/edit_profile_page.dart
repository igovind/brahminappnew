import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/my_account/profile_buttons.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../edit_bank_details.dart';
import 'edit_adhaar_details.dart';

bool _astro = false;
String descp;
String exp;
String lang;
String lName;
String expert;

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class EditProfilePage extends StatefulWidget {
  final uid;
  final String userFirstName;
  final String userLastName;
  final String userState;
  final String userContactNumber;
  final String userBio;
  final String userType;
  final String userProfilePicUrl;
  final String userCoverPicUrl;
  final bool astro;
  final String call;
  final String chat;
  final String video;
  final String experience;
  final String expertise;
  final String language;
  final String description;

  const EditProfilePage(
      {Key key,
      @required this.userFirstName,
      @required this.userLastName,
      @required this.userState,
      @required this.userContactNumber,
      @required this.userBio,
      @required this.userType,
      @required this.userProfilePicUrl,
      @required this.userCoverPicUrl,
      this.uid,
      this.astro,
      this.call,
      this.chat,
      this.video,
      this.experience,
      this.expertise,
      this.language,
      this.description})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String state;
  String type;
  String call;
  String chat;
  String video;

  File userProfilePicFile;
  File userCoverPicFile;
  bool inProcess = false;
  Position userLocation;
  bool locationLoading = false;
  Geoflutterfire geo = Geoflutterfire();
  GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;
  final _tFormKey = GlobalKey<FormState>();
  bool loading = false;

  void initState() {
    super.initState();
    _astro = widget.astro;
    state = widget.userState;
    type = widget.userType;
    lang = widget.language;
    expert = widget.expertise;
    exp = widget.experience;
    descp = widget.description;
    _getLocation().then((position) {
      userLocation = position;
    });
  }

  updateLocation() {
    setState(() {
      locationLoading = true;
    });
    _getLocation().whenComplete(() {
      FireStoreDatabase(uid: widget.uid).updateData(data: {
        'location': addGeoPoint(),
      }).whenComplete(() {
        setState(() {
          locationLoading = false;
        });
        BotToast.showText(text: "Location is updated");
      });
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
        userProfilePicFile = cropped;
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
        userCoverPicFile = cropped;
        inProcess = false;
      });
    } else {
      this.setState(() {
        inProcess = false;
      });
    }
  }

  bool _validateAndSaveForm() {
    final form = _tFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    String nUserFirstName = widget.userFirstName;

    String nUserContactNumber = widget.userContactNumber;
    String nUserBio = widget.userBio;

    String nUserProfilePicUrl = widget.userProfilePicUrl;
    String nUserCoverPicUrl = widget.userCoverPicUrl;
    submitCoverPic() {
      _getLocation().whenComplete(() async {
        StorageReference reference = FirebaseStorage.instance
            .ref()
            .child('Users/${widget.uid}/coverPicFile');
        StorageUploadTask uploadTask = reference.putFile(userCoverPicFile);
        var downloadUrl =
            await (await uploadTask.onComplete).ref.getDownloadURL();
        var url = downloadUrl.toString();
        nUserCoverPicUrl = url;
      }).whenComplete(() {
        FireStoreDatabase(uid: widget.uid).updateData(data: {
          'coverpic': nUserCoverPicUrl,
        });
      });
    }

    submitProfilePic() {
      _getLocation().whenComplete(() async {
        StorageReference reference = FirebaseStorage.instance
            .ref()
            .child('Users/${widget.uid}/profilePicFile');
        StorageUploadTask uploadTask = reference.putFile(userProfilePicFile);
        var downloadUrl =
            await (await uploadTask.onComplete).ref.getDownloadURL();
        var url = downloadUrl.toString();
        nUserProfilePicUrl = url;
      }).whenComplete(() {
        FireStoreDatabase(uid: widget.uid).updateData(data: {
          'profilePicUrl': nUserProfilePicUrl,
        });
      }).whenComplete(() {
        Auth().updateUserphoto(nUserProfilePicUrl);
      });
    }

    int validatingAstro() {
      if (_astro) {
        if (chat != null && call != null && video != null) {
          return 1;
        } else {
          BotToast.showText(text: 'Please fill all sections of astrology');
          return 2;
        }
      }
      return 3;
    }

    _submit() {
      if (_validateAndSaveForm() && validatingAstro() != 2) {
        setState(() {
          loading = true;
        });
        if (userProfilePicFile != null) {
          submitProfilePic();
          Auth().updateUserphoto(nUserProfilePicUrl);
        }
        if (userCoverPicFile != null) {
          submitCoverPic();
        }
        if (_astro) {
          FireStoreDatabase(uid: widget.uid).updateData(data: {
            'call': call ?? widget.call,
            'chat': chat ?? widget.chat,
            'video': video ?? widget.video,
            'experience': exp,
            'expertise': expert,
            'language': lang,
            'description': descp,
            'astrologer': _astro,
          });
          FirebaseFirestore.instance
              .collection('Avaliable_pundit/${widget.uid}/astro')
              .doc('#astro')
              .set({
            'detail': descp ?? 'Not Available',
            'name': 'Astrology',
            'offer': descp ?? 'Not Available',
            'keyword': '#astro',
            'image':
                'https://assets.teenvogue.com/photos/5f31a0d6861f578bcc3baf40/16:9/w_2560%2Cc_limit/GettyImages-1192843057.jpg'
          });
        }
        Auth().updateUserName('$nUserFirstName');
        FireStoreDatabase(uid: widget.uid).updateData(data: {
          'firstName': capitalize(nUserFirstName),
          'location': addGeoPoint(),
          'aboutYou': nUserBio,
          'number': nUserContactNumber,
          'state': state,
          'type': type,
          'searchKey': nUserFirstName[0].toUpperCase().toString(),
        }).whenComplete(() {
          setState(() {
            loading = false;
          });
          Navigator.of(context).pop();
          BotToast.showText(text: "Your Profile has updated");
        });
      }
    }

    Widget _buildastro(bool astrologer) {
      return Card(
        child: Container(
            padding: EdgeInsets.all(10),
            width: 400,
            color: Colors.white,
            child: _astro
                ? Text(
                    'Update your Astrology Rates',
                    style: TextStyle(color: Colors.red),
                  )
                : CheckboxListTile(
                    title: Text('Are you an Astrologer'),
                    value: widget.astro,
                    onChanged: (value) {
                      setState(() {
                        _astro = value;
                      });
                    })),
      );
    }

    Widget _buildexp() {
      return Card(
        child: Container(
          padding: EdgeInsets.all(10),
          width: 400,
          color: Colors.white,
          child: TextFormField(
            initialValue: exp,
            decoration: InputDecoration(labelText: 'Experience'),
            maxLength: 30,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Experience is Required';
              }
              return null;
            },
            onSaved: (String value) {
              setState(() {
                exp = value;
              });
            },
          ),
        ),
      );
    }

    Widget _buildlang() {
      return Card(
        child: Container(
          padding: EdgeInsets.all(10),
          width: 400,
          color: Colors.white,
          child: TextFormField(
            initialValue: lang,
            decoration: InputDecoration(labelText: 'Language'),
            maxLength: 10,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Language is Required';
              }
              return null;
            },
            onSaved: (String value) {
              setState(() {
                lang = value;
              });
            },
          ),
        ),
      );
    }

    Widget _buildexpert() {
      return Card(
        child: Container(
          padding: EdgeInsets.all(10),
          width: 400,
          color: Colors.white,
          child: TextFormField(
            initialValue: expert,
            decoration: InputDecoration(labelText: 'Expertise'),
            maxLength: 10,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Expertise is Required';
              }
              return null;
            },
            onSaved: (String value) {
              setState(() {
                expert = value;
              });
            },
          ),
        ),
      );
    }

    Widget _builddesc() {
      return Card(
        child: Container(
          padding: EdgeInsets.all(10),
          width: 400,
          color: Colors.white,
          child: TextFormField(
            initialValue: descp,
            decoration: InputDecoration(
                labelText:
                    'Give some description about description and feature you offer to your client'),
            maxLength: 100,
            onSaved: (String value) {
              setState(() {
                descp = value;
              });
            },
          ),
        ),
      );
    }

    Widget _builcall() {
      return Container(
          padding: EdgeInsets.all(10),
          width: 400,
          color: Colors.white,
          child: DropdownButton<String>(
            elevation: 5,
            isExpanded: true,
            value: call,
            hint: widget.call == null
                ? Text('Select how much you charge for call per minute',
                    style: TextStyle(fontSize: 16))
                : Column(
                    children: [
                      Text('Call rate per min',
                          style: TextStyle(fontSize: 16, color: Colors.green)),
                      Text(widget.call, style: TextStyle(fontSize: 16)),
                    ],
                  ),
            items: <String>[
              '3',
              '5',
              '7',
            ].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                call = value;
              });
            },
          ));
    }

    Widget _builchat() {
      return Container(
          padding: EdgeInsets.all(10),
          width: 400,
          color: Colors.white,
          child: DropdownButton<String>(
            value: chat,
            isExpanded: true,
            hint: widget.chat == null
                ? Text('Select how much you charge for 10 text',
                    style: TextStyle(fontSize: 16))
                : Column(
                    children: [
                      Text('Text rate on 10 message',
                          style: TextStyle(fontSize: 16, color: Colors.green)),
                      Text(widget.chat, style: TextStyle(fontSize: 16)),
                    ],
                  ),
            items: <String>[
              '3',
              '5',
              '7',
            ].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                chat = value;
              });
            },
          ));
    }

    Widget _buildvideo() {
      return Container(
          padding: EdgeInsets.all(10),
          width: 400,
          color: Colors.white,
          child: DropdownButton<String>(
            value: video,
            isExpanded: true,
            hint: widget.video == null
                ? Text(
                    'Select how much you charge for video call per minute',
                    style: TextStyle(fontSize: 16),
                  )
                : Column(
                    children: [
                      Text('Video call rate on per min',
                          style: TextStyle(fontSize: 16, color: Colors.green)),
                      Text(
                        '${widget.video}',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
            items: <String>[
              '3',
              '5',
              '7',
            ].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                video = value;
              });
            },
          ));
    }

    return Scaffold(
      //backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text('Edit Your Profile'),
        centerTitle: true,
        actions: [
          loading
              ? SizedBox()
              : FlatButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _tFormKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              getCoverPic(source: ImageSource.gallery);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.pink,
                                child: userCoverPicFile == null
                                    ? nUserCoverPicUrl == null
                                        ? Image.asset(
                                            'images/placeholder.jpg',
                                          )
                                        : Image.network(
                                            nUserCoverPicUrl,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context,
                                                Widget child,
                                                ImageChunkEvent
                                                    loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                          )
                                    : Image.file(
                                        userCoverPicFile,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 100,
                            left: ((MediaQuery.of(context).size.width * 0.5) -
                                80),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  getProfilePic(source: ImageSource.gallery);
                                },
                                child: CircularProfileAvatar(
                                  'G',
                                  animateFromOldImageOnUrlChange: true,
                                  child: userProfilePicFile == null
                                      ? nUserProfilePicUrl == null
                                          ? Image.asset(
                                              'images/placeholder.jpg',
                                            )
                                          : Image.network(
                                              nUserProfilePicUrl,
                                              loadingBuilder: (context,
                                                  Widget child,
                                                  ImageChunkEvent
                                                      loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                            )
                                      : Image.file(userProfilePicFile),
                                  radius: 80,
                                  borderWidth: 1,
                                  borderColor: Colors.white,
                                  elevation: 4,
                                ),
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
                      Divider(
                        thickness: 1,
                        color: Colors.deepOrange[100],
                      ),
                      Text(
                          'Tap to update your current location so that people can easily find you in their nearby location'),
                      SizedBox(
                        height: 20,
                      ),
                      locationLoading
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
                      /////////////////////////////FIRST NAME////////////////////
                      Divider(
                        thickness: 1,
                        color: Colors.deepOrange[100],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 400,
                          height: 100,
                          color: Colors.white,
                          child: TextFormField(
                            initialValue: nUserFirstName,
                            decoration:
                                InputDecoration(labelText: 'First name'),
                            maxLength: 35,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'First name is Required';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              setState(() {
                                nUserFirstName = value;
                              });
                            },
                          ),
                        ),
                      ),
                      ////////////////////LAST NAME/////////////

                      ////////////////CONTACT NUMBER//////////////
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 400,
                          height: 100,
                          color: Colors.white,
                          child: TextFormField(
                            initialValue: nUserContactNumber,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: 'Contact number'),
                            maxLength: 10,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Contact number is required';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              setState(() {
                                nUserContactNumber = value;
                              });
                            },
                          ),
                        ),
                      ),
                      ////////////////////////////ABOUT YOU///////////////////////////
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 400,
                          height: 100,
                          color: Colors.white,
                          child: TextFormField(
                            initialValue: nUserBio,
                            decoration: InputDecoration(labelText: 'About you'),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'About you can\'t be empty';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              setState(() {
                                nUserBio = value;
                              });
                            },
                          ),
                        ),
                      ),

                      Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select your state",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 400,
                              height: 100,
                              color: Colors.white,
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: FireStoreDatabase(uid: widget.uid)
                                      .getStates,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    List<dynamic> statesArray =
                                        snapshot.data.data()['states'];
                                    print(
                                        'now showing ${snapshot.data.data()['1']} ${snapshot.data.data()['2']} ${snapshot.data.data()['3']}');
                                    print(
                                        'statesArray.... ......... $statesArray');
                                    List<DropdownMenuItem<String>> statesList =
                                        [];
                                    for (int i = 0;
                                        i < statesArray.length;
                                        i++) {
                                      String name = statesArray[i];
                                      statesList.add(DropdownMenuItem(
                                        value: name,
                                        child: Text(name),
                                      ));
                                    }
                                    return SearchableDropdown.single(
                                      items: statesList,
                                      isExpanded: true,
                                      //icon: Icon(Icons.description),
                                      displayClearIcon: false,
                                      hint: "$state",
                                      //underline: false,
                                      searchHint: "Select One",
                                      onChanged: (String value) {
                                        setState(() {
                                          state = value;
                                        });
                                      },
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )),
                      /* Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 400,
                          height: 100,
                          color: Colors.white,
                          child: TextFormField(
                            initialValue: nUserLastName,
                            decoration: InputDecoration(labelText: 'City'),
                            maxLength: 20,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'City is Required';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              setState(() {
                                nUserLastName = value;
                              });
                            },
                          ),
                        ),
                      ),*/
                      Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select type",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 400,
                              height: 100,
                              color: Colors.white,
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: FireStoreDatabase(uid: widget.uid)
                                      .getPunditTypes,
                                  builder: (context, snapshot1) {
                                    if (snapshot1.data == null) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    List<dynamic> typeArray =
                                        snapshot1.data.data()['punditTypes'];
                                    print(
                                        'now showing ${snapshot1.data.data()['1']} ${snapshot1.data.data()['2']} ${snapshot1.data.data()['3']}');
                                    print(
                                        'statesArray.... ......... $typeArray');
                                    List<DropdownMenuItem<String>> typeList =
                                        [];
                                    for (int i = 0; i < typeArray.length; i++) {
                                      String name = typeArray[i];
                                      typeList.add(DropdownMenuItem(
                                        value: name,
                                        child: Text(name),
                                      ));
                                    }
                                    return SearchableDropdown.single(
                                      items: typeList,
                                      isExpanded: true,
                                      //icon: Icon(Icons.description),
                                      displayClearIcon: false,
                                      hint: "$type",
                                      //underline: false,
                                      searchHint: "Select One",
                                      onChanged: (String value) {
                                        setState(() {
                                          type = value;
                                        });
                                      },
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Astrology',
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      _buildastro(_astro),
                      _astro ? _builchat() : SizedBox(),
                      _astro ? _builcall() : SizedBox(),
                      _astro ? _buildvideo() : SizedBox(),
                      _astro ? _buildlang() : SizedBox(),
                      _astro ? _buildexp() : SizedBox(),
                      _astro ? _buildexpert() : SizedBox(),
                      _astro ? _builddesc() : SizedBox(),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Adhaar details are required in order to verify your account to protect our community from spams.'),
                      SizedBox(
                        height: 15,
                      ),
                      ProfileButtons(
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
                      SizedBox(
                        height: 30,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(height: 30),
                      Text(
                          'Bank details will be required in order to get rewards and and payments from your jajmaan '),
                      SizedBox(height: 15),
                      ProfileButtons(
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
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
