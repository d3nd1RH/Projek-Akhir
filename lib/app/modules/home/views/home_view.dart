import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funtime Juice'),
        titleTextStyle: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold,color: Colors.black),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(233, 107, 107, 1),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(right: 20.0.w,left: 20.0.w, top: 40.0.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 100.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h,),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Total Penjualan (surplus)",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("01/06/2024"),
                        ],
                      ),
                      Text("Rp6.000.000",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 32.sp),),
                    ],
                  )
                  ),
              ),
              SizedBox(height:20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 175.w,
                    height: 175.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    child: Center(
                      child: Text("Lihat Laporan",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),),
                    ),
                  ),
                  SizedBox(width:20.w),
                  Container(
                    width: 175.w,
                    height: 175.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                  ),
                ],
              ),
              SizedBox(height:20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 175.w,
                    height: 175.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    child: Center(
                      child: Text("Stock Barang",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),),
                    ),
                  ),
                  SizedBox(width:20.w),
                  Container(
                    width: 175.w,
                    height: 175.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add ,size: 40.sp,),
                          Text("Buat Laporan",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height:20.h),
              Container(
                width: double.infinity,
                height: 100.h,
                color: const Color.fromRGBO(217, 217, 217, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
