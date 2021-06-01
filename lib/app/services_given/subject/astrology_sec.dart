import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'astrology_selection_page.dart';

class AstrologySection extends StatelessWidget {
  final String uid;

  const AstrologySection({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase(uid: uid).getAstroList,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: snapshot.data!.size,

                //padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  String imageUrl = snapshot.data!.docs[index].get('image');
                  String? name = snapshot.data!.docs[index].get('name');
                  String? keyword = snapshot.data!.docs[index].get('keyword');
                  String? price = snapshot.data!.docs[index].get('price');
                  String? duration =
                      snapshot.data!.docs[index].get('Duration');
                  String? details = snapshot.data!.docs[index].get('detail');
                  String? additional = snapshot.data!.docs[index].get('offer');
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
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE")),
                              TextButton(
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
                      color: Colors.red,
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
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 40,
                                  )
                                ],
                              ))),
                    ),
                    onDismissed: (direction) {
                      direction.index.toString();
                      FireStoreDatabase(uid: uid).deleteAstro(keyword);
                      //TODO: botToast
                      /*BotToast.showText(text: "Deleted Successfully");*/
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                            builder:(context)=> AstroSelect(
                                uid: uid,
                                name: name,
                                rate: price,
                                imageUrl: imageUrl,
                                details: details,
                                keyword: keyword,
                                time: duration,
                                offer: additional,
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                imageUrl,
                                height: 100,
                                width: 100,
                              ),
                              Text(
                                '$name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\₹$price',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('$duration'),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 400,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.deepOrange[100]!,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                padding: EdgeInsets.all(8),
                                child: Text('$details'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 400,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.deepOrange[100]!,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      'Additional Description',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('$additional'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
