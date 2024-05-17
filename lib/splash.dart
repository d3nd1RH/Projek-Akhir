import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget{
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4),(){
      Get.offNamed("/home");
    });
    return Scaffold(
      body: Container(
      color: Colors.blue[100],
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Konsep",style: TextStyle(fontSize: 24.sp , fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
              Text("Ini Splash",style: TextStyle(fontSize: 24.sp , fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
            ],
          ),
        ),
      )
    );
  }
}