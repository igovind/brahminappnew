import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'calendar_body.dart';
import 'calendar_model.dart';
import 'date_jump.dart';



class HindiCalender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<CalendarModel>(
      model: CalendarModel(),
      child: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this._appBar(),
      body: CalendarBody(),
    );
  }

  Widget _appBar() {
    final iconTheme = IconThemeData(color: Colors.grey[700]);

    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: iconTheme,
      elevation: 0,
      actions: <Widget>[
        ScopedModelDescendant<CalendarModel>(
          builder: (context, child, model) {
            return IconButton(
              icon: Icon(Icons.today),
              onPressed: () => model.setCalendarMonth(DateTime.now()),
              tooltip: 'आज',
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.directions_run),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DateJumpDialog(),
            );
          },
          tooltip: 'अर्को मितिमा जाने',
        )
      ],
    );
  }
}
