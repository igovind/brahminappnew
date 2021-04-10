import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/services_given/new_add_edit_puja.dart';
import 'package:brahminapp/app/account/account_page.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';

class PujaOffering extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final uid;

  const PujaOffering({Key key, this.snapshot, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
                    height: height(700),
                    child: NewAddAndEditPuja(
                      docSnap: null,
                      uid: uid,
                    ));
              },
            );
          },
          child: Icon(
            Icons.add_sharp,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        ),
        body: snapshot.data.docs.isEmpty
            ? Center(
                child: Text(
                  "Please add your puja that you are going to offer here ",
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.size + 1,
                itemBuilder: (context, index) {
                  if (index == snapshot.data.size) {
                    return Container(
                      height: 100,
                    );
                  }
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  String name = documentSnapshot.data()["puja"];
                  String samagri = documentSnapshot.data()["Pujan Samagri"];
                  double price = documentSnapshot.data()["price"];
                  int swastik = documentSnapshot.data()["swastik"];
                  int subscriber = documentSnapshot.data()["subscriber"];
                  String time = documentSnapshot.data()["time"];
                  String id = documentSnapshot.id;
                  return Dismissible(
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to delete this service?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE")),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Color(0XFFffbd59),
                      child: Center(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "DELETE ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 25,
                                  )
                                ],
                              ))),
                    ),
                    onDismissed: (direction) {
                      direction.index.toString();
                      FireStoreDatabase(uid: uid).deletepuja(
                          id, snapshot.data.docs[index].data()['keyword']);
                      BotToast.showText(text: "Deleted Successfully");
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                      child: GestureDetector(
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: NewAddAndEditPuja(
                                    docSnap: snapshot.data.docs[index],
                                    uid: uid,
                                  ));
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 2)
                              ]),
                          child: Column(
                            children: [
                              SizedBox(
                                height: height(5),
                              ),
                              Text(
                                "$name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.deepOrangeAccent),
                              ),
                              SizedBox(
                                height: height(20),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Rs/-",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      Text(
                                        "$price",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.watch_later,
                                        color: Colors.black54,
                                        size: 16,
                                      ),
                                      Text("$time",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.black54, size: 18),
                                      Text("$swastik",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(Icons.people,
                                          color: Colors.black54, size: 18),
                                      Text("$subscriber",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                              FlatButton(
                                  onPressed: () {},
                                  child: AccountTile(
                                    onPress: () {
                                      Share.share("$samagri");
                                    },
                                    title: "Share shamagri to contact",
                                    icon: Icons.share,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
