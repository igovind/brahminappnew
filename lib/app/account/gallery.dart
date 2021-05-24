import 'package:brahminapp/app/account/EditGallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  final uid;

  const Gallery({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My gallery'),
        toolbarHeight: 100,
      ),
      //backgroundColor: Colors.deepOrange[50],
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .doc('punditUsers/${widget.uid}/user_profile/galleryPic')
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
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    _galleryBox(
                        context: context,
                        imageUrl: imageUrl1,
                        uid: widget.uid,
                        check: check,
                        num: 1),
                    SizedBox(
                      height: 10,
                    ),
                    _galleryBox(
                        context: context,
                        imageUrl: imageUrl2,
                        check: check,
                        uid: widget.uid,
                        num: 2),
                    SizedBox(
                      height: 10,
                    ),
                    _galleryBox(
                        context: context,
                        imageUrl: imageUrl3,
                        uid: widget.uid,
                        check: check,
                        num: 3),
                    SizedBox(
                      height: 10,
                    ),
                    _galleryBox(
                        context: context,
                        imageUrl: imageUrl4,
                        uid: widget.uid,
                        check: check,
                        num: 4),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

Widget _galleryBox(
    {BuildContext? context,
    String? uid,
    String? check,
    String? imageUrl,
    int? num}) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context!,
        builder:(context)=> EditGallery(
            imageUrl: imageUrl,
            set: check,
            uid: uid,
            num: num,
          ));
    },
    child: imageUrl == null
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                  color: Colors.black, width: 2, style: BorderStyle.solid),
            ),
            child: Icon(
              Icons.image,
              size: 30,
            ),
            width: MediaQuery.of(context!).size.width * 0.9,
            height: 200,
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                  color: Colors.black, width: 2, style: BorderStyle.solid),
            ),
            width: MediaQuery.of(context!).size.width * 0.9,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
  );
}
