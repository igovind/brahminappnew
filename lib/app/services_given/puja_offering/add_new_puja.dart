import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/app/services_given/puja_offering/puja_class.dart';
import 'package:brahminapp/app/services_given/puja_offering/puja_tile.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNewPuja extends StatelessWidget {
  final AsyncSnapshot<DocumentSnapshot> userData;
  final List<dynamic> samagriList;
  final List<dynamic> pujaList;

  const AddNewPuja(
      {Key? key,
      required this.userData,
      required this.samagriList,
      required this.pujaList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: ListView.separated(
              itemBuilder: (context, index) {
                Puja puja = Puja(
                    samagriList: samagriList,
                    state: UserDetails(snapshot: userData).state,
                    languageCode: UserDetails(snapshot: userData).language,
                    value: pujaList,
                    index: index);
                return PujaTile(
                  mainSamagriList: samagriList,
                  samagri: puja.samagri,
                  name: puja.name,
                  uid: UserDetails(snapshot: userData).uid,
                  languageCode: UserDetails(snapshot: userData).language,
                  keyword: puja.keyword,
                  type: puja.keyword,
                  description: puja.description,
                  image: puja.image,
                  duration: puja.duration,
                  pjid: puja.id,
                  price: "2000",
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                  height: MagicScreen(height: 30, context: context).getHeight),
              itemCount: pujaList.length)),
    );
  }
}
