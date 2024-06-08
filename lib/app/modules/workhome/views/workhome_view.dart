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
            fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(233, 107, 107, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              controller.showPopupMenu(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Hallo selamat Datang", style: TextStyle(
            fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),),
            SizedBox(height: 100.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed("/costumer");
                  },
                  child: Container(
                    width: 175.w,
                    height: 175.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    child: Center(
                        child: Text(
                      "Customer",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                    )),
                  ),
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                    onTap: () {
                      Get.toNamed("/stock-barang");
                    },
                    child: Container(
                      width: 175.w,
                      height: 175.h,
                      color: const Color.fromRGBO(217, 217, 217, 1),
                      child: Center(
                        child: Text(
                          "Stock Barang",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
