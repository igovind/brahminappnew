import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserDetails {
  final AsyncSnapshot<DocumentSnapshot> snapshot;

  UserDetails({@required this.snapshot});

  String get name => snapshot == null ? "" : snapshot.data.data()["firstName"];

  String get aboutYou =>
      snapshot == null ? "" : snapshot.data.data()["aboutYou"];

  String get contact => snapshot == null ? "" : snapshot.data.data()["number"];

  String get refCode =>
      snapshot == null ? "" : snapshot.data.data()["refCode"] ?? "000";

  String get state => snapshot == null ? "" : snapshot.data.data()["state"];
  String get language => snapshot == null ? "" : snapshot.data.data()["langCode"];

  String get city => snapshot == null ? "" : snapshot.data.data()["lastName"];

  String get type => snapshot == null ? "" : snapshot.data.data()["type"];

  String get profilePhoto => snapshot == null
      ? "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1214428300?k=6&m=1214428300&s=612x612&w=0&h=rvt5KGND3z8kfrHELplF9zmr8d6COZQ-1vYK9mvSxnc="
      : snapshot.data.data()["profilePicUrl"];

  String get coverPhoto => snapshot == null
      ? "https://woodfordoil.com/wp-content/uploads/2018/02/placeholder.jpg"
      : snapshot.data.data()["coverpic"];

  String get uid => snapshot == null ? "" : snapshot.data.data()["uid"];

  bool get verified =>
      snapshot == null ? false : snapshot.data.data()["verified"];

  bool get astrologer =>
      snapshot == null ? false : snapshot.data.data()["astrologer"];

  double get setReward =>
      snapshot == null ? null : snapshot.data.data()["setReward"];

  double get setPrice =>
      snapshot == null ? null : snapshot.data.data()["setPrice"];

  double get swastik =>
      snapshot == null ? null : snapshot.data.data()["swastik"];
}
