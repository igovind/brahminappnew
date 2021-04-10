import 'package:brahminapp/app/bookings/star_rating.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'booking_tile.dart';

class BookingHistory extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final UserId userId;

  const BookingHistory(
      {Key key, this.snapshot, this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

 /*   double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }*/

    if (snapshot.data.docs.isEmpty) {
      return Center(
        child: Text("No history"),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot ref = snapshot.data.docs[index];
        final double swastik = ref.data()['swastik'];
        final String contact = ref.data()['contact'];
        dynamic cod = ref.data()['cod'];
        return BookingTiles(
          snapshot: snapshot.data.docs[index],
          onPressLocation: () {},
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Payment mode"),
                  Text(
                    cod != null && cod == true ? ' Cash at home' : ' Online',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: height(5),
              ),
              Text("$contact"),
              SizedBox(
                height: height(5),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "  $swastik",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  StarRating(
                    swastik: swastik,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
