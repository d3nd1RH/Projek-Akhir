import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  final form = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseFirestore.instance.collection("userdata");
  final TextEditingController nama = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordconfirm = TextEditingController();
   var obscurePassText = true.obs;
   var obscureCoritmText = true.obs;

   void togglePasswordconfirmVisibility() {
    obscureCoritmText.value = !obscureCoritmText.value;
  }

  void togglePasswordVisibility() {
    obscurePassText.value = !obscurePassText.value;
  }

  Future<void> register(
    String email,
    String password,
    String nama,
  ) async {
    try {
      final akun = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uidname = akun.user!.uid;
      akun.user!.sendEmailVerification();
      final doc = user.doc(uidname);
      final data = {
        "peran": "Lainnya",
        "uid": uidname,
        "nama": nama
      };
      doc.set(data);
      Get.snackbar("Catatan", "Tolong cek Email anda",
          backgroundColor: Colors.yellow);
      Get.offNamed("/login");
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        Get.snackbar("Error", "Password Terlalu lemah",
            backgroundColor: Colors.red);
      } else if (e.code == "email-already-in-use") {
        Get.snackbar("Error", "Email sudah di gunakan",
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Error", "$e", backgroundColor: Colors.red);
      }
    }
  }

  @override
  void onClose() {
    email.clear();
    password.clear();
    passwordconfirm.clear();
    super.onClose();
  }
}
