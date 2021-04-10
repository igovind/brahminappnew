import 'dart:io';
import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


bool loading = false;

class EditAdhaarDetails extends StatefulWidget {
  final adhaarName;
  final adhaarNumber;
  final address;
  final uid;
  final frontAdhaarUrl;
  final backAdhaarUrl;
  final check;

  const EditAdhaarDetails({
    Key key,
    this.adhaarName,
    this.adhaarNumber,
    this.address,
    @required this.uid,
    this.frontAdhaarUrl,
    this.backAdhaarUrl, this.check,
  }) : super(key: key);

  @override
  _EditAdhaarDetailsState createState() => _EditAdhaarDetailsState();
}

class _EditAdhaarDetailsState extends State<EditAdhaarDetails> {
  final _tMformKey = GlobalKey<FormState>();
  String _name;
  String _adhaarNumber;
  String _address;
  File _frontAdhaarFile;
  String _frontAdhaarUrl;
  File _backAdhaarFile;
  String _backAdhaarUrl;
  bool inProcess = false;

  bool _validateAndSaveForm() {
    final form = _tMformKey.currentState;

    if (form.validate() &&
        (_frontAdhaarFile != null || _frontAdhaarUrl != null) &&
        (_backAdhaarFile != null || _backAdhaarUrl != null)) {
      form.save();

      return true;
    }
    return false;
  }

  getbackAdhaarPic({ImageSource source}) async {
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
        _backAdhaarFile = cropped;
        inProcess = false;
      });
    } else {
      this.setState(() {
        inProcess = false;
      });
    }
  }

  getAdhaarFrontPic({ImageSource source}) async {
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
        _frontAdhaarFile = cropped;
        inProcess = false;
      });
    } else {
      this.setState(() {
        inProcess = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        Future.delayed(Duration(milliseconds: 10)).whenComplete(() async {
          if (_backAdhaarFile != null) {
            StorageReference reference = FirebaseStorage.instance
                .ref()
                .child('Users/${widget.uid}/backAdhaar');
            StorageUploadTask uploadTask = reference.putFile(_backAdhaarFile);
            var downloadUrl =
                await (await uploadTask.onComplete).ref.getDownloadURL();
            var url = downloadUrl.toString();
            _backAdhaarUrl = url;
            print('eirj $_backAdhaarUrl');
          }
        }).whenComplete(() async {
          if (_frontAdhaarFile != null) {
            StorageReference referencet = FirebaseStorage.instance
                .ref()
                .child('Users/${widget.uid}/frontadhaar');
            StorageUploadTask uploadTaskt =
                referencet.putFile(_frontAdhaarFile);
            var downloadUrlt =
                await (await uploadTaskt.onComplete).ref.getDownloadURL();
            var urlt = downloadUrlt.toString();

            _frontAdhaarUrl = urlt;
            print('eir $_frontAdhaarUrl');
          }
        }).whenComplete(() {
          if (widget.address == null) {
            FirebaseFirestore.instance
                .doc(
                    'punditUsers/${widget.uid}/user_profile/user_adhaar_details')
                .set({
              'name': _name,
              'adhaarNumber': _adhaarNumber,
              'address': _address,
              'frontAdhaarPicUrl': _frontAdhaarUrl,
              'backAdhaarPicUrl': _backAdhaarUrl,
            });
          } else {
            FirebaseFirestore.instance
                .doc(
                    'punditUsers/${widget.uid}/user_profile/user_adhaar_details')
                .update({
              'name': _name,
              'adhaarNumber': _adhaarNumber,
              'address': _address,
              'frontAdhaarPicUrl': _frontAdhaarUrl,
              'backAdhaarPicUrl': _backAdhaarUrl,
            });
          }
        });
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
      if (widget.address != null) {
        Navigator.of(context).pop();
      }
      if (widget.check == null) {
        FireStoreDatabase(uid: widget.uid).updateData(data: {"ready": true});
      }
    } else {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Incomplete details'),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _frontAdhaarUrl = widget.frontAdhaarUrl;
    _backAdhaarUrl = widget.backAdhaarUrl;
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

   /* double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }*/

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: height(30),
        actions: [
          widget.check != null
              ? FlatButton(
                  onPressed: () {
                    FireStoreDatabase(uid: widget.uid)
                        .updateData(data: {"ready": true});
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.bold),
                  ))
              : SizedBox(),
          FlatButton(
            onPressed: () {
              _submit();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 3)],
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "save",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _tMformKey,
            child: Column(
              children: [
                Text("Adhaar details"),
                SizedBox(
                  height:  height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Your name as per Adhaar '),
                    initialValue: widget.adhaarName,
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Name can\'t be empty',
                    onSaved: (value) => _name = value,
                  ),
                ),
                SizedBox(
                  height:  height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Permanent address'),
                    initialValue: widget.address,
                    keyboardType: TextInputType.name,
                    validator: (value) => value.isNotEmpty
                        ? null
                        : 'Address name can\'t be empty',
                    onSaved: (value) => _address = value,
                  ),
                ),
                SizedBox(
                  height:  height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: TextFormField(
                    maxLength: 16,
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: 'Adhaar number'),
                    initialValue: widget.adhaarNumber,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) => value.isNotEmpty
                        ? null
                        : value.length != 16
                            ? 'It must be of 16 numbers'
                            : 'Adhaar number can\'t be empty',
                    onSaved: (value) => _adhaarNumber = value,
                  ),
                ),
                SizedBox(
                  height:  height(50),
                ),
                CustomContainer(
                  radius: 10,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Please upload your adhaar(front side)',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(
                        height:  height(12),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MagicScreen(width: 360, context: context)
                              .getWidth,
                          height: MagicScreen(height: 200, context: context)
                              .getHeight,
                          child: _frontAdhaarFile == null
                              ? _frontAdhaarUrl == null
                                  ? Center(
                                      child: Text(
                                        'Add image',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Image.network(
                                      _frontAdhaarUrl,
                                      fit: BoxFit.fill,
                                    )
                              : Image.file(
                                  _frontAdhaarFile,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {
                                getAdhaarFrontPic(
                                  source: ImageSource.gallery,
                                );
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {
                                getAdhaarFrontPic(
                                  source: ImageSource.camera,
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height:  height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Please upload your adhaar(back)',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(
                        height:  height(12),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                          ),
                          width: MagicScreen(width: 360, context: context)
                              .getWidth,
                          height: MagicScreen(height: 200, context: context)
                              .getHeight,
                          child: _backAdhaarFile == null
                              ? _backAdhaarUrl == null
                                  ? Center(
                                      child: Text(
                                        'Add image',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : Image.network(
                                      _backAdhaarUrl,
                                      fit: BoxFit.fill,
                                    )
                              : Image.file(
                                  _backAdhaarFile,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {
                                getbackAdhaarPic(
                                  source: ImageSource.gallery,
                                );
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {
                                getbackAdhaarPic(
                                  source: ImageSource.camera,
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
