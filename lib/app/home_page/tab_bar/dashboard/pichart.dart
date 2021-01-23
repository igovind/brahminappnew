import 'package:brahminapp/app/home_page/tab_bar/dashboard/service_detail_dialog.dart';
import 'package:brahminapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Statistic extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> subscriberSnapshot;
  final AsyncSnapshot<QuerySnapshot> profitSnapshot;
  final String uid;

  const Statistic(
      {Key key,
      @required this.subscriberSnapshot,
      @required this.profitSnapshot,
      @required this.uid})
      : super(key: key);

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  List<charts.Series<Task, String>> _seriesSubscriberPieData;
  List<charts.Series<Task, String>> _seriesProfitPieData;

  _generateData() {
    final ref1 = widget.subscriberSnapshot.data.docs;
    final ref2 = widget.profitSnapshot.data.docs;
    var subscriberPieData = [
      new Task(ref1[0].data()['puja'],
          ref1[0].data()['subscriber'].roundToDouble(), Color(0xff3366cc)),
      new Task(ref1[1].data()['puja'],
          ref1[1].data()['subscriber'].roundToDouble(), Color(0xff990099)),
      new Task(ref1[2].data()['puja'],
          ref1[2].data()['subscriber'].roundToDouble(), Color(0xff109618)),
      new Task(ref1[3].data()['puja'],
          ref1[3].data()['subscriber'].roundToDouble(), Color(0xfffdbe19)),
      new Task(ref1[4].data()['puja'],
          ref1[4].data()['subscriber'].roundToDouble(), Color(0xffff9900)),
    ];
    double p1, p2, p3, p4, p5;
    p1 = ref2[0].data()['price'];
    p2 = ref2[1].data()['price'];
    p3 = ref2[2].data()['price'];
    p4 = ref2[3].data()['price'];
    p5 = ref2[4].data()['price'];

    var profitPieData = [
      new Task(ref2[0].data()['puja'], p1.roundToDouble(), Color(0xff3366cc)),
      new Task(ref2[1].data()['puja'], p2.roundToDouble(), Color(0xff990099)),
      new Task(ref2[2].data()['puja'], p3.roundToDouble(), Color(0xff109618)),
      new Task(ref2[3].data()['puja'], p4.roundToDouble(), Color(0xfffdbe19)),
      new Task(ref2[4].data()['puja'], p5.roundToDouble(), Color(0xffff9900)),
    ];

    _seriesSubscriberPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: subscriberPieData,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
    _seriesProfitPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air',
        data: profitPieData,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  void initState() {
    super.initState();
    _seriesSubscriberPieData = List<charts.Series<Task, String>>();
    _seriesProfitPieData = List<charts.Series<Task, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Your top 5 puja',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              // width:  MediaQuery.of(context).size.width*0.8,
              child: charts.PieChart(_seriesSubscriberPieData,
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  behaviors: [
                    new charts.DatumLegend(
                      outsideJustification:
                          charts.OutsideJustification.endDrawArea,
                      horizontalFirst: false,
                      desiredMaxRows: 5,
                      cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 10),
                    )
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.outside)
                      ])),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.deepOrange,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Maximum Profit',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              // width:  MediaQuery.of(context).size.width*0.8,
              child: charts.PieChart(_seriesProfitPieData,
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  behaviors: [
                    new charts.DatumLegend(
                      outsideJustification:
                          charts.OutsideJustification.endDrawArea,
                      horizontalFirst: false,
                      desiredMaxRows: 5,
                      cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 10),
                    )
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.outside)
                      ])),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.deepOrange,
            ),
            SizedBox(
              height: 2.0,
            ),
            Text(
              ' All services',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            allPujaStatistic(widget.uid, context),
            Divider(
              thickness: 0.5,
              color: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }
}

Widget allPujaStatistic(String uid, BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
      stream: FireStoreDatabase(uid: uid).getPujaOfferingList,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: Colors.deepOrange[50],
          child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                final String pid = snapshot.data.docs[index].id;
                return ListTile(
                  leading: Icon(Icons.details),
                  title: Text(snapshot.data.docs[index].data()['puja']),
                  trailing:
                      Text('${snapshot.data.docs[index].data()['subscriber']}'),
                  onTap: () {
                    int yearSub = 0;
                    int monthSub = 0;
                    int daySub = 0;
                    showDialog(
                      context: context,
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .doc(
                                  'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}')
                              .snapshots(),
                          builder: (context, yearSnapshot) {
                            if (yearSnapshot.data == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (yearSnapshot.data.data() == null) {
                              yearSub = 0;
                            } else {
                              yearSub = yearSnapshot.data.data()['total'];
                            }
                            return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .doc(
                                        'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}/months/${DateTime.now().month}')
                                    .snapshots(),
                                builder: (context, monthSnapshot) {
                                  if (monthSnapshot.data == null) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (monthSnapshot.data.data() == null) {
                                    monthSub = 0;
                                  } else {
                                    monthSub =
                                        monthSnapshot.data.data()['total'];
                                  }
                                  return StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .doc(
                                              'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}/months/${DateTime.now().month}/days/${DateTime.now().day}')
                                          .snapshots(),
                                      builder: (context, daySnapshot) {
                                        if (daySnapshot.data == null) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (daySnapshot.data.data() == null) {
                                          daySub = 0;
                                        } else {
                                          daySub =
                                              daySnapshot.data.data()['total'];
                                        }
                                        return ServiceDetailDialog(
                                          uid: uid,
                                          serviceId: pid,
                                          yearData: yearSub,
                                          monthdata: monthSub,
                                          dayData: daySub,
                                        );
                                      });
                                });
                          }),
                      useRootNavigator: true,
                    );
                  },
                );
              }),
        );
      });
}

/*_datafun(String pid, String uid) {
  final yearPath =
      'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}';
  final monthPath =
      'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}/months/${DateTime.now().month}';
  final dayPath =
      'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}/months/${DateTime.now().month}/days/${DateTime.now().day}';
  final snapshot1 = FirebaseFirestore.instance.doc(yearPath).snapshots();
  snapshot1.listen((event) {});
}*/
