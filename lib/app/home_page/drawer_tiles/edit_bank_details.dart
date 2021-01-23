import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/common_widgets/platform_exception_alert_dialog.dart';
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
  static bool bankDone=false;

  const EditBankDetails(
      {Key key,
      this.bankName,
      this.accountNumber,
      this.name,
      this.ifscCode,
      @required this.uid})
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
      setState(() {
        EditBankDetails.bankDone = true;
      });
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
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight:100 ,),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          color:Colors.white,
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Scaffold(
            backgroundColor: Colors.white,
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
                              labelText: 'Your name as per bank details'),
                          initialValue: widget.name,
                          validator: (value) =>
                              value.isNotEmpty ? null : 'Name can\'t be empty',
                          onSaved: (value) => _name = value,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Name of your bank'),
                          initialValue: widget.bankName,
                          keyboardType: TextInputType.name,
                          validator: (value) => value.isNotEmpty
                              ? null
                              : 'Bank name can\'t be empty',
                          onSaved: (value) => _bankName = value,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Account number'),
                          initialValue: widget.accountNumber,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          validator: (value) => value.isNotEmpty
                              ? null
                              : 'Account number can\'t be empty',
                          onSaved: (value) => _accountNumber = value,
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Enter IFSC code'),
                          initialValue: widget.ifscCode,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          validator: (value) => value.isNotEmpty
                              ? null
                              : 'IFSC code can\'t be empty',
                          onSaved: (value) => _ifscCode = value,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        CustomRaisedButton(
                          borderRadius: 10,
                          color: Colors.deepOrange,
                          child: Text(
                            widget.name == null ? 'Submit' : 'Update',
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
      ),
    );
  }
}
