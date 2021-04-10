import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/bookings/booking_tile.dart';
import 'package:brahminapp/common_widgets/custom_raised_button.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingRequest extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

  final UserId userId;

  const BookingRequest(
      {Key key, this.snapshot,  this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }
    String url = userId.photoUrl;
    if(snapshot.data.docs.isEmpty){
      return Center(child:
        Text("You don't have any booking request")
        ,);
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context, index) {
        DocumentSnapshot ref = snapshot.data.docs[index];
        final String service = ref.data()['service'];
        final String client = ref.data()['client'];
        final String tuid = ref.data()['clientuid'];
        final String serviceId = ref.data()['serviceId'];
        final bool accepted = ref.data()['request'];
        final bool cancel = ref.data()['cancel'];
        final String tid = ref.id;
        return BookingTiles(
          snapshot: snapshot.data.docs[index],
          onPressLocation: () {},
          child: cancel
              ? Container(
                  padding: EdgeInsets.all(1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Canceled by $client",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            FireStoreDatabase(uid: userId.uid)
                                .deleteBooking(tid);
                          })
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                )
              : accepted
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Payment is pending",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomRaisedButton(
                          color: Colors.lightGreen,
                          child: Text(
                            "Accept",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          height: height(40),
                          onPressed: () {
                            FireStoreDatabase(uid: userId.uid).updateBooking(
                                serviceId: serviceId,
                                service: service,
                                pPic: url,
                                tuid: tuid,
                                tid: tid,
                                bookingAccepted: true);
                            BotToast.showText(text: "Accepted");
                          },
                        ),
                        CustomRaisedButton(
                          color: Colors.redAccent[100],
                          child: Text(
                            "Reject",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          height: height(40),
                          onPressed: () {
                            FireStoreDatabase(uid: userId.uid).updateBooking(
                                serviceId: serviceId,
                                pPic: url,
                                service: service,
                                tuid: tuid,
                                tid: tid,
                                bookingAccepted: false);
                            BotToast.showText(text: "Rejected");
                          },
                        )
                      ],
                    ),
        );
      },
    );
  }
}
