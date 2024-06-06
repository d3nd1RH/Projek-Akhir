import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WorkhomeController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
   Future<void> logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed("/login");
    } catch (e) {
      Get.snackbar("Error", "Error during logout: $e", backgroundColor: Colors.red);
    }
  }
  void showPopupMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 0,
        100.h,
        MediaQuery.of(context).size.width,
        0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed("/profile");
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              logout();
            },
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
