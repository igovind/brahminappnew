import 'dart:io';

import 'package:brahminapp/services/media_querry.dart';
import 'package:flutter/material.dart';

class OkayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
class CircularAvatarNetwork extends StatelessWidget {
  final url;

  const CircularAvatarNetwork({Key? key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MagicScreen(height: 70,context: context).getHeight,
      width: MagicScreen(width: 70,context: context).getWidth,
      decoration: BoxDecoration(shape: BoxShape.circle,),
      child: Image.network(url),
    );
  }
}
class CircularAvatarAsset extends StatelessWidget {
  final src;

  const CircularAvatarAsset({Key? key, this.src}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MagicScreen(height: 70,context: context).getHeight,
      width: MagicScreen(width: 70,context: context).getWidth,
      decoration: BoxDecoration(shape: BoxShape.circle,),
      child: Image.asset(src),
    );
  }
}

class CircularAvatar extends StatelessWidget {
  final Widget? child;

  const CircularAvatar({Key? key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MagicScreen(height: 70,context: context).getHeight,
      width: MagicScreen(width: 70,context: context).getWidth,
      decoration: BoxDecoration(shape: BoxShape.circle,),
      child: child,
    );
  }
}