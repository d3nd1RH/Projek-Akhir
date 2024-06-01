import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
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
                  'Register',
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
                  key: controller.form,
                  child: SizedBox(
                    width: 300.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Email",style: TextStyle(color: Colors.white)),
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
                              return "Tolong isi bagian ini";
                            } else if (emailstate.isEmail == false) {
                              return "Tolong Tulis email yang benar";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        const Text("Password",style: TextStyle(color: Colors.white),),
                        SizedBox(height: 20.h),
                        TextFormField(
                            controller: controller.password,
                            obscureText: true,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(217, 217, 217, 1),
                                hintText: "Please Enter Your Password..",
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder()),
                            style: const TextStyle(color: Colors.black),
                            validator: (passwordstate) {
                              if (passwordstate == null ||
                                  passwordstate.isEmpty) {
                                return "Tolong isi Passwordnya";
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(height: 20.h),
                        const Text("Password Comfirm",style: TextStyle(color: Colors.white),),
                        SizedBox(height: 20.h),
                        TextFormField(
                            controller: controller.passwordconfirm,
                            obscureText: true,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(217, 217, 217, 1),
                                hintText: "Please Confirm Your Password..",
                                hintStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder()),
                            style: const TextStyle(color: Colors.black),
                            validator: (passwordconfirmstate) {
                              if (passwordconfirmstate == null ||
                                  passwordconfirmstate.isEmpty) {
                                return "Tolong Confirmasi Passowrdnya";
                              } else if (controller.password.text !=
                                  passwordconfirmstate) {
                                return "Passsword tidak sama";
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(height: 20.h),
                        const Text("Role",style: TextStyle(color: Colors.white),),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        const Text("Chassir",style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Radio(
                                          value: "Chassir",
                                          groupValue: controller.role.value,
                                          onChanged: (value) {
                                            controller.grup(value.toString());
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Obx(() => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          const Text("Owner",style: TextStyle(color: Colors.white),),
                                        ],
                                      ),
                                      RadioListTile(
                                          value: "Owner",
                                          groupValue: controller.role.value,
                                          onChanged: (value) {
                                            controller.grup(value.toString());
                                          }),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (controller.form.currentState!.validate()) {
                                controller.register(
                                  controller.email.text,
                                  controller.role.value,
                                  controller.password.text,
                                );
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
                            child: const Text("Register")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "already have an account?",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                                onPressed: () {
                                   Get.offNamed("/login");
                                },
                                child: const Text(
                                  "Login",
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
