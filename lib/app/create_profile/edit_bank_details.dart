import 'package:brahminapp/common_widgets/custom_text_field.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditBankDetails extends StatefulWidget {
  final bankName;
  final accountNumber;
  final name;
  final ifscCode;
  final uid;
  final check;

  const EditBankDetails(
      {Key key,
      this.bankName,
      this.accountNumber,
      this.name,
      this.ifscCode,
      @required this.uid,
      this.check})
      : super(key: key);

  @override
  _EditBankDetailsState createState() => _EditBankDetailsState();
}

class _EditBankDetailsState extends State<EditBankDetails> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _bankName;
  String _accountNumber;
  String _ifscCode;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        if (widget.name == null) {
          FirebaseFirestore.instance
              .doc('punditUsers/${widget.uid}/user_profile/user_bank_details')
              .set({
            'name': _name,
            'bankName': _bankName,
            'accountNumber': _accountNumber,
            'IFSC': _ifscCode
          });
        } else {
          FirebaseFirestore.instance
              .doc('punditUsers/${widget.uid}/user_profile/user_bank_details')
              .update({
            'name': _name,
            'bankName': _bankName,
            'accountNumber': _accountNumber,
            'IFSC': _ifscCode
          });
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
      if (widget.check != null) {
        FireStoreDatabase(uid: widget.uid).updateData(data: {"ready": true});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: height(30),
        actions: [
          widget.check == null
              ? SizedBox()
              : FlatButton(
                  onPressed: () {
                    FireStoreDatabase(uid: widget.uid)
                        .updateData(data: {"ready": true});
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                  )),
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
                widget.name == null ? 'Submit' : 'Update',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Bank details"),
                SizedBox(
                  height: height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Your name as per bank details'),
                    initialValue: widget.name,
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Name can\'t be empty',
                    onSaved: (value) => _name = value,
                  ),
                ),
                SizedBox(
                  height: height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Name of your bank'),
                    initialValue: widget.bankName,
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Bank name can\'t be empty',
                    onSaved: (value) => _bankName = value,
                  ),
                ),
                SizedBox(
                  height: height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: 'Account number'),
                    initialValue: widget.accountNumber,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    validator: (value) => value.isNotEmpty
                        ? null
                        : 'Account number can\'t be empty',
                    onSaved: (value) => _accountNumber = value,
                  ),
                ),
                SizedBox(
                  height: height(10),
                ),
                CustomContainer(
                  radius: 10,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none, labelText: 'Enter IFSC code'),
                    initialValue: widget.ifscCode,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    validator: (value) =>
                        value.isNotEmpty ? null : 'IFSC code can\'t be empty',
                    onSaved: (value) => _ifscCode = value,
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
