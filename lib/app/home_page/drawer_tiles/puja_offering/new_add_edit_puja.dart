import 'package:brahminapp/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewAddEditPuja extends StatefulWidget {
  @override
  _NewAddEditPujaState createState() => _NewAddEditPujaState();
}

class _NewAddEditPujaState extends State<NewAddEditPuja> {
  final _pujaFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String _name;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add puja'),
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 0,
      ),
      body: Form(
        key: _pujaFormKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
