import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'astrology_selection_page.dart';

String? name;
String? rate;
String? duration;
String? detail;
String? keyword;
String? imageUrl;
String? offer;
String? name1;
String? rate1;
String? duration1;
String? detail1;
String? keyword1;
String? imageUrl1;
String? offer1;

class AstrologyForm extends StatelessWidget {
  final String uid;

  const AstrologyForm({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
          stream:
          FirebaseFirestore.instance.collection('Jyotisha').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            }

            return Container(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1.0 / 1),
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    imageUrl = snapshot.data!.docs[index].get('image');
                    name = snapshot.data!.docs[index].get('name');
                    keyword = snapshot.data!.docs[index].get('keyword');
                    rate = snapshot.data!.docs[index].get('least');
                    String id = snapshot.data!.docs[index].id;
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                          builder:(context)=> Dialog(
                              child: Container(
                                height: 500,
                                width:
                                MediaQuery.of(context).size.width * 0.9,
                                padding: EdgeInsets.all(10),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Jyotisha/$id/$id')
                                        .snapshots(),
                                    builder: (context, snapshot1) {
                                      if (snapshot1.data == null) {
                                        return Center(
                                            child:
                                            CircularProgressIndicator());
                                      }

                                      return Column(
                                        children: [
                                          Text('$name'),
                                          Divider(
                                            thickness: 1,
                                            color: Colors.deepOrange[100],
                                          ),
                                          Container(
                                            child: GridView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                snapshot1.data!.size,
                                                gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5,
                                                    childAspectRatio:
                                                    1.0 / 1.3),
                                                itemBuilder:
                                                    (context, index) {
                                                  imageUrl1 = snapshot1
                                                      .data!.docs[index]
                                                      .get('image');
                                                  name1 = snapshot1
                                                      .data!.docs[index]
                                                      .get('name');
                                                  keyword1 = snapshot1
                                                      .data!.docs[index]
                                                      .get('keyword');
                                                  rate1 = snapshot1
                                                      .data!.docs[index]
                                                      .get('least');

                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                          context: context,
                                                        builder:(context)=>AstroSelect(
                                                            uid: uid,
                                                            imageUrl: snapshot1
                                                                .data!
                                                                .docs[index]
                                                                .get(
                                                            'image'),
                                                            name: snapshot1
                                                                .data!
                                                                .docs[index]
                                                                .get('name'),
                                                            rate: snapshot1
                                                                .data!
                                                                .docs[index]
                                                                .get(
                                                            'least'),
                                                            keyword: snapshot1
                                                                .data!
                                                                .docs[index]
                                                                .id,
                                                            details: snapshot1
                                                                .data!
                                                                .docs[index]
                                                                .get(
                                                            'detail'),
                                                          ));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10),
                                                          color: Colors
                                                              .deepOrange[
                                                          50]),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          Image.network(
                                                            imageUrl1!,
                                                            height: 100,
                                                            width: 100,
                                                          ),
                                                          Text(
                                                            '$name1',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                  'Normal rate'),
                                                              Text(
                                                                '\₹$rate1',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          )
                                        ],
                                      );
                                    }),
                              ),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepOrange[50]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              imageUrl!,
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              '$name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Normal rate'),
                                Text(
                                  '\₹$rate',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
