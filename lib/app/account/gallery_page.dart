import 'package:brahminapp/app/account/EditGallery.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GalleryPage extends StatelessWidget {
  final uid;
  final done;

  const GalleryPage({Key key, this.uid, this.done}) : super(key: key);

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
              : FlatButton(
                  onPressed: () {
                    FireStoreDatabase(uid: uid).updateData(data: {'index': 3});
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                  ))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: height(40),
        centerTitle: true,
        title: Text(
          "Gallery",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .doc('punditUsers/$uid/user_profile/galleryPic')
              .snapshots(),
          builder: (context, snapshot) {
            String imageUrl1;
            String imageUrl2;
            String imageUrl3;
            String imageUrl4;

            String check;
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.data() != null) {
              imageUrl1 = snapshot.data.data()['link1'];
              imageUrl2 = snapshot.data.data()['link2'];
              imageUrl3 = snapshot.data.data()['link3'];
              imageUrl4 = snapshot.data.data()['link4'];
              check = snapshot.data.data()['set'];
            }
            print(">>>>>>>>>>>>>>>>>>>>>>>>>..$imageUrl1");
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  ImageBox(
                    image: imageUrl1,
                    uid: uid,
                    check: check,
                    num: 1,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                  ImageBox(
                    image: imageUrl2,
                    uid: uid,
                    check: check,
                    num: 2,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                  ImageBox(
                    image: imageUrl3,
                    uid: uid,
                    check: check,
                    num: 3,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                  ImageBox(
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
  final int num;

  const ImageBox({Key key, this.image, this.uid, this.check, this.num})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
          backgroundColor: Colors.transparent,
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
                set: check,
                imageUrl: image,
                uid: uid,
                num: num,
              ),
            );
          },
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
                image: image == null
                    ? AssetImage("images/cover_image.jpg")
                    : NetworkImage(image))),
      ),
    );
  }
}