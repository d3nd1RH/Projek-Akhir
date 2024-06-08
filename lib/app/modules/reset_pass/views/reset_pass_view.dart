import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/reset_pass_controller.dart';

class ResetPassView extends GetView<ResetPassController> {
  const ResetPassView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 100.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(217, 217, 217, 1),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextFormField(
                          controller: controller.reset,
                          decoration: const InputDecoration(
                            hintText: "Masukkan Email Anda",
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      ElevatedButton(
                        onPressed: () {
                          if (controller.reset.text.isEmpty) {
                            Get.snackbar("Error", "Isi Emailnya Terlebih dahulu", backgroundColor: Colors.red);
                          } else {
                            controller.resetpass(controller.reset.text);
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50.h)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        child: const Text("Reset Password", style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
