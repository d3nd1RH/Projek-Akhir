import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/reset_pass_controller.dart';

class ResetPassView extends GetView<ResetPassController> {
  const ResetPassView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: const Color.fromRGBO(201, 126, 126, 1),
          child: Center(
            child: SizedBox(
              width: 300,
              child: Column(
                children: [
                  Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold,color:Colors.white),
                  ),
                  SizedBox(
                    height: 150.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      TextField(
                        controller: controller.reset,
                        decoration: const InputDecoration(
                            hintText: "Please Enter your Email",
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(217, 217, 217, 1),
                            filled: true),
                        style: const TextStyle(color:Colors.black),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(onPressed: (){
                        if(controller.reset.text.isEmpty){
                          Get.snackbar("Error", "Isi Emailnya Terlebih dahulu",backgroundColor: Colors.red);
                        }else{
                          controller.resetpass(controller.reset.text);
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)
                          )
                          ),
                        backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
                        minimumSize: MaterialStatePropertyAll<Size>(Size(double.infinity, 30.h))
                      ), 
                      child: const Text("Reset Password",style: TextStyle(color:Colors.black),))
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