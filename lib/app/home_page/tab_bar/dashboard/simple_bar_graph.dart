import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

List<Pollution> data1 = [];

class Pollution {
  String place;
  int quantity;

  Pollution(this.place, this.quantity);
}

class PlotSimpleGraphBar extends StatefulWidget {
  final List<int> listX;
  final List<int> listY;

  const PlotSimpleGraphBar({Key key, this.listX, this.listY}) : super(key: key);

  @override
  _PlotSimpleGraphBarState createState() => _PlotSimpleGraphBarState();
}

class _PlotSimpleGraphBarState extends State<PlotSimpleGraphBar> {
  List<charts.Series<Pollution, String>> _seriesData;

  _generateData() {
    for (int i = 0; i < widget.listX.length; i++) {
      data1.add(Pollution('${widget.listX[i]}', widget.listY[i]));
    }
    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<Pollution, String>>();
    _generateData();
  }
@override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenLength = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        data1.clear();
        return true;
      },
      child: Center(
        child: Container(
          height: screenLength * 0.7,
          width: screenWidth * 0.9,
          color: Colors.deepOrange[50],
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    data1.clear();
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: charts.BarChart(
                    _seriesData,
                    animate: true,
                    barGroupingType: charts.BarGroupingType.grouped,
                    //behaviors: [new charts.SeriesLegend()],
                    animationDuration: Duration(seconds: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
