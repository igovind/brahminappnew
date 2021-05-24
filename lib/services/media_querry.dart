import 'package:flutter/cupertino.dart';

class MagicScreen {
  final double? height;
  final double? width;
  final BuildContext context;

  MagicScreen({this.height, this.width,required this.context});

  double get getHeight {
    return MediaQuery.of(context).size.height * (height! / 760.0);
  }

  double get getWidth {
    return MediaQuery.of(context).size.width * (width! / 360.0);
  }
}
