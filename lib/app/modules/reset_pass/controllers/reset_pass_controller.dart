import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassController extends GetxController {
  final TextEditingController reset = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> resetpass(
    String email
  )async{
    await Get.defaultDialog(
      title: "Reset Password",
      titleStyle: const TextStyle(color : Colors.black,fontWeight: FontWeight.bold),
      middleText: "Apakah Anda Yakin Untuk Mereset password?",
      middleTextStyle: const TextStyle(color: Colors.black),
      textCancel: "Tidak",
      onCancel: (){
        return;
      },
      textConfirm: "Ya",
      onConfirm: () async{
        await auth.sendPasswordResetEmail(email: email);
        Get.back();
      },
    );
    Get.back();
  }
}
