import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_and_edit_puja.dart';

class PujaPage extends StatefulWidget {
  final String uid;

  const PujaPage({Key key, @required this.uid}) : super(key: key);

  @override
  _PujaPageState createState() => _PujaPageState();
}

class _PujaPageState extends State<PujaPage> {
  String pujaName;
  double rate;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: widget.uid).getPujaOfferingList,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 120,
              centerTitle: true,
              title: Text('Services'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    pujaName = snapshot.data.docs[index].data()['puja'];
                    rate = snapshot.data.docs[index].data()['price'];
                    String id = snapshot.data.docs[index].id;
                    DocumentSnapshot docSnap = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => AddAndEditPuja(
                                    docSnap: docSnap,
                                    uid: widget.uid,
                                  )),
                        );
                      },
                      child: Dismissible(
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
                            FireStoreDatabase(uid: widget.uid).deletepuja(
                                id, snapshot.data.docs[index].data()['keyword']);
                            BotToast.showText(text: "Deleted Successfully");
                          },
                          child: _buildTile(pujaName, rate)),
                    );
                  }),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0XFFffbd59),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddAndEditPuja(
                          docSnap: null,
                          uid: widget.uid,
                        )));
              },
              child: Icon(Icons.add),
            ),
          );
        });
  }
}

Widget _buildTile(String name, double rate) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.deepOrange[50], borderRadius: BorderRadius.circular(10)),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Text(
            name,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            ' $rate ₹',
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
        ),
      ],
    ),
  );
}
