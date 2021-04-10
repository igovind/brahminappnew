import 'package:brahminapp/common_widgets/hexa_color.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'chat/view/ChatListPageView.dart';
import 'menu/referals/referals.dart';

class HomePageFolder extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot> snapshot;
  final AsyncSnapshot<DocumentSnapshot> userDataSnapshot;
  final UserId userId;

  const HomePageFolder(
      {Key key, this.snapshot, this.userId, this.userDataSnapshot})
      : super(key: key);

  @override
  _HomePageFolderState createState() => _HomePageFolderState();
}

class _HomePageFolderState extends State<HomePageFolder> {
  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }
    double width(double width) {
      return MagicScreen(context: context, width: width).getWidth;
    }
    String icon_1 = widget.snapshot.data.data()["icon_1"];
    String icon_2 = widget.snapshot.data.data()["icon_2"];
    String icon_3 = widget.snapshot.data.data()["icon_3"];
    String icon_4 = widget.snapshot.data.data()["icon_4"];
    String icon_5 = widget.snapshot.data.data()["icon_5"];
    String icon_6 = widget.snapshot.data.data()["icon_6"];
    String banner = widget.snapshot.data.data()["banner"];
    int reward = widget.userDataSnapshot.data.data()['setReward'];
    double _net = widget.userDataSnapshot.data.data()['setPrice'].toDouble();
    bool claimed = false;
    List<dynamic> sliderImages = widget.snapshot.data.data()["slider_images"];
    String titleColor =
        widget.snapshot.data.data()["app_title_color"] ?? "#F9FFFB";
    print("");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
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
                height: MediaQuery.of(context).size.height * 0.9,
                child: Provider<DatabaseL>(
                    create: (context) =>
                        FireStoreDatabase(uid: widget.userId.uid),
                    child: Chat(
                      databaseL: null,
                      user: widget.userId,
                    )),
              );
            },
          );
        },
        child: Icon(Icons.message),
      ),
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 4, right: 4, bottom: 0),
            child: ListView(
              children: [
                SizedBox(
                  height: height(140),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: height(200),
                  // width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4.0,
                      ),
                    ],
                    color: Colors.white, //HexColor("##F4D27A"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: GridView(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.0 / 1),
                      shrinkWrap: true,
                      children: [
                        CustomGridTile(
                          image: icon_1,
                          child: ComingSoon(),
                        ),
                        CustomGridTile(
                          image: icon_2,
                          child: ComingSoon(),
                        ),
                        CustomGridTile(
                          image: icon_3,
                          child: ComingSoon(),
                        ),
                        CustomGridTile(
                          image: icon_4,
                          child: Referals(
                            refSnap: widget.snapshot,
                            snapshot: widget.userDataSnapshot,
                          ),
                        ),
                        CustomGridTile(
                          image: icon_5,
                          child: ComingSoon(),
                        ),
                        CustomGridTile(
                          image: icon_6,
                          child: ComingSoon(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height(10),
                ),
                reward == null
                    ? Container(
                        width: 350,
                        height: 70,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.local_offer_sharp,
                                color: Color(0XFFffbd59),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Complete 7 puja and claim your reward',
                                style: TextStyle(
                                    color: Color(0XFFffbd59), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      )
                    : reward >= 7
                        ? Container(
                            height: 70,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.local_offer_sharp,
                                    color: Color(0XFFffbd59),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Criteria fulfilled claim your reward',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 12),
                                  ),
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          claimed = true;
                                        });
                                        showDialog(
                                            context: context,
                                            child: AlertDialog(
                                              title: Text('Reward Claimed'),
                                              content: Text(
                                                  'We will soon add your reward'),
                                            ));
                                        FirebaseFirestore.instance
                                            .collection('rewardClaim')
                                            .doc('${DateTime.now()}')
                                            .set({
                                              'date':
                                                  FieldValue.serverTimestamp(),
                                              'uid': widget.userId.uid,
                                              'reward': ((_net / (reward)) * 7),
                                              'done': false
                                            })
                                            .whenComplete(() => {
                                                  FirebaseFirestore.instance
                                                      .doc(
                                                          'punditUsers/$reward/user_profile/user_data')
                                                      .update({
                                                    'setReward': reward - 7,
                                                    'setPrice': (_net -
                                                        (_net / (reward)) * 7),
                                                  })
                                                })
                                            .whenComplete(() {
                                              setState(() {
                                                claimed = false;
                                              });
                                            });
                                      },
                                      child: Text(
                                        claimed ? 'Claimed' : 'Claim Reward',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w800),
                                      ))
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )
                        : Container(
                            width: 350,
                            height: 70,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.local_offer_sharp,
                                    color: Color(0XFFffbd59),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Complete 7 puja and claim your reward',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                Container(
                  height: height(200),
                  child: CarouselSlider.builder(
                      itemCount: sliderImages.length,
                      itemBuilder: (context, index, realint) {
                        return Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: width(300),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "${sliderImages[index].toString()}"),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: height(400),
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        //onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      )),
                ),
              ],
            ),
          ),
          Container(
            height: height(130),
            child: Center(
              child: Text(
                "Purohit Dashboard",
                style: TextStyle(
                    color: HexColor(titleColor),
                    fontWeight: FontWeight.bold,
                    fontSize: height(22)),
              ),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(banner), fit: BoxFit.fill),
                color: Colors.white,
                boxShadow: [
                  /* BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10.0,
                  ),*/
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 3.0,
                  )
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
          ),
          SizedBox(
            height: 120,
          ),
          Container(
            height: 500,
          )
        ],
      ),
    );
  }
}

class CustomGridTile extends StatelessWidget {
  final image;
  final Widget child;

  const CustomGridTile({Key key, this.image, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                height: MagicScreen(height: 660, context: context).getHeight,
                child: child);
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: MagicScreen(height: 50, context: context).getHeight,
          width: MagicScreen(height: 50, context: context).getHeight,
          child: Image.network(image),
          decoration: BoxDecoration(
              /* border: Border.all(
                color: Colors.black54, style: BorderStyle.solid, width: 0.5),*/
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: HexColor("#F4D27A"),
                  blurRadius: 5.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class ComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Coming soon",
        style: TextStyle(
            color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),
      ),
    );
  }
}