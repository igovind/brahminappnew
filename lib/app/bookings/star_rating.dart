import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double? swastik;

  const StarRating({Key? key, this.swastik}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(swastik==0){
      return Row(
        children: [
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==0.5){
      return Row(
        children: [
          Icon(Icons.star_half,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==1){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==1.5){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star_half,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==2){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==2.5){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star_half,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==3){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==3.5){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star_half,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==4){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star_border,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==4.5){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star_half,color: Colors.deepOrangeAccent)
        ],
      );
    }
    if(swastik==5){
      return Row(
        children: [
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent),
          Icon(Icons.star,color: Colors.deepOrangeAccent)
        ],
      );
    }
    return Icon(Icons.star_border);

  }
}
