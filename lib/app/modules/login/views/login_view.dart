import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Tambahkan background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg-login.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(20.w), // Tambahkan padding keseluruhan
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Text(
                  'FUNTIME',
                  style: TextStyle(fontSize: 40.sp, color: Colors.white),
                ),
                SizedBox(height: 30.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 300.w,
                  height: 200.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "assets/images/Logo_Funtime.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Form(
                  key: controller.forum,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Email", style: TextStyle(color: Colors.white)),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: controller.email,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(217, 217, 217, 1),
                          hintText: "Masukkan Email Anda",
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (emailstate) {
                          if (emailstate == null || emailstate.isEmpty) {
                            return "Tolong isi Email anda";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      const Text("Password", style: TextStyle(color: Colors.white)),
                      SizedBox(height: 10.h),
                      Obx(() => TextFormField(
                        controller: controller.password,
                        obscureText: controller.obscurePassText.value,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(217, 217, 217, 1),
                          hintText: "Masukkan Password Anda",
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.obscurePassText.value ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Tolong isi Password anda";
                          } else {
                            return null;
                          }
                        },
                      )),
                      SizedBox(height: 20.h),
                      TextButton(
                        onPressed: () {
                          Get.toNamed("/reset-pass");
                        },
                        child: const Text("Lupa Password?", style: TextStyle(color: Color.fromARGB(255, 23, 2, 255))),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () {
                          if (controller.forum.currentState!.validate()) {
                            controller.login(controller.email.text, controller.password.text);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)),
                          foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                          minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50.h)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.5)), // Tambahkan bayangan
                          elevation: MaterialStateProperty.all<double>(5.0), // Tambahkan elevasi
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h), // Tambahkan padding vertikal
                          child: const Text("Login"), // Ubah teks menjadi "Login"
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Belum punya akun? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.offNamed("/register");
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Color.fromARGB(255, 23, 2, 255)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
