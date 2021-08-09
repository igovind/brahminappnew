import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:brahminapp/app/account/EditGallery.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../languages.dart';

class GalleryPage extends StatelessWidget {
  final language;
  final uid;
  final done;

  const GalleryPage({Key? key, this.uid, this.done, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        leading: done != null
            ? IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                onPressed: () {
                  FireStoreDatabase(uid: uid).updateData(data: {"index": 1});
                },
              )
            : null,
        actions: [
          done == null
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    FireStoreDatabase(uid: uid).updateData(data: {'index': 2});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black54, blurRadius: 3)
                        ],
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      Language(code: language, text: [
                        "Next",
                        "आगे बढ़ें",
                        "এগিয়ে যান",
                        "மேலே செல்லுங்கள்",
                        "ముందుకి వెళ్ళు"
                      ]).getText,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: height(50),
        centerTitle: true,
        title: Text(
          Language(code: language, text: [
            "Gallery ",
            "गेलरी ",
            "গ্যালারী ",
            "கேலரி ",
            "గ్యాలరీ "
          ]).getText,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .doc('punditUsers/$uid/user_profile/galleryPic')
              .snapshots(),
          builder: (context, snapshot) {
            String? imageUrl1;
            String? imageUrl2;
            String? imageUrl3;
            String? imageUrl4;

            String? check;
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.data() != null) {
              imageUrl1 = snapshot.data!.get('link1');
              imageUrl2 = snapshot.data!.get('link2');
              imageUrl3 = snapshot.data!.get('link3');
              imageUrl4 = snapshot.data!.get('link4');
              check = snapshot.data!.get('set');
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  ImageBox(
                    language: language,
                    image: imageUrl1,
                    uid: uid,
                    check: check,
                    num: 1,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                  ImageBox(
                    language: language,
                    image: imageUrl2,
                    uid: uid,
                    check: check,
                    num: 2,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                  ImageBox(
                    language: language,
                    image: imageUrl3,
                    uid: uid,
                    check: check,
                    num: 3,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                  ImageBox(
                    language: language,
                    image: imageUrl4,
                    uid: uid,
                    check: check,
                    num: 4,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                ]),
              ),
            );
          }),
    );
  }
}

class ImageBox extends StatelessWidget {
  final image;
  final uid;
  final check;
  final int? num;
  final language;

  const ImageBox(
      {Key? key, this.image, this.uid, this.check, this.num, this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*   showDialog(
         // backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              height: MediaQuery.of(context).size.height * 0.6,
              child: EditGallery(
                language: language,
                set: check,
                imageUrl: image,
                uid: uid,
                num: num,
              ),
            );
          },
        );*/
        Widget _buildBottomSheet(
          BuildContext context,
          ScrollController scrollController,
          double bottomSheetOffset,
        ) {
          return Material(
            child: Container(
                child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              height: MediaQuery.of(context).size.height * 0.6,
              child: EditGallery(
                language: language,
                set: check,
                imageUrl: image,
                uid: uid,
                num: num,
              ),
            )),
          );
        }

        showFlexibleBottomSheet(
          minHeight: 0,
          initHeight: 0.5,
          maxHeight: 1,
          context: context,
          builder: _buildBottomSheet,
          anchors: [500, 50, 1],
        );
      },
      child: Container(
        height: MagicScreen(height: 200, context: context).getHeight,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 1)],
            image: DecorationImage(
                fit: BoxFit.fill,
                image: (image == null
                    ? AssetImage("images/newback.jpg")
                    : NetworkImage(image)) as ImageProvider<Object>)),
      ),
    );
  }
}
