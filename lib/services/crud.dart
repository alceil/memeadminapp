import 'package:cloud_firestore/cloud_firestore.dart';

class addmethods {
  Future<void> addData(desc, String loc) async {
    Firestore.instance.collection(loc).add(desc).catchError((e) {
      print(e);
    });
  }

  Future<void> addCat(desc) async {
    Firestore.instance.collection('categories').add(desc).catchError((e) {
      print(e);
    });
  }

  Future<void> addGen(desc) async {
    Firestore.instance.collection('general').add(desc).catchError((e) {
      print(e);
    });
  }
}
