import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/workhome_controller.dart';

class WorkhomeView extends GetView<WorkhomeController> {
  const WorkhomeView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funtime Juice'),
        titleTextStyle: TextStyle(
          fontSize: 25.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "Pattaya",
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(16, 44, 87, 1),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              controller.showPopupMenu(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/finance.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildFeatureCard(
                    icon: Icons.group_outlined,
                    label: "Consumer",
                    onTap: () {
                      Get.toNamed("/costumer");
                    },
                  ),
                  SizedBox(height: 20.h),
                  buildFeatureCard(
                    icon: Icons.fastfood,
                    label: "Stock Barang",
                    onTap: () {
                      Get.toNamed("/stock-barang");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatureCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(37.0),
            child: Container(
              height: 150.h,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(41, 128, 185, 1),
                borderRadius: BorderRadius.circular(37.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 80.sp,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
