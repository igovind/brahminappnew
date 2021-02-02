import 'package:bot_toast/bot_toast.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/astrology/astrology_form.dart';
import 'package:brahminapp/app/home_page/drawer_tiles/astrology/astrology_selection_page.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AstrologySection extends StatelessWidget {
  final String uid;

  const AstrologySection({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Astrology Services'),
        toolbarHeight: 100,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                  itemCount: snapshot.data.size,

                  //padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    String imageUrl = snapshot.data.docs[index].data()['image'];
                    String name = snapshot.data.docs[index].data()['name'];
                    String keyword =
                        snapshot.data.docs[index].data()['keyword'];
                    String price = snapshot.data.docs[index].data()['price'];
                    String duration =
                        snapshot.data.docs[index].data()['Duration'];
                    String details = snapshot.data.docs[index].data()['detail'];
                    String additional =
                        snapshot.data.docs[index].data()['offer'];
                    return Dismissible(
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
                        BotToast.showText(
                            text: "Deleted Successfully");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                child: AstroSelect(
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
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepOrange[50]),
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
                                          color: Colors.deepOrange[100],
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
                                          color: Colors.deepOrange[100],
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
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AstrologyForm(
                      uid: uid,
                    )),
          );
        },
      ),
    );
  }
}
