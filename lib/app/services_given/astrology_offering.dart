import 'package:brahminapp/app/services_given/subject/astrology_form.dart';
import 'package:brahminapp/app/services_given/subject/astrology_sec.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AstroOffering extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot>? snapshot;
  final UserId? userId;

  const AstroOffering({Key? key, this.snapshot, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AstrologySection(
        uid: userId!.uid,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            //backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: AstrologyForm(
                    uid: userId!.uid,
                  ));
            },
          );
        },
        child: Icon(
          Icons.add_sharp,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      // body: ListView.builder(itemBuilder: null)
    );
  }
}
