import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
   Future<void> logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed("/login"); // Mengarahkan pengguna ke halaman login setelah logout
    } catch (e) {
      Get.snackbar("Error", "Error during logout: $e", backgroundColor: Colors.red);
    }
  }
}
