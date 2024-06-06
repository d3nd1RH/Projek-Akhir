import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late Map<String, dynamic> userData;

  Future<void> getUserData(String uid) async {
    // Mendapatkan data pengguna dari Firebase Cloud Firestore
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .get();
    userData = doc.data() ?? {};
    update();
  }

  Future<void> updateUserData(String uid) async {
    // Menyimpan data pengguna ke Firebase Cloud Firestore
    await FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .set(userData);
  }
}
