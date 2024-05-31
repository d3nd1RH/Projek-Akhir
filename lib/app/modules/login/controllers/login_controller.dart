import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final forum = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password= TextEditingController();
  final auth = FirebaseAuth.instance;
  Future<void> login(
    String email ,
    String password
    )async{
    try{
      UserCredential userlogin = await auth.signInWithEmailAndPassword(email: email, password: password);
      if(userlogin.user!.emailVerified){
        Get.snackbar("Success", "Berhasil login",backgroundColor: Colors.green);
        Get.toNamed("/home");
      }else{
        Get.snackbar("Error", "Tolong Verifikasi Email anda",backgroundColor: Colors.red);
      }
    }on FirebaseAuthException catch(e){
      if(e.code=="user-not-found"){
        Get.snackbar("Error", "Pengguna Tidak Di Temukan",backgroundColor: Colors.red);
      }else if(e.code == "wrong-password"){
        Get.snackbar("Error", "Password Salah",backgroundColor: Colors.red);
      }else if(e.code == "too-many-requests"){
        Get.snackbar("Error", "Pelan-Pelan saja",backgroundColor: Colors.red);
      }else{
        Get.snackbar("Error", "$e",backgroundColor: Colors.red);
      }
    }
  }
}
