import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Container(
        color: Colors.blue[600],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 40.sp,
                      color: Colors.white,
                      fontFamily: "Pattaya"),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    key: controller.form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nama",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: controller.nama,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(190, 213, 228, 1),
                            hintText: "Masukkan Nama Anda",
                            hintStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                          style: const TextStyle(color: Colors.black),
                          validator: (namastate) {
                            if (namastate == null || namastate.isEmpty) {
                              return "Tolong isi bagian ini";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        const Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: controller.email,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(190, 213, 228, 1),
                            hintText: "Masukkan Email Anda",
                            hintStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                          style: const TextStyle(color: Colors.black),
                          validator: (emailstate) {
                            if (emailstate == null || emailstate.isEmpty) {
                              return "Tolong isi bagian ini";
                            } else if (!GetUtils.isEmail(emailstate)) {
                              return "Tolong tulis email yang benar";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        const Text(
                          "Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10.h),
                        Obx(() => TextFormField(
                              controller: controller.password,
                              obscureText: controller.obscurePassText.value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromRGBO(190, 213, 228, 1),
                                hintText: "Masukkan Password Anda",
                                hintStyle: const TextStyle(color: Colors.black),
                                suffixIcon: IconButton(
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                  icon: Icon(
                                    controller.obscurePassText.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: const EdgeInsets.all(10.0),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (passwordstate) {
                                if (passwordstate == null ||
                                    passwordstate.isEmpty) {
                                  return "Tolong isi Passwordnya";
                                } else {
                                  return null;
                                }
                              },
                            )),
                        SizedBox(height: 20.h),
                        const Text(
                          "Konfirmasi Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10.h),
                        Obx(() => TextFormField(
                              controller: controller.passwordconfirm,
                              obscureText: controller.obscureCoritmText.value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromRGBO(190, 213, 228, 1),
                                hintText: "Konfirmasi Password Anda",
                                hintStyle: const TextStyle(color: Colors.black),
                                suffixIcon: IconButton(
                                  onPressed: controller
                                      .togglePasswordconfirmVisibility,
                                  icon: Icon(
                                    controller.obscureCoritmText.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding: const EdgeInsets.all(10.0),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (passwordconfirmstate) {
                                if (passwordconfirmstate == null ||
                                    passwordconfirmstate.isEmpty) {
                                  return "Tolong konfirmasi Passwordnya";
                                } else if (controller.password.text !=
                                    passwordconfirmstate) {
                                  return "Password tidak sama";
                                } else {
                                  return null;
                                }
                              },
                            )),
                        SizedBox(height: 30.h),
                        ElevatedButton(
                          onPressed: () {
                            if (controller.form.currentState!.validate()) {
                              controller.register(
                                controller.email.text,
                                controller.password.text,
                                controller.nama.text,
                              );
                            }
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(
                                3.0), // Menambahkan elevasi bayangan
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(double.infinity, 50.h)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          child: const Text("Register"),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sudah punya akun? ",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.offNamed("/login");
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 21, 0, 255)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
