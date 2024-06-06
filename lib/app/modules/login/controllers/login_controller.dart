import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final forum = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password= TextEditingController();
  final auth = FirebaseAuth.instance;
  Stream<User?> get streamAuthStatus =>
      FirebaseAuth.instance.authStateChanges();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   var obscurePassText = true.obs;

   void togglePasswordVisibility() {
    obscurePassText.value = !obscurePassText.value;
  }


  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('userdata').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.get('peran');
      }
    } catch (e) {
      Get.snackbar('Error','Error getting user role: $e',backgroundColor: Colors.red);
    }
    return null;
  }

  Future<void> login(
    String email ,
    String password
    )async{
    try{
      UserCredential userlogin = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userlogin.user;
      if (user != null && user.emailVerified) {
        String uid = user.uid;
        String? role = await getUserRole(uid);

        if (role != null) {
          Get.snackbar("Success", "Berhasil login", backgroundColor: Colors.green);

          if (role == 'Owner') {
            Get.offNamed("/home");
            this.email.clear();
            this.password.clear();
          } else if (role == 'Pegawai') {
            Get.offNamed("/workhome");
            this.email.clear();
            this.password.clear();
          } else {
            Get.snackbar("Error", "Peran tidak dikenali", backgroundColor: Colors.red);
          }
        } else {
          Get.snackbar("Error", "Tidak dapat mengambil peran pengguna", backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar("Error", "Tolong verifikasi email Anda", backgroundColor: Colors.red);
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
  @override
  void onClose() {
    email.clear();
    password.clear();
    super.onClose();
  }
}
