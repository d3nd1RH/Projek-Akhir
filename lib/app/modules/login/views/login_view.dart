import 'package:flutter/material.dart';

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
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'FUNTIME',
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blue),
                    image: const DecorationImage(
                        image: AssetImage("assets/images/Logo_Funtime.jpg"),
                        fit: BoxFit.cover),
                  ),
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: controller.forum,
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Email",style: TextStyle(color: Colors.white),),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        const Text("Password", style : TextStyle(color: Colors.white)),
                        const SizedBox(height: 20),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Tolong isi Password anda";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextButton(onPressed: (){
                          Get.toNamed("/reset-pass");
                        }, child: const Text("lupa Passwrd?",style: TextStyle(color: Colors.blue),)),
                        const SizedBox(height: 20),
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
                                    const MaterialStatePropertyAll<Size>(
                                        Size(double.infinity, 40)),
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
                                  Get.toNamed("/register");
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
