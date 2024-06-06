import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../login/controllers/login_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        titleTextStyle: TextStyle(
            fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(233, 107, 107, 1),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: Get.find<LoginController>().streamAuthStatus,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String uid = snapshot.data!.uid;
            return FutureBuilder(
              future: controller.getUserData(uid),
              builder: (context, AsyncSnapshot<void> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){},
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(controller.userData['photoUrl'] ?? ''),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                            ),
                            controller: TextEditingController(text: controller.userData['nama']),
                            onChanged: (value) => controller.userData['nama'] = value,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              controller.updateUserData(uid); // Method untuk menyimpan data ke Firebase
                            },
                            child: const Text('Simpan'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
