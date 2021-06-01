import 'package:brahminapp/app/astrology/calls/index.dart';
import 'package:brahminapp/app/bookings/booking_request.dart';
import 'package:brahminapp/app/bookings/bookings_page.dart';
import 'package:brahminapp/app/bookings/upcoming.dart';
import 'package:brahminapp/app/home/chat/view/ChatListPageView.dart';
import 'package:brahminapp/services/OnePage.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database.dart';

class HandleNotificationRouting extends StatelessWidget {
  final String? payload;

  const HandleNotificationRouting({Key? key, this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    UserId userId = UserId(
        userEmail: user!.email,
        uid: user.uid,
        photoUrl: user.photoURL,
        displayName: user.displayName);
    List<String> data = payload!.split("*");
    print("$data || $payload |${data[1]}| |${data[0]}|");
    return StreamBuilder<DocumentSnapshot>(
        stream: FireStoreDatabase(uid: userId.uid).getUserData,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          String language=snapshot.data!.get("langCode");
          if (data[0] == "Message")
            return Provider<DatabaseL>(
                create: (context) => FireStoreDatabase(uid: userId.uid),
                child: Chat(
                  databaseL: null,
                  user: userId,
                ));
          if (data[0] == "Video")
            return IndexPage(
              channelName: data[1],
              callType: data[0],
              userId: userId,
            );
          if (data[0] == "Voice")
            return IndexPage(
              channelName: data[1],
              callType: data[0],
              userId: userId,
            );
          if (data[0] == "Booking")
            return BookingsPage(
              userId: userId,
              language: language,
            );
          if (data[0] == "Booking")
            return StreamBuilder<QuerySnapshot>(
                stream: FireStoreDatabase(uid: userId.uid).getBookingRequest,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return BookingRequest(
                    snapshot: snapshot,
                    userId: userId,
                    language: "ENG",
                  );
                });
          if (data[0] == 'Upcoming') {
            return StreamBuilder<QuerySnapshot>(
                stream: FireStoreDatabase(uid: userId.uid).getUpComingPuja,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Upcoming(
                    snapshot: snapshot,
                    userId: userId,
                    language: "ENG",
                  );
                });
          }
          if (data[0] == 'History') {
            return StreamBuilder<QuerySnapshot>(
                stream: FireStoreDatabase(uid: userId.uid).getUpComingPuja,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Upcoming(
                    snapshot: snapshot,
                    userId: userId,
                    language: "ENG",
                  );
                });
          }
          return OnePage();
        });
  }
}

