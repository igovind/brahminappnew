import 'package:brahminapp/app/home/menu/panchang/panchang_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PanchangSection extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot> userSnap;
  final AsyncSnapshot<DocumentSnapshot> snapshot;
  final String bgImg;

  const PanchangSection(
      {Key? key,
      required this.userSnap,
      required this.bgImg,
      required this.snapshot})
      : super(key: key);

  @override
  _PanchangSectionState createState() => _PanchangSectionState();
}

class _PanchangSectionState extends State<PanchangSection> {
  int index = 0;
  bool set = false;
  List<dynamic> listOfPanchang = [];

  @override
  void initState() {
    listOfPanchang = widget.snapshot.data!.get("dailyPanchang");
    listOfPanchang.sort((a, b) => (b["date"]).compareTo(a["date"]));
    List<String> dateList = [];
    listOfPanchang.forEach((element) {
      DateTime date = element["date"].toDate();
      dateList.add("${date.day}-${date.month}-${date.year}");
    });
    if (dateList.contains(
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}")) {
      setState(() {
        index = dateList.indexOf(
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
    actions: [ IconButton(
      onPressed: () {
        int k = index;
        setState(() {
          set = true;
          k > (listOfPanchang.length - 2)
              ? index = (listOfPanchang.length - 2)
              : index = k;
          index = index + 1;
        });
      },
      icon: Icon(Icons.navigate_before),
    ),
    IconButton(
      onPressed: () {
        int k = index;
        setState(() {
          set = true;
          k = k - 1;
          k < 0 ? index = 0 : index = k;
        });
      },

      icon: Icon(Icons.navigate_next),
    ),],
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
    centerTitle: true,
      ),
      body: Column(children: [
        SizedBox(height: 20,),
        PanchangCard(
          userData: widget.userSnap,
          bgImage: widget.bgImg,
          text: listOfPanchang[index]["panchang"],
          date: listOfPanchang[index]["date"].toDate(),
        ),
      ],)

    );
    // index=
    // print(panchang);

    /*    return Container(
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                scrollDirection: Axis.horizontal,
                itemCount: count,
                itemBuilder: (context, index) {
                  String text = panchang[count - index - 1][1];
                  return PanchangTile(
                    date: dates[count - index - 1],
                    text: text,
                  );

                }),
          );*/
  }
}
