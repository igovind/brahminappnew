import 'package:brahminapp/app/home_page/drawer_tiles/astrology/astrology_form.dart';
import 'package:flutter/material.dart';

class AstrologySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astrology Services'),
        toolbarHeight: 100,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AstrologyForm()),
          );
        },
      ),
    );
  }
}
