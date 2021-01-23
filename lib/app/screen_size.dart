import 'package:flutter/material.dart';

class ScreenSize {
  final double value;
  final BuildContext context;

  ScreenSize({this.context, this.value});

   double get getHeight => (MediaQuery.of(context).size.height) / value;

   double get getWidth => (MediaQuery.of(context).size.width) / value;
}
