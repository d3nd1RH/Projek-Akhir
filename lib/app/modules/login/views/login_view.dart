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
        color: const Color.fromRGBO(201, 126, 126, 1),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'FUNTIME',
                  style: TextStyle(fontSize: 40.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue),
                    image: const DecorationImage(
                        image: AssetImage("assets/images/Logo_Funtime.jpg"),
                        fit: BoxFit.cover),
                  ),
                  width: 300.w,
                  height: 200.h,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Form(
                  key: controller.forum,
                  child: SizedBox(
                    width: 300.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Email",style: TextStyle(color: Colors.white),),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: controller.email,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              hintText: "Please Enter Your Email..",
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder()),
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
                        const Text("Password", style : TextStyle(color: Colors.white)),
                        SizedBox(height: 20.h),
                        Obx(()=>TextFormField(
                          controller: controller.password,
                          obscureText: controller.obscurePassText.value,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(217, 217, 217, 1),
                              hintText: "Please Enter Your Password..",
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
                              border: const OutlineInputBorder()),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Tolong isi Password anda";
                            } else {
                              return null;
                            }
                          },
                        )),
                        TextButton(onPressed: (){
                          Get.toNamed("/reset-pass");
                        }, child: const Text("lupa Passwrd?",style: TextStyle(color: Colors.blue),)),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                            onPressed: () {
                              if (controller.forum.currentState!.validate()) {
                                controller.login(controller.email.text,
                                    controller.password.text);
                              }
                            },
                            style: ButtonStyle(
                                foregroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                        Colors.black),
                                minimumSize:
                                    MaterialStatePropertyAll<Size>(
                                        Size(double.infinity, 40.h)),
                                shape: MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0)))),
                            child: const Text("Login")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.offNamed("/register");
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(color: Colors.blue),
                                )),
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
