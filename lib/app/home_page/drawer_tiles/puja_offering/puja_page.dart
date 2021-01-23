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
            body: ListView.builder(
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
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                        ),
                        onDismissed: (direction) {
                          direction.index.toString();
                          FireStoreDatabase(uid: widget.uid).deletepuja(id);
                        },
                        child: _buildTile(pujaName, rate)),
                  );
                }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepOrange,
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
            '  ₹ $rate',
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
        ),
      ],
    ),
  );
}
