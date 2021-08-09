import 'package:brahminapp/app/languages.dart';
import 'package:brahminapp/app/services_given/puja_offering.dart';
import 'package:brahminapp/services/auth.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/services/media_querry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class ServicesPage extends StatefulWidget {
  final UserId? userId;
  final language;
  final bgImg;
  final check;
  final AsyncSnapshot<DocumentSnapshot> userData;

  const ServicesPage(
      {Key? key,
      this.userId,
      this.language,
      required this.userData,
      this.bgImg,
      this.check})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomeWidgetState();
  }
}

class HomeWidgetState extends State<ServicesPage>
    with SingleTickerProviderStateMixin {
  late List<Tab> tabs;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    tabs = <Tab>[
      Tab(
        text: Language(code: widget.language, text: [
          "Puja service ",
          "पूजा सेवा ",
          "পূজা সেবা ",
          "பூஜா சேவை ",
          "పూజా సేవ "
        ]).getText,
      ),
      // Tab(text: "Astrology offering"),
    ];
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height(double height) {
      return MagicScreen(context: context, height: height).getHeight;
    }

    return Scaffold(
        appBar: widget.check!=null?AppBar(actions: [TextButton(
            onPressed: () {
              FireStoreDatabase(uid: widget.userId!.uid)
                  .updateData(data: {"ready": true});
            },
            child: Text(
              "Skip",
              style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold),
            )),],backgroundColor: Colors.white,elevation: 0,): AppBar(
          toolbarHeight: height(65),
          backgroundColor: Colors.white,
          actions: [
           /* widget.check == null
                ? SizedBox()
                : */
          ],
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BubbleTabIndicator(
              indicatorHeight: height(25),
              indicatorColor: Colors.deepOrangeAccent,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              // Other flags
              // indicatorRadius: 1,
              // insets: EdgeInsets.all(1),
              // padding: EdgeInsets.all(10)
            ),
            tabs: tabs,
            controller: _tabController,
          ),
        ),
        //backgroundColor: Colors.grey[100],

        body: StreamBuilder<QuerySnapshot>(
            stream:
                FireStoreDatabase(uid: widget.userId!.uid).getPujaOfferingList,
            builder: (context, pujaOfferingSnapshot) {
              if (pujaOfferingSnapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StreamBuilder<QuerySnapshot>(
                  stream:
                      FireStoreDatabase(uid: widget.userId!.uid).getAstroList,
                  builder: (context, astroOfferingSnapshot) {
                    if (astroOfferingSnapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return TabBarView(controller: _tabController, children: [
                      PujaOffering(
                        snapshot: pujaOfferingSnapshot,
                        uid: widget.userId!.uid,
                        language: widget.language,
                        userData: widget.userData,
                      ),
                      // AstroOffering(snapshot: pujaOfferingSnapshot,userId: widget.userId,),
                    ]);
                  });
            }));
  }
}
