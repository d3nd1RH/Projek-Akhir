import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget{
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4),(){
      Get.offNamed("/login");
    });
    return Scaffold(
      body: Container(
      color: Colors.white,
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/Logo_Funtime.jpg",
              width: 350.sp,
              height: 350.sp,),
            ],
          ),
        ),
      )
    );
  }
}