import 'package:brahminapp/Chat/ChatListModal.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'api.dart';
import 'firestore.dart';

abstract class DatabaseL {
  Stream<List<ChatListModal>> readChatlist();

  Future<void> setData({
    @required Map<String, dynamic> data,
  });

  Future<void> updateBooking(
      {@required String tuid,
      @required String tid,
      @required bool bookingAccepted,
      @required String serviceId,
      @required String pPic,
      @required String service});

  Stream<QuerySnapshot> get getTrendingList;

  Stream<QuerySnapshot> get getPujaOfferingList;

  Stream<QuerySnapshot> get getBookingRequest;

  Stream<QuerySnapshot> get getUpComingPuja;

  Stream<QuerySnapshot> get getOrderdPujaOfferingListBySubscriber;

  Stream<QuerySnapshot> get getOrderdPujaOfferingListByProfit;

  Future<void> setUserUid({
    @required Map<String, dynamic> data,
  });

  Future<void> setPujaOffering({
    @required Map<String, dynamic> data,
    @required String pid,
  });

  Future<void> updatePujaOffering({
    @required Map<String, dynamic> data,
    @required String pid,
  });

  Future<void> bookingStatus(
      {@required Map<String, dynamic> data,
      @required String tuid,
      @required tid});

  Stream<DocumentSnapshot> get getUserData;

  Future<void> deletepuja(String id);

  Stream<QuerySnapshot> get getUsers;
}

class FireStoreDatabase implements DatabaseL {
  FireStoreDatabase({@required this.uid});

  final dynamic uid;
  final id = DateTime.now();
  final _service = FirestoreService();
  final fireStore = FirebaseFirestore.instance;

  Future<void> setData({
    @required Map<String, dynamic> data,
  }) async {
    String path = 'punditUsers/$uid/user_profile/user_data';
    String path1 = 'Avaliable_pundit/$uid';
    final reference = fireStore.doc(path);
    final reference1 = fireStore.doc(path1);
    await reference.set(data);
    await reference1.set(data);
    print('$path: $data');
  }

  Future<void> updateData({
    @required Map<String, dynamic> data,
  }) async {
    String path = 'punditUsers/$uid/user_profile/user_data';
    String path1 = 'Avaliable_pundit/$uid';
    final reference = fireStore.doc(path);
    final reference1 = fireStore.doc(path1);
    await reference.update(data);
    await reference1.update(data);
    print('$path: $data');
  }

  @override
  Stream<List<ChatListModal>> readChatlist() => _service.collectionStream(
      path: APIPath.readChatlist(uid),
      builder: (data) => ChatListModal.fromMap(data));

  Future<void> deletepuja(String pid) async {
    String path1 = 'Avaliable_pundit/$uid/puja_offering/$pid';
    String path = 'punditUsers/$uid/puja_offering/$pid';
    final reference1 = fireStore.doc(path1);
    final reference = fireStore.doc(path);
    await reference.delete();
    await reference1.delete();
  }

