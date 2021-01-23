import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService{
  Future<void> setData({String path, Map<String, dynamic>data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference =FirebaseFirestore.instance.collection(path).orderBy('timestrap');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.reversed.map((snapshot) => builder(snapshot.data())).toList());
  }
}