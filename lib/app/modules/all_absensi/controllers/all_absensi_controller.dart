import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllAbsensiController extends GetxController {
  DateTime? start;
  DateTime end = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //TODO: Implement AllAbsensiController
  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    String uid = auth.currentUser!.uid;

    if (start == null) {
      // ? Get To Last RealTime
      return await firestore
          .collection('student')
          .doc(uid)
          .collection('presence')
          .where('date', isLessThan: end)
          .orderBy('date', descending: true)
          .get();
    } else {
      return await firestore
          .collection('student')
          .doc(uid)
          .collection('presence')
          .where('date', isGreaterThan: start)
          .where('date', isLessThan: end)
          .orderBy('date', descending: true)
          .get();
    }
  }
}
