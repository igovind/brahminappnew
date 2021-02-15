import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/my_account/edit_adhaar_details.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/my_account/profile_buttons.dart';
import 'package:brahminapp/common_widgets/platform_alert_dialog.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import '../edit_bank_details.dart';

bool inProcess = false;
bool working = false;
bool astro=false;
String descp='';
File profilePicFile;
String fName = '';
String lName = '';
String aboutYou = '';
String punditType = 'Pundit type';
String state = 'state';
String profilePicUrl;
String pujaPicUrl = 'url';
bool verified = false;
File pujaPicFile;
String coverPicUrl;
double swastika;
File coverPicFile;
String number;
bool _added;
DateTime dateOfBirth;
Geoflutterfire geo = Geoflutterfire();
GeolocatorPlatform geoLocator = GeolocatorPlatform.instance;
String exp;
String lang;
String expert;
final FirebaseMessaging _messaging = FirebaseMessaging();

Position userLocation;
String tokens;

Future<void> _signOut(context) async {
  try {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.signOut();
  } catch (e) {
    print(e.toString());
  }
}

Future<void> _confirmSignOut(context) async {
  final didRequestSignOut = await PlatformAlertDialog(
    title: 'Logout',
    content: 'Are you sure that you want to logout?',
    cancelActionText: 'Cancel',
    defaultActionText: 'Logout',
  ).show(context);
  if (didRequestSignOut == true) {
    _signOut(context);
  }
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

class EditProfilePage extends StatefulWidget {
  final uid;
  final bool added;

  const EditProfilePage({Key key, @required this.uid, this.added})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

addGeoPoint() {
  if (userLocation == null) {
    return null;
  }
  GeoFirePoint point = geo.point(
      latitude: userLocation.latitude, longitude: userLocation.longitude);
  return point.data;
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool loading = false;
  String chat;
  String video;
  String call;
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

  final GlobalKey<FormState> _formKeyE = GlobalKey<FormState>();
  bool adharSub = false;
  bool bankSub = false;

  Widget _finalSubmit() {
   return FlatButton(
     child: Text(
       'Submit',
       style: TextStyle(color: Colors.white, fontSize: 18),
     ),
     onPressed: () {
       if (_formKeyE.currentState.validate() &&
           (profilePicFile != null) &&
           (coverPicFile != null) &&
           punditType != 'Pundit type') {
         _formKeyE.currentState.save();
         setState(() {
           loading = true;
         });
         _getLocation().whenComplete(() async {
           StorageReference reference = FirebaseStorage.instance
               .ref()
               .child('Users/${widget.uid}/ProfilePic');
           StorageUploadTask uploadTask = reference.putFile(profilePicFile);
           var downloadUrl =
           await (await uploadTask.onComplete).ref.getDownloadURL();
           var url = downloadUrl.toString();
           profilePicUrl = url;
           print(
               'nefjierhfewirnfiuoerhfijwqfi  //////////profile/////////$profilePicUrl');
         }).whenComplete(() async {
           Auth().updateUser(fName , profilePicUrl);
         }).whenComplete(() async {
           StorageReference reference = FirebaseStorage.instance
               .ref()
               .child('Users/${widget.uid}/coverPicFile');
           StorageUploadTask uploadTask = reference.putFile(coverPicFile);
           var downloadUrl =
           await (await uploadTask.onComplete).ref.getDownloadURL();
           var url = downloadUrl.toString();
           coverPicUrl = url;
           print(
               'nefjierhfewirnfiuoerhfijwqfi  //////////cover/////////$coverPicUrl');
         }).whenComplete(() {
           FireStoreDatabase(uid: widget.uid).setData(data: {
             'experience':exp,
             'expertise':expert,
             'language':lang,
             'call':call??'0.1',
             'video':video??'0.1',
             'chat':chat??'0.1',
             'astrologer':astro,
             'firstName': fName,
             'location': addGeoPoint(),
             'token': tokens,
             'setReward': 0,
             'setPrice': 0.0,
             'lastName': lName,
             'aboutYou': aboutYou,
             'profilePicUrl': profilePicUrl,
             'pujaPicUrl': pujaPicUrl,
             'uid': widget.uid,
             'coverpic': coverPicUrl,
             'state': state,
             'dateOfBirth': 'no',
             'type': punditType,
             'swastik': 0.0,
             'verified': verified,
             'searchKey': fName[0].toString(),
             'number': number,
             'PujaKeywords': '#'
           });
         }).whenComplete(()async{
         await  FirebaseFirestore.instance.collection('Avaliable_pundit/${widget.uid}/astro').doc('#astro').set({
             'detail':descp??'Not Available',
             'name':'Astrology',
             'offer':descp??'Not Available',
             'keyword':'#astro',
             'image':'https://assets.teenvogue.com/photos/5f31a0d6861f578bcc3baf40/16:9/w_2560%2Cc_limit/GettyImages-1192843057.jpg'
           });
         });

         print(
             'nefjierhfewirnfiuoerhfijwqfi  //////////profile/////////$profilePicUrl');
         print(
             'nefjierhfewirnfiuoerhfijwqfi  //////////cover/////////$coverPicUrl');
         print(
             'linkes................///////////112324r43t54........... $pujaPicUrl ,$profilePicUrl ,$coverPicUrl');

         setState(() {
           loading = true;
         });

         FirebaseFirestore.instance
             .doc('punditUsers/${widget.uid}/newsFeed/initialNotification')
             .set({
           'title': 'Gallery Update',
           'subtitle': 'Please update your gallery',
           'date': FieldValue.serverTimestamp(),
         });
         FirebaseFirestore.instance
             .doc('punditUsers/${widget.uid}/newsFeed/initialNotification2')
             .set({
           'title': 'Profile verification',
           'subtitle': 'Please wait for your profile verification',
           'description':
           'Our employees will verify you and will call uh on your contact number after this process you will be verified profile in puja purohit ',
           'date': FieldValue.serverTimestamp(),
         });
       } else {
         if(astro ==true && chat==null && call==null && video==null){
           showDialog(
               context: context,
               child: AlertDialog(
                 title: Text('Astrology'),
                 content: Text('Kindly fill your rates in astrology section'),
               ));
         }
         if (profilePicFile == null) {
           showDialog(
               context: context,
               child: AlertDialog(
                 title: Text('Incomplete details'),
                 content: Text('Please upload your profile picture'),
               ));
         }
         if (coverPicFile == null) {
           showDialog(
               context: context,
               child: AlertDialog(
                 title: Text('Incomplete details'),
                 content: Text('Please upload your Cover pic'),
               ));
         }

         if (punditType == 'Pundit type') {
           showDialog(
               context: context,
               child: AlertDialog(
                 title: Text('Incomplete details'),
                 content: Text('Please provide your type'),
               ));
         }

       }
     },
   );
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
        color: Colors.white,
        child: TextFormField(
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
        color: Colors.white,
        child: TextFormField(
          initialValue: number,
          decoration: InputDecoration(labelText: 'Contact number',prefixText: '+91'),
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
Widget _buildastro(){
    return Card(
    child: Container(
      padding: EdgeInsets.all(10),
      width: 400,
      color: Colors.white,
      child: CheckboxListTile(title: Text('Are you an Astrologer '),value: astro, onChanged: (value){
        setState(() {
          astro=value;
        });
        }
      )
    ),
  );
}
  Widget _builcall(){
    return Container(
        padding: EdgeInsets.all(10),
        width: 400,
        color: Colors.white,
        child: DropdownButton<String>(
          elevation: 5,
          isExpanded: true,
          value: call,
          hint: call == null ? Text('Select how much you charge for call per minute',style: TextStyle(fontSize: 10)):
          Text(call,style: TextStyle(fontSize: 10)),
          items: <String>['3', '5', '7',].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              call=value;
            });
          },
        )
    );
  }
  Widget _builchat(){
    return Container(
        padding: EdgeInsets.all(10),
        width: 400,
        color: Colors.white,
        child: DropdownButton<String>(
          value: chat,
          isExpanded: true,
          hint: chat == null?Text('Select how much you charge for 10 text',style: TextStyle(fontSize: 10)):
          Text(chat,style: TextStyle(fontSize: 10)),
          items: <String>['3', '5', '7',].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              chat=value;
            });
          },
        )
    );
  }
  Widget _buildvideo(){
    return Container(
        padding: EdgeInsets.all(10),
        width: 400,
        color: Colors.white,

        child: DropdownButton<String>(
          value: video,
          isExpanded: true,
          hint: Text('Select how much you charge for video call per minute',style: TextStyle(fontSize: 10),),
          items: <String>['3', '5', '7',].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              video=value;
            });
          },
        )
    );
  }
 Widget _buildLastName() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        color: Colors.white,
        child: TextFormField(
          initialValue: lName,
          decoration: InputDecoration(labelText: 'City'),
          maxLength: 10,
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
  Widget _buildexp() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        color: Colors.white,
        child: TextFormField(
          initialValue: lName,
          decoration: InputDecoration(labelText: 'Experience'),
          maxLength: 10,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Experience is Required';
            }
            return null;
          },
          onSaved: (String value) {
            setState(() {
              exp= value;
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
          initialValue: lName,
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
          initialValue: lName,
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

          decoration: InputDecoration(labelText: 'Give some description about description and feature you offer to your client'),
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
  Widget _buildAboutYou() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        color: Colors.white,
        child: TextFormField(
          initialValue: aboutYou,
          maxLength: 100,
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

/*  Widget _buildState() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        color: Colors.white,
        child: TextFormField(
          initialValue: state,
          decoration: InputDecoration(labelText: 'State'),
          validator: (String value) {
            if (value.isEmpty) {
              return 'State is Required';
            }

            return null;
          },
          onSaved: (String value) {
            setState(() {
              state = value;
            });
          },
        ),
      ),
    );
  }*/
  Widget _buildNewState() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        height: 100,
        color: Colors.white,
        child: StreamBuilder<DocumentSnapshot>(
            stream: FireStoreDatabase(uid: widget.uid).getStates,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<dynamic> statesArray = snapshot.data.data()['states'];
              print(
                  'now showing ${snapshot.data.data()['1']} ${snapshot.data.data()['2']} ${snapshot.data.data()['3']}');
              print('statesArray.... ......... $statesArray');
              List<DropdownMenuItem<String>> statesList = [];
              for (int i = 0; i < statesArray.length; i++) {
                String name = statesArray[i];
                statesList.add(DropdownMenuItem(
                  value: name,
                  child: Text(name),
                ));
              }

              return SearchableDropdown.single(
                hint: Text("$state"),
                items: statesList,
                displayClearIcon: false,
                isExpanded: true,
                /*[
                      DropdownMenuItem(
                          value: "Banarasi", child: Text('Banarasi')),
                      DropdownMenuItem(
                          value: "Maithali", child: Text('Maithali'))
                    ],*/
                onChanged: (String value) {
                  if(value!=null){
                    setState(() {
                    state = value;
                  });
                  }

                },
              );
            }),
      ),
    );
  }

  Widget _buildType() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 400,
        height: 100,
        color: Colors.white,
        child: StreamBuilder<DocumentSnapshot>(
            stream: FireStoreDatabase(uid: widget.uid).getPunditTypes,
            builder: (context, snapshot1) {
              if (snapshot1.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<dynamic> typeArray = snapshot1.data.data()['punditTypes'];
              List<DropdownMenuItem<String>> listItem = [];
              for (int i = 0; i < typeArray.length; i++) {
                String name = typeArray[i];
                listItem.add(DropdownMenuItem(
                  value: name,
                  child: Text(name),
                ));
                print('ghhgghghghghghghghghghgh $name');
              }
              return SearchableDropdown.single(
                hint: Text("$punditType"),
                isExpanded: true,
                items: listItem,
                displayClearIcon: false,
                /*[
                      DropdownMenuItem(
                          value: "Banarasi", child: Text('Banarasi')),
                      DropdownMenuItem(
                          value: "Maithali", child: Text('Maithali'))
                    ],*/
                onChanged: (String value) {
                  if(value!=null){
                    setState(() {
                    punditType = value;
                  });
                  }
                },
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _added = widget.added;
    return WillPopScope(
      onWillPop: () async {
        profilePicFile = null;
        pujaPicFile = null;
        coverPicFile = null;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          toolbarHeight: 120,
          leading: IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              _confirmSignOut(context);
            },
          ),
          title: Text(
            'Create profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: <Widget>[
            // buildSubmit(),
            loading ? SizedBox() : _finalSubmit()
          ],
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
            return loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKeyE,
                        child: Center(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.pink,
                                    child: coverPicFile == null
                                        ? (coverPicUrl == null
                                            ? Image.asset(
                                                'images/newback.jpg',
                                                fit: BoxFit.cover,
                                              )
                                            : netImg(coverPicUrl))
                                        : Image.file(
                                            coverPicFile,
                                            fit: BoxFit.fitWidth,
                                          ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      //padding: EdgeInsets.all(),
                                      color: Color(0XFFffbd59),
                                      child: IconButton(
                                          color: Colors.white,
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            getCoverPic(
                                                source: ImageSource.gallery);
                                          }),
                                    ),
                                  ),
                                  Positioned(
                                    top: 100,
                                    left: ((MediaQuery.of(context).size.width *
                                            0.5) -
                                        120),
                                    child: Column(
                                      children: [
                                        CircularProfileAvatar(
                                          '',
                                          child: profilePicFile == null
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
                                              IconButton(
                                                  icon: Icon(Icons.camera),
                                                  iconSize: 30,
                                                  color: Color(0XFFffbd59),
                                                  onPressed: () =>
                                                      getProfilePic(
                                                        source:
                                                            ImageSource.camera,
                                                      )),
                                              IconButton(
                                                  icon: Icon(Icons.photo),
                                                  iconSize: 30,
                                                  color: Color(0XFFffbd59),
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
                                    height: 300,
                                  )
                                ],
                              ),
                              _buildFirstName(),
                              _buildNumber(),
                              _buildAboutYou(),
                              _buildType(),
                              //_buildState(),
                              _buildNewState(),
                              _buildLastName(),
                              _buildastro(),
                              astro?_builchat():SizedBox(),
                              astro?_builcall():SizedBox(),
                              astro?_buildvideo():SizedBox(),
                              astro?_buildexp():SizedBox(),
                              astro?_buildlang():SizedBox(),
                              astro?_buildexpert():SizedBox(),
                              astro?_builddesc():SizedBox(),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              /*ProfileButtons(
                                icon: Icon(Icons.account_balance),
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
                                      } else {
                                        bankSub = true;
                                      }
                                      return EditBankDetails(
                                        uid: widget.uid,
                                        bankName:
                                            snapshot1.data.data()['bankName'],
                                        name: snapshot1.data.data()['name'],
                                        accountNumber: snapshot1.data
                                            .data()['accountNumber'],
                                        ifscCode: snapshot1.data.data()['IFSC'],
                                      );
                                    }),
                                title: 'Bank details',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ProfileButtons(
                                icon: Icon(Icons.insert_drive_file),
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
                                      } else {
                                        adharSub = true;
                                      }
                                      return EditAdhaarDetails(
                                        uid: widget.uid,
                                        added: true,
                                        address:
                                            snapshot.data.data()['address'],
                                        adhaarName:
                                            snapshot.data.data()['name'],
                                        adhaarNumber: snapshot.data
                                            .data()['adhaarNumber'],
                                        frontAdhaarUrl: snapshot.data
                                            .data()['frontAdhaarPicUrl'],
                                        backAdhaarUrl: snapshot.data
                                            .data()['backAdhaarPicUrl'],
                                      );
                                    }),
                                title: 'Adhaar details',
                              ),*/
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
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
