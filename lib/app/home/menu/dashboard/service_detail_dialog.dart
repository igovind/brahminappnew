import 'package:brahminapp/app/home/menu/dashboard/simple_bar_graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<int> yearListX = [];
List<int> yearListY = [];
List<int> monthListX = [];
List<int> monthListY = [];
List<int> dayListX = [];
List<int> dayListY = [];
List<int> hourListX = [];
List<int> hourListY = [];
int thisYear;
int thisMonth;
int thisDay;
int thisHour;

class ServiceDetailDialog extends StatefulWidget {
  final String uid;
  final String serviceId;
  final yearData;
  final monthdata;
  final dayData;

  const ServiceDetailDialog(
      {Key key,
      @required this.uid,
      @required this.serviceId,
      this.yearData,
      this.monthdata,
      this.dayData})
      : super(key: key);

  @override
  _ServiceDetailDialogState createState() => _ServiceDetailDialogState();
}

class _ServiceDetailDialogState extends State<ServiceDetailDialog> {
  @override
  void initState() {
    _retriveData(
        listY: yearListY,
        listX: yearListX,
        uid: widget.uid,
        pid: widget.serviceId,
        type: 'year');
    _retriveData(
        listY: monthListY,
        listX: monthListX,
        uid: widget.uid,
        pid: widget.serviceId,
        type: 'month');
    _retriveData(
        listY: dayListY,
        listX: dayListX,
        uid: widget.uid,
        pid: widget.serviceId,
        type: 'day');
    _retriveData(
        listY: hourListY,
        listX: hourListX,
        uid: widget.uid,
        pid: widget.serviceId,
        type: 'hour');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildBox(BuildContext context) {
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.height;
      return WillPopScope(
        onWillPop: () async {
          //data1.clear();
          return true;
        },
        child: Card(
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.deepOrange[50],
            height: height * 0.3,
            width: width * 0.9,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'On this year',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text('${widget.yearData}',
                          style: TextStyle(fontSize: 12)),
                      FlatButton(
                        child: Text('See analytics',
                            style: TextStyle(fontSize: 12, color: Colors.red)),
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              child: PlotSimpleGraphBar(
                                listX: monthListX,
                                listY: monthListY,
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 0.4, color: Colors.deepOrange),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'On this month',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text('${widget.monthdata}',
                          style: TextStyle(fontSize: 12)),
                      FlatButton(
                        child: Text('See analytics',
                            style: TextStyle(fontSize: 12, color: Colors.red)),
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              child: PlotSimpleGraphBar(
                                listX: dayListX,
                                listY: dayListY,
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 0.5, color: Colors.deepOrange),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'On this day',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text('${widget.dayData}', style: TextStyle(fontSize: 12)),
                      FlatButton(
                        child: Text('See analytics',
                            style: TextStyle(fontSize: 12, color: Colors.red)),
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            child: PlotSimpleGraphBar(
                              listX: hourListX,
                              listY: hourListY,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final double screenLength = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        thisYear = null;
        thisMonth = null;
        thisDay = null;
        thisHour = null;
        return true;
      },
      child: Center(
        child: Container(
          height: screenLength * 0.7,
          width: screenWidth * 0.9,
          child: Scaffold(
            body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('punditUsers/${widget.uid}/puja_offering')
                  .doc(widget.serviceId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                double pr = snapshot.data.data()['price'];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        snapshot.data.data()['puja'],
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.deepOrange,
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.deepOrange[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total subscribers',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${snapshot.data.data()['subscriber']}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.deepOrange[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total Swastik gained',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${snapshot.data.data()['swastik']}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.deepOrange[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total profit',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '₹${pr.roundToDouble()}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildBox(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

_retriveData(
    {String uid,
    String pid,
    List<int> listX,
    List<int> listY,
    String type}) async {
  final yearPath = 'punditUsers/$uid/puja_offering/$pid/subscribers';
  final monthPath =
      'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}/months';
  final dayPath =
      'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}/months/${DateTime.now().month}/days';
  final hourPath =
      'punditUsers/$uid/puja_offering/$pid/subscribers/${DateTime.now().year}/months/${DateTime.now().month}/days/${DateTime.now().day}/hours';

  String path;
  if (type == 'year') {
    path = yearPath;
  }
  if (type == 'month') {
    path = monthPath;
  }
  if (type == 'day') {
    path = dayPath;
  }
  if (type == 'hour') {
    path = hourPath;
  }

  final QuerySnapshot snap =
      await FirebaseFirestore.instance.collection(path).get();
  for (int i = 0; i < snap.docs.length; i++) {
    var a = snap.docs[i].id;
    var b = int.parse(a);
    var c = snap.docs[i].data()['total'];

    listX.add(b);
    listY.add(c);
  }
  print(listX);
  print(listY);
  if (type == 'year') {
    if (listX.contains(DateTime.now().year)) {
      int f = listX.indexOf(DateTime.now().year);
      thisYear = listY[f];
    } else {
      thisYear = 0;
    }
  }
  if (type == 'month') {
    if (listX.contains(DateTime.now().month)) {
      int f = listX.indexOf(DateTime.now().month);
      thisMonth = listY[f];
    } else {
      thisMonth = 0;
    }
  }
  if (type == 'day') {
    if (listX.contains(DateTime.now().day)) {
      int f = listX.indexOf(DateTime.now().day);
      thisDay = listY[f];
    } else {
      thisDay = 0;
    }
  }
  if (type == 'hour') {
    if (listX.contains(DateTime.now().hour)) {
      int f = listX.indexOf(DateTime.now().hour);
      thisHour = listY[f];
    } else {
      thisHour = 0;
    }
  }
}
