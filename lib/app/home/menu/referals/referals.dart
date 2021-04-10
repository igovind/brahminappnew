import 'package:brahminapp/app/account/user_details.dart';
import 'package:brahminapp/services/database.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Referals extends StatelessWidget {
  final AsyncSnapshot<DocumentSnapshot> snapshot;
  final AsyncSnapshot<DocumentSnapshot> refSnap;

  const Referals({Key key, this.snapshot, this.refSnap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: UserDetails(snapshot: snapshot).uid)
            .getReferrals,
        builder: (context, refSnapshot) {
          if (refSnapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 20,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Your code is ${UserDetails(snapshot: snapshot).refCode}",
                style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16),
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: () {
                String st =
                    "${refSnap.data.data()["ref_text1"]} *${UserDetails(snapshot: snapshot).name}* ${refSnap.data.data()["ref_text"]} \n \n \n *Link:* ${refSnap.data.data()["link"]} \n\n REFERAL CODE: *${UserDetails(snapshot: snapshot).refCode}* ";
                Share.share(st);
                print(st);
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Refer",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.share_sharp,
                      color: Colors.white,
                    ),
                  ],
                ),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blueAccent[100],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            body: refSnapshot.data.docs.isEmpty
                ? Center(
                    child: Text(
                      "You don't have any referral, please refer this app to your contacts",
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: refSnapshot.data.size,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        leading: CircularProfileAvatar(
                          "${refSnapshot.data.docs[index].data()["profilePicUrl"]}",
                          radius: 30,
                        ),
                        title: Text(
                            "${refSnapshot.data.docs[index].data()["firstName"]}",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "${refSnapshot.data.docs[index].data()["aboutYou"]}",
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }),
          );
        });
  }
}
