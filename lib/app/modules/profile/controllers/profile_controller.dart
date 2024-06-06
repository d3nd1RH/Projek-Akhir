import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var userData = <String, dynamic>{}.obs;
  var namaController = TextEditingController();
  var nama = ''.obs;
  var selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    namaController.addListener(() {
      nama.value = namaController.text; 
    });
    super.onInit();
  }

  Future<void> getUserData(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .get();
    userData.value = doc.data() ?? {};
    nama.value = userData['nama'] ?? '';
    namaController.text = nama.value;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> updateUserData(String uid) async {
     if (selectedImage.value != null) {
      final String fileName = 'profile_pictures/$uid.jpg';

      try {
        await FirebaseStorage.instance
            .ref(fileName)
            .putFile(selectedImage.value!);

        String downloadURL = await FirebaseStorage.instance
            .ref(fileName)
            .getDownloadURL();

        userData['photoUrl'] = downloadURL;
      } catch (e) {
        Get.snackbar('Error', 'Error uploading profile picture: $e', backgroundColor: Colors.red);
      }
    }

    userData['nama'] = nama.value;
    
    await FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .set(userData);
  }
}
