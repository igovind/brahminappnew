import 'dart:io';

import 'package:flutter/material.dart';

class CircularProfilePic extends StatelessWidget {
  final String? imageUrl;
  final File? fileSrc;
  final radius;
  final blurRadius;

  const CircularProfilePic(
      {Key? key,
      this.imageUrl,
      this.radius,
      this.blurRadius,
      this.fileSrc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fileSrc != null) {
      return Container(
        height: 2.0 * (radius ?? 60),
        decoration: BoxDecoration(
          color: Colors.white,
            image: DecorationImage(image: FileImage(fileSrc!)),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black38, blurRadius: blurRadius ?? 5)
            ]),
      );
    }
    if (imageUrl == null) {
      return Container(
        height: 2.0 * (radius ?? 60),
        decoration: BoxDecoration(
          color: Colors.white,
            image:
                DecorationImage(image: AssetImage('images/placeholder.jpg')),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black38, blurRadius: blurRadius ?? 5)
            ]),
      );
    }
    return Container(
      height: 2.0 * (radius ?? 60),
      decoration: BoxDecoration(
        color: Colors.white,
          image: DecorationImage(image: NetworkImage(imageUrl!)),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: blurRadius ?? 5)
          ]),
    );
  }
}
