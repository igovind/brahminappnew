import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BookingTiles extends StatelessWidget {
  final DocumentSnapshot? snapshot;
  final Widget? child;
  final VoidCallback? onPressLocation;
  final language;

  const BookingTiles(
      {Key? key,
      this.snapshot,
      this.child,
      this.onPressLocation,
      this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    DocumentSnapshot ref = snapshot!;
    final String? date = ref.get('date');
    final Timestamp dateOfBooking = ref.get('dt');
    final String? time = ref.get('time');
    final String? pic = ref.get('pic');
    final String service = ref.get('service');
    final String client = ref.get('client');
    final String? location = ref.get('Location');
    final String tid = ref.id;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
            ),
          ],
          //border: Border.all(color: Colors.black54,width: 0.5,style: BorderStyle.solid),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        //height: 220,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(pic!)),
                      shape: BoxShape.circle,
                      color: Colors.black38,
                      boxShadow: [
                        BoxShadow(color: Colors.black38, blurRadius: 5)
                      ]),
                ),
                /* Container(
                  height: 60,
                  //MagicScreen(height: radius, context: context).getHeight,
                  //width: MagicScreen(width: radius, context: context).getWidth,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(pic!))),
                ),*/
                Column(
                  children: <Widget>[
                    Text(client,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.visible,
                        maxLines: 3,
                        softWrap: true),
                    Text(service,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.redAccent),
                        overflow: TextOverflow.visible,
                        maxLines: 3,
                        softWrap: true),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.black54,
                        ),
                        Text('$date - $time',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                color: Colors.black54),
                            overflow: TextOverflow.visible,
                            maxLines: 3,
                            softWrap: true),
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height(10),
            ),
            GestureDetector(
              onTap: onPressLocation,
              child: DottedBorder(
                color: Colors.deepOrangeAccent,
                strokeWidth: 0.5,
                radius: Radius.circular(20),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.deepOrangeAccent,
                        ),
                        Expanded(
                          child: Text(
                            "$location",
                            overflow: TextOverflow.clip,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: height(10),
            ),
            Text(
              Language(code: language, text: [
                "Booking ID: $tid ",
                "बुकिंग: $tid ",
                "সংরক্ষণ: $tid ",
                "பதிவு: $tid  ",
                "బుకింగ్: $tid  "
              ]).getText,
            ),
            SizedBox(
              height: height(5),
            ),
            child!,
            SizedBox(
              height: height(8),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${dateOfBooking.toDate().day}/${dateOfBooking.toDate().month}/${dateOfBooking.toDate().year}-${dateOfBooking.toDate().hour}:${dateOfBooking.toDate().minute}",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
