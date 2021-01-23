import 'dart:io';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
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
  final bool added;

  static bool adhaarDone = false;

  const EditAdhaarDetails(
      {Key key,
      this.adhaarName,
      this.adhaarNumber,
      this.address,
      @required this.uid,
      this.frontAdhaarUrl,
      this.backAdhaarUrl,
      this.added})
      : super(key: key);

  @override
  _EditAdhaarDetailsState createState() => _EditAdhaarDetailsState();
}

class _EditAdhaarDetailsState extends State<EditAdhaarDetails> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _adhaarNumber;
  String _address;
  File _frontAdhaarFile;
  String _frontAdhaarUrl;
  File _backAdhaarFile;
  String _backAdhaarUrl;
  bool inProcess = false;
  bool save = false;
  bool _added;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;

    if (_added) {
      if (form.validate() &&
          _frontAdhaarUrl != null &&
          _backAdhaarUrl != null) {
        save = true;
        form.save();
        setState(() {
          EditAdhaarDetails.adhaarDone = true;
        });
        return true;
      }
      return false;
    }
    if (form.validate() &&
        _frontAdhaarFile != null &&
        _backAdhaarFile != null) {
      form.save();
      setState(() {
        EditAdhaarDetails.adhaarDone = true;
      });
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
        aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
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
        aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
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
      Navigator.of(context).pop();
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
    _added = widget.added;

    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Your name as per Adhaar '),
                        initialValue: widget.adhaarName,
                        validator: (value) =>
                            value.isNotEmpty ? null : 'Name can\'t be empty',
                        onSaved: (value) => _name = value,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Permanent address'),
                        initialValue: widget.address,
                        keyboardType: TextInputType.name,
                        validator: (value) => value.isNotEmpty
                            ? null
                            : 'Address name can\'t be empty',
                        onSaved: (value) => _address = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Adhaar number'),
                        initialValue: widget.adhaarNumber,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (value) => value.isNotEmpty
                            ? null
                            : 'Adhaar number can\'t be empty',
                        onSaved: (value) => _adhaarNumber = value,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Card(
                        elevation: 1,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Please upload your adhaar(front side)',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  color: Colors.black54,
                                  child: _frontAdhaarFile == null
                                      ? _frontAdhaarUrl == null
                                          ? Center(
                                              child: Text(
                                                'Add image',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Image.network(_frontAdhaarUrl)
                                      : Image.file(_frontAdhaarFile),
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
                        ),
                        color: Colors.grey[100],
                      ),
                      Card(
                        elevation: 1,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Please upload your adhaar(back)',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  color: Colors.black54,
                                  child: _backAdhaarFile == null
                                      ? _backAdhaarUrl == null
                                          ? Center(
                                              child: Text(
                                                'Add image',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Image.network(_backAdhaarUrl)
                                      : Image.file(_backAdhaarFile),
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
                        ),
                        color: Colors.grey[100],
                      ),
                      save
                          ? Text(
                              '*Please complete this form*',
                              style: TextStyle(color: Colors.red),
                            )
                          : Text(' ', style: TextStyle(color: Colors.green)),
                      CustomRaisedButton(
                        borderRadius: 10,
                        color: Colors.deepOrange,
                        child: Text(
                          widget.address == null ? 'Submit' : 'Update',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          _submit();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