  @override
  Future<void> setUserUid({
    @required Map<String, dynamic> data,
  }) async {
    String path = 'Avaliable_pundit/$uid';
    final reference = fireStore.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  @override
  Future<void> bookingStatus(
      {@required Map<String, dynamic> data,
      @required String tuid,
      @required tid}) async {
    String path = 'users/$tuid/bookings/$tid';
    String path1 = 'punditUsers/$uid/bookingrequest/$tid';

    final reference = fireStore.doc(path);
    final reference1 = fireStore.doc(path1);
    print('$path: $data');
    await reference.set(data);
    await reference1.set(data);
  }

  @override
  Future<void> setPujaOffering({
    @required Map<String, dynamic> data,
    @required String pid,
  }) async {
    String path1 = 'Avaliable_pundit/$uid/puja_offering/$pid';
    String path = 'punditUsers/$uid/puja_offering/$pid';
    final reference1 = fireStore.doc(path1);
    final reference = fireStore.doc(path);
    print('$path: $data');
    await reference.set(data);
    await reference1.set(data);
    print('$path: $data');
  }

  Future<void> updatePujaOffering({
    @required Map<String, dynamic> data,
    @required String pid,
  }) async {
    String path1 = 'Avaliable_pundit/$uid/puja_offering/$pid';
    String path = 'punditUsers/$uid/puja_offering/$pid';
    final reference1 = fireStore.doc(path1);
    final reference = fireStore.doc(path);
    print('$path: $data');
    await reference.update(data);
    await reference1.update(data);
    print('$path: $data');
  }

  Stream<QuerySnapshot> get getTrendingList {
    return fireStore.collection('Category').snapshots();
  }

  @override
  Stream<DocumentSnapshot> get getUserData {
    return fireStore.doc('punditUsers/$uid/user_profile/user_data').snapshots();
  }

  @override
  Stream<QuerySnapshot> get getUsers {
    return fireStore.collection('Avaliable_pundit').snapshots();
  }

  Stream<DocumentSnapshot> get getAdhaarDetails {
    return fireStore
        .doc('punditUsers/$uid/user_profile/user_adhaar_details')
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> get getPujaOfferingList {
    return fireStore.collection('punditUsers/$uid/puja_offering').snapshots();
  }

  Stream<QuerySnapshot> get getTrendingPujaList {
    return fireStore.collection('Trending').orderBy('num').snapshots();
  }

  Stream<DocumentSnapshot> get getPunditTypes {
    return fireStore.doc('inventories/punditTypes').snapshots();
  }

  Stream<QuerySnapshot> get getOrderdPujaOfferingListBySubscriber {
    return fireStore
        .collection('punditUsers/$uid/puja_offering')
        .orderBy('subscriber', descending: true)
        .snapshots();
  }

  setPujaStatus({String bookingId, String tuid}) {
    fireStore
        .doc('users/$tuid/bookings/$bookingId')
        .update({'puja_status': true}).whenComplete(() => print("yess"));
    fireStore
        .doc('punditUsers/$uid/upComingPuja/$bookingId')
        .update({'puja_status': true}).whenComplete(() => print("oh yes"));
  }

  setHistory(String bookingId) {
    fireStore
        .doc('punditUsers/$uid/upComingPuja/$bookingId')
        .snapshots()
        .listen((event) {
      print('in history data is:${event.data}');
      fireStore
          .collection('punditUsers/$uid/history')
          .doc(bookingId)
          .set(event.data())
          .whenComplete(() {
        fireStore
            .collection('inventories/totalPuja/folder')
            .doc('${DateTime.now()}')
            .set(event.data());
      }).whenComplete(() {
        fireStore
            .doc('inventories/totalPuja')
            .update({'totalBooking': FieldValue.increment(1)});
      }).whenComplete(() {
        fireStore
            .collection('inventories/purohitBookingHistory/$uid')
            .doc(bookingId)
            .set(event.data());
      }).whenComplete(() {
        Future.delayed(const Duration(milliseconds: 2000)).whenComplete(() {
          fireStore
              .collection('punditUsers/$uid/upComingPuja')
              .doc('$bookingId')
              .delete();
        });
      });
    });
  }

  delUpComingPuja(String bookingId) async {
    await fireStore
        .collection('punditUsers/$uid/upComingPuja')
        .doc('$bookingId')
        .delete();
  }

  setReward({String bookingId, double price}) {
    fireStore
        .doc('punditUsers/$uid/history/$bookingId')
        .snapshots()
        .listen((event) {
      fireStore
          .collection('punditUsers/$uid/reward')
          .doc(bookingId)
          .set(event.data());
    });
  }
//update
  Stream<QuerySnapshot> get getHistory {
    return fireStore
        .collection('punditUsers/$uid/history')
        .orderBy('timestrap')
        .snapshots();
  }

  Stream<QuerySnapshot> get getPaymentHistory {
    return fireStore
        .collection('punditUsers/$uid/paymentHistory')
        .where('ConfirmPayment', isEqualTo: true)
        //.orderBy('timestrap',descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> get getBankDetails {
    return fireStore
        .doc('punditUsers/$uid/user_profile/user_bank_details')
        .snapshots();
  }

  Stream<QuerySnapshot> get getRewadsList {
    return fireStore
        .collection('rewardClaim')
        .orderBy('date')
        .where('uid', isEqualTo: uid)
        .where('done', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> get getOrderdPujaOfferingListByProfit {
    return fireStore
        .collection('punditUsers/$uid/puja_offering')
        .orderBy('profit', descending: true)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> get getBookingRequest {
    return fireStore
        .collection('punditUsers/$uid/bookingrequest')
        .orderBy('timestrap', descending: true)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> get getUpComingPuja {
    return fireStore
        .collection('punditUsers/$uid/upComingPuja')
        .orderBy('timestrap', descending: false)
        .snapshots();
  }

  setKeyword(dynamic data) {
    fireStore.doc('Avaliable_pundit/$uid').update({
      'PujaKeywords': FieldValue.arrayUnion([data])
    });
  }

  updateKeyword(dynamic data) {
    fireStore.doc('Avaliable_pundit/$uid').update({
      'PujaKeywords': FieldValue.arrayUnion([data])
    });
  }

  @override
  Future<void> updateBooking(
      {@required String tuid,
      @required String tid,
      @required bool bookingAccepted,
      @required String serviceId,
      @required String pPic,
      @required String service}) async {
    final String bookingResponce = bookingAccepted ? 'request' : 'rejected';
    fireStore
        .collection('punditUsers/$uid/bookingrequest')
        .doc(tid)
        .update({bookingResponce: true});

    fireStore
        .collection('users/$tuid/bookings')
        .doc(tid)
        .update({bookingResponce: true});
    if (!bookingAccepted) {
      fireStore.collection('punditUsers/$uid/bookingrequest').doc(tid).delete();
    } else {
      //_statsDataFunction(serviceId);

/*      final snapshot = await Firestore.instance
          .collection('punditUsers/$uid/bookingrequest')
          .document(tid)
          .get();
      final dat = snapshot.data;
      print(dat);
      await Firestore.instance
          .document('punditUsers/$uid/upComingPuja/$tid')
          .setData(dat);*/
/*      await Firestore.instance
          .document('punditUsers/$uid/bookingrequest/$tid')
          .delete();*/
      //setUpcomingPuja(tData,tid,tuid);
    }
    final String picPath = 'punditUsers/$uid/notification';
    final String putPath = 'users/$tuid/notification';
    final DocumentSnapshot dSnapshot =
        await fireStore.collection(picPath).doc(tid).get();
    final String acceptText =
        'Your request is accepted please proceed for payment';
    final String rejectText = 'Your request is declined';

    fireStore.collection(putPath).doc(tid).set({
      'content': bookingAccepted ? acceptText : rejectText,
      'sender': service,
      'image': pPic,
      'token': dSnapshot.data()['utoken'],
      'btoken': dSnapshot.data()['token'],
      'clientuid': tuid
    });
  }
}
/*

setAnalytics(String uid, String serviceId, double price) async {
  FirebaseFirestore.instance
      .collection('punditUsers/$uid/puja_offering')
      .document(serviceId)
      .updateData({'subscriber': FieldValue.increment(1)});
  FirebaseFirestore.instance
      .collection('punditUsers/$uid/puja_offering')
      .document(serviceId)
      .updateData({'profit': FieldValue.increment(price)});
  var gid = DateTime.now().year.toString();
  final snapShot = await FirebaseFirestore.instance
      .collection('punditUsers/$uid/puja_offering/$serviceId/subscribers')
      .document('$gid')
      .get();
  if (snapShot == null || !snapShot.exists) {
    FirebaseFirestore.instance
        .document('punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid')
        .setData({'total': 1, 'profit': price}).whenComplete(
            () => print('1st'));
  } else {
    FirebaseFirestore.instance
        .collection('punditUsers/$uid/puja_offering/$serviceId/subscribers')
        .document('$gid')
        .updateData({
      'total': FieldValue.increment(1),
      'profit': FieldValue.increment(price)
    }).whenComplete(() => print('1st'));
  }
  var gid2 = DateTime.now().month;
  final snapShot2 = await FirebaseFirestore.instance
      .collection(
          'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months')
      .document('$gid2')
      .get();
  if (snapShot2 == null || !snapShot2.exists) {
    FirebaseFirestore.instance
        .document(
            'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months/$gid2')
        .setData({'total': 1, 'profit': price}).whenComplete(
            () => print('2nd'));
  } else {
    print('present bhai 2');
    FirebaseFirestore.instance
        .collection(
            'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months')
        .document('$gid2')
        .updateData({
      'total': FieldValue.increment(1),
      'profit': FieldValue.increment(price)
    }).whenComplete(() => print('2nd'));
  }
  var gid3 = DateTime.now().day;
  final snapShot3 = await FirebaseFirestore.instance
      .collection(
          'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months/$gid2/days')
      .document('$gid3')
      .get();
  if (snapShot3 == null || !snapShot3.exists) {
    FirebaseFirestore.instance
        .document(
            'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months/$gid2/days/$gid3')
        .setData({
      'total': FieldValue.increment(1),
      'profit': price
    }).whenComplete(() => print('3rd'));
  } else {
    FirebaseFirestore.instance
        .collection(
            'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months/$gid2/days')
        .document('$gid3')
        .updateData({
      'total': FieldValue.increment(1),
      'profit': FieldValue.increment(price)
    }).whenComplete(() => print('3rd'));
  }
  var gid4 = DateTime.now().hour;
  final snapShot4 = await FirebaseFirestore.instance
      .collection(
          'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months/$gid2/days/$gid3/hours')
      .document('$gid4')
      .get();
  if (snapShot4 == null || !snapShot4.exists) {
    FirebaseFirestore.instance
        .document(
            'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months/$gid2/days/$gid3/hours/$gid4')
        .setData({
      'total': FieldValue.increment(1),
      'profit': price
    }).whenComplete(() => print('4th'));
  } else {
    print('yes present bhai 4 ${snapShot4.data}');
    FirebaseFirestore.instance
        .collection(
            'punditUsers/$uid/puja_offering/$serviceId/subscribers/$gid/months/$gid2/days/$gid3/hours')
        .document('$gid4')
        .updateData({
      'total': FieldValue.increment(1),
      'profit': FieldValue.increment(price)
    }).whenComplete(() => print('4th'));
  }
}
*/
