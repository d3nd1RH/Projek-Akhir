import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../login/controllers/login_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        titleTextStyle: TextStyle(
            fontSize: 25.sp, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(16, 44, 87, 1),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: Get.find<LoginController>().streamAuthStatus,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String uid = snapshot.data!.uid;
            controller.getUserData(uid);
            return Obx(() {
              if (controller.userData.isEmpty) {
                return const Center(child: Text("Tunggu Sebentar"));
              } else {
                return Padding(
                  padding: EdgeInsets.only(right: 60.w, left: 60.w),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 60.h),
                        GestureDetector(
                          onTap: () async {
                            await controller.pickImage();
                          },
                          child: Obx(() {
                            return CircleAvatar(
                              radius: 50,
                              backgroundImage: controller.selectedImage.value !=
                                      null
                                  ? FileImage(controller.selectedImage.value!)
                                  : NetworkImage(
                                          controller.userData['photoUrl'] ?? '')
                                      as ImageProvider,
                            );
                          }),
                        ),
                        SizedBox(height: 120.h),
                        TextField(
                          decoration: const InputDecoration(
                              filled: true,
                              labelText: 'Nama',
                              border: OutlineInputBorder()),
                          controller: controller.namaController,
                        ),
                        SizedBox(height: 100.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.updateUserData(uid);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 41, 128, 185)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 250, 250, 250)),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(double.infinity, 50.h)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.black.withOpacity(0.5)),
                              elevation: MaterialStateProperty.all<double>(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: const Text("Simpan"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
