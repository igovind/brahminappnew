import 'dart:io';
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/create_profile/edit_astrology_form.dart';
import 'package:brahminapp/common_widgets/CustomSearchableDropdown.dart';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'account_page.dart';

class EditProfile extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot> snapshot;
  final uid;

  const EditProfile({Key key, this.snapshot, this.uid}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File userProfilePicFile;
  File userCoverPicFile;
  bool inProcess = false;
  bool loading = false;
  String fullName;
  String aboutYou;
  String state;
  String city;
  String contact;
  String profilePicUrl;
  String coverPicUrl;
  String punditType;
  final _sTFormKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _sTFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<String> submitCoverPic() async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('Users/${widget.uid}/coverPicFile');
    StorageUploadTask uploadTask = reference.putFile(userCoverPicFile);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    coverPicUrl = url;
    return downloadUrl.toString();
  }

  Future<String> submitProfilePic() async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('Users/${widget.uid}/profilePicFile');
    StorageUploadTask uploadTask = reference.putFile(userProfilePicFile);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    profilePicUrl = url;
    return downloadUrl.toString();
  }

  _submit() async {
    if (_validateAndSaveForm()) {
      setState(() {
        loading = true;
      });
      if (userProfilePicFile != null) {
        profilePicUrl = await submitProfilePic();
      } else {
        profilePicUrl = UserDetails(snapshot: widget.snapshot).profilePhoto;
      }
      if (userCoverPicFile != null) {
        coverPicUrl = await submitCoverPic();
      } else {
        coverPicUrl = UserDetails(snapshot: widget.snapshot).coverPhoto;
      }
      FireStoreDatabase(uid: widget.uid).updateData(data: {
        'profilePicUrl': profilePicUrl ??
            UserDetails(snapshot: widget.snapshot).profilePhoto,
        'coverpic':
            coverPicUrl ?? UserDetails(snapshot: widget.snapshot).coverPhoto,
        'firstName': fullName ?? UserDetails(snapshot: widget.snapshot).name,
        'aboutYou': aboutYou ?? UserDetails(snapshot: widget.snapshot).aboutYou,
        'number': contact ?? UserDetails(snapshot: widget.snapshot).aboutYou,
        'state': state ?? UserDetails(snapshot: widget.snapshot).state,
        'type': punditType ?? UserDetails(snapshot: widget.snapshot).type,
        'searchKey': fullName == null
            ? UserDetails(snapshot: widget.snapshot).name[0]
            : fullName[0].toUpperCase().toString(),
        'lastName': city ?? UserDetails(snapshot: widget.snapshot).city,
      }).whenComplete(() {
        setState(() {
          loading = false;
        });
      }).whenComplete(() {
        Navigator.of(context).pop();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 30,
          actions: [
            loading
                ? SizedBox()
                : FlatButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black54, blurRadius: 3)
                          ],
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                  )
          ],
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _sTFormKey,
                  child: Column(
                    children: [
                      Container(
                        height:
                            MagicScreen(height: 260, context: context).getHeight,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                getCoverPic(source: ImageSource.gallery);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 15),
                                height:
                                    MagicScreen(height: 200, context: context)
                                        .getHeight,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black54, blurRadius: 5)
                                    ],
                                    image: DecorationImage(
                                        image: userCoverPicFile == null
                                            ? UserDetails(
                                                            snapshot:
                                                                widget.snapshot)
                                                        .coverPhoto ==
                                                    null
                                                ? NetworkImage(
                                                    "https://cdn.safetyskills.com/wp-content/uploads/2016/08/18115356/person-placeholder.jpg")
                                                : NetworkImage(UserDetails(
                                                        snapshot:
                                                            widget.snapshot)
                                                    .coverPhoto)
                                            : FileImage(userCoverPicFile),
                                        fit: BoxFit.fitWidth),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25))),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CircularProfileAvatar(
                                "",
                                child: userProfilePicFile == null
                                    ? Image.network(
                                        UserDetails(snapshot: widget.snapshot)
                                            .profilePhoto)
                                    : Image.file(userProfilePicFile),
                                radius:
                                    MagicScreen(context: context, height: 60)
                                        .getHeight,
                                elevation: 8,
                                onTap: () {
                                  getProfilePic(source: ImageSource.gallery);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MagicScreen(context: context, height: 10)
                              .getHeight),
                      CustomContainer(
                        radius: 10,
                        child: TextFormField(
                            maxLength: 30,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                border: InputBorder.none,
                                labelText: "Your full name"),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            initialValue:
                                "${UserDetails(snapshot: widget.snapshot).name}",
                            onSaved: (value) {
                              setState(() {
                                fullName = value;
                              });
                            } //_benefits = value,
                            ),
                      ),
                      SizedBox(
                          height: MagicScreen(context: context, height: 10)
                              .getHeight),
                      CustomContainer(
                        radius: 10,
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                border: InputBorder.none,
                                labelText: "Contact number"),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            initialValue:
                                "${UserDetails(snapshot: widget.snapshot).contact}",
                            onSaved: (value) {
                              setState(() {
                                contact = value;
                              });
                            } //_benefits = value,
                            ),
                      ),
                      SizedBox(
                          height: MagicScreen(context: context, height: 10)
                              .getHeight),
                      CustomContainer(
                        radius: 10,
                        child: TextFormField(
                            maxLength: 100,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                border: InputBorder.none,
                                labelText: "About you"),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            initialValue:
                                "${UserDetails(snapshot: widget.snapshot).aboutYou}",
                            onSaved: (value) {
                              setState(() {
                                aboutYou = value;
                              });
                            } //_benefits = value,
                            ),
                      ),
                      SizedBox(
                          height: MagicScreen(context: context, height: 10)
                              .getHeight),
                      CustomContainer(
                          radius: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
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
                                      'statesArray.... ......... $statesArray');
                                  List<DropdownMenuItem<String>> statesList =
                                      [];
                                  for (int i = 0; i < statesArray.length; i++) {
                                    String name = statesArray[i];
                                    statesList.add(DropdownMenuItem(
                                      value: name,
                                      child: Text(name),
                                    ));
                                  }
                                  return CustomSearchableDropdown.single(
                                    key: UniqueKey(),
                                    validator: (String value) {
                                      value = value == null
                                          ? UserDetails(
                                                  snapshot: widget.snapshot)
                                              .state
                                          : value;
                                      if (value == null) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    underline: SizedBox(),
                                    icon: Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    items: statesList,

                                    label: "Select your state",
                                    lableColor: Colors.black54,
                                    isExpanded: true,
                                    //icon: Icon(Icons.description),
                                    displayClearIcon: false,
                                    hint: state ??
                                        "${UserDetails(snapshot: widget.snapshot).state}",
                                    //underline: false,
                                    searchHint: "Select One",
                                    onChanged: (String value) {
                                      setState(() {
                                        state = value;
                                      });
                                    },
                                  );
                                }),
                          )),
                      SizedBox(
                          height: MagicScreen(context: context, height: 10)
                              .getHeight),
                      CustomContainer(
                        radius: 10,
                        child: TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                border: InputBorder.none,
                                labelText: "Your city"),
                            initialValue:
                                "${UserDetails(snapshot: widget.snapshot).city}",
                            onSaved: (value) {
                              setState(() {
                                city = value;
                              });
                            } //_benefits = value,
                            ),
                      ),
                      SizedBox(
                          height: MagicScreen(context: context, height: 10)
                              .getHeight),
                      CustomContainer(
                        radius: 10,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
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
                                List<DropdownMenuItem<String>> typeList = [];
                                for (int i = 0; i < typeArray.length; i++) {
                                  String name = typeArray[i];
                                  typeList.add(DropdownMenuItem(
                                    value: name,
                                    child: Text(name),
                                  ));
                                }
                                return CustomSearchableDropdown.single(
                                  disabledHint: true,
                                  validator: (String value) {
                                    value = value == null
                                        ? UserDetails(snapshot: widget.snapshot)
                                            .type
                                        : value;
                                    if (value == null) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                  label: "Select pundit type",
                                  lableColor: Colors.black54,
                                  icon: Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                  underline: SizedBox(),
                                  items: typeList,

                                  isExpanded: true,
                                  //icon: Icon(Icons.description),
                                  displayClearIcon: false,
                                  hint: punditType ??
                                      "${UserDetails(snapshot: widget.snapshot).type}",
                                  //underline: false,
                                  searchHint: "Select One",
                                  onChanged: (String value) {
                                    setState(() {
                                      punditType = value;
                                    });
                                  },
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.deepOrangeAccent,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      UserDetails(snapshot: widget.snapshot).astrologer
                          ? SizedBox()
                          : AccountTile(
                              title: "Switch to astrology account",
                              height: MagicScreen(context: context, height: 630)
                                  .getHeight,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditAstrologyForm(uid: widget.uid,)));
                              },
                            )
                    ],
                  ),
                ),
              ));
  }
}