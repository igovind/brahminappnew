import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../../languages.dart';

class SharePujaCard extends StatefulWidget {
  final bdImg;
  final name;
  final price;
  final description;
  final time;
  final List<dynamic> samagri;
  final img;
  final AsyncSnapshot<DocumentSnapshot> userSnap;

  const SharePujaCard(
      {Key? key,
      this.bdImg,
      required this.userSnap,
      this.name,
      this.price,
      this.description,
      this.time,
      this.img,
      required this.samagri})
      : super(key: key);

  @override
  _SharePujaCardState createState() => _SharePujaCardState();
}

class _SharePujaCardState extends State<SharePujaCard> {
  bool loadingSharing = false;
  GlobalKey _ssglobalKey = GlobalKey();

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  _saveScreen() async {
    setState(() {
      loadingSharing = true;
    });
    _toastInfo("Download started");
    RenderRepaintBoundary boundary = _ssglobalKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image imageo = await boundary.toImage(pixelRatio: 10);

    ByteData? byteData =
        await (imageo.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);

      if (result["isSuccess"] == true) {
        setState(() {
          loadingSharing = false;
        });
        _toastInfo("Download successful");
        await WcFlutterShare.share(
            sharePopupTitle: 'share',
            subject: 'Download the app now',
            text: Language(
                    text: widget.samagri,
                    code: UserDetails(snapshot: widget.userSnap).language)
                .getText,
            fileName: 'share.png',
            mimeType: 'image/png',
            bytesOfFile: byteData.buffer.asUint8List());
      } else {
        setState(() {
          loadingSharing = false;
        });
        _toastInfo("Download failed");
      }
    }
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
   // _toastInfo(info);
  }

  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height(double h) =>
        MagicScreen(context: context, height: h).getHeight;
    double width(double h) => MagicScreen(context: context, width: h).getWidth;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                RepaintBoundary(
                  key: _ssglobalKey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black54, blurRadius: 3)
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        //  padding: EdgeInsets.all(height(10)),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/swastik13-8242d.appspot.com/o/inventories%2Fimportent%20images%2FUntitled%20design-5.jpg?alt=media&token=535d6e7f-083a-44e8-ab3b-adf03c3532a1"),
                              fit: BoxFit.fill),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                             // padding: EdgeInsets.all(5),
                              child: Image.network(
                                widget.img,
                                height: height(100),
                              ),
                            ),
                            Text(
                              "${widget.name}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.deepOrangeAccent,
                                        blurRadius: 1)
                                  ],
                                  fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.description}",
                                textAlign: TextAlign.center,

                                style: TextStyle(fontSize: 12, background: Paint()..color = Colors.white,),

                              ),
                            ),

                            /*Text(

                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),*/
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.deepOrangeAccent,
                                            blurRadius: 2)
                                      ],
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${UserDetails(snapshot: widget.userSnap).profilePhoto}"),
                                          fit: BoxFit.fitHeight)),
                                  height: height(45),
                                  width: width(45),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  UserDetails(snapshot: widget.userSnap).name!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(height: height(30),)
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: height(10),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 3)
                    ]),
                    child: Column(
                      children: [
                        Text(
                          Language(
                              code: UserDetails(snapshot: widget.userSnap)
                                  .language,
                              text: [
                                "Puja samagri ",
                                "पूजा की सामग्री  ",
                                "পূজা উপাদান ",
                                "பூஜை பொருள் ",
                                "పూజా పదార్థం "
                              ]).getText,
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: Colors.deepOrangeAccent,
                          thickness: 1,
                        ),
                        Text(
                          Language(
                                  text: widget.samagri,
                                  code: UserDetails(snapshot: widget.userSnap)
                                      .language)
                              .getText,style: TextStyle(fontSize: 12),
                        )
                      ],
                    )),
                SizedBox(
                  height: height(20),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _saveScreen();
                      /*    Share.shareFiles(
                      ["file:///storage/emulated/0/Pictures/1627400247935.jpg"],
                      subject: 'Screenshot + Share',
                      text: 'Hey, check it out the sharefiles repo!',
                    );*/
                    });
                  },
                  child: loadingSharing
                      ? CircularProgressIndicator()
                      : Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.black54, blurRadius: 3)
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.indigo),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Language(
                                    code: UserDetails(snapshot: widget.userSnap)
                                        .language,
                                    text: [
                                      "Share",
                                      "शेयर",
                                      "ভাগ",
                                      "பகிர்",
                                      "పంచుకోండి"
                                    ]).getText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            )),
      ),
    );
  }
}
