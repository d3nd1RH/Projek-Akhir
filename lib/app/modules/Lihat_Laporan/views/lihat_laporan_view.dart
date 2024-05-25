import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/lihat_laporan_controller.dart';

class LihatLaporanView extends GetView<LihatLaporanController> {
  const LihatLaporanView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laporan'),
          titleTextStyle: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
          backgroundColor: const Color.fromRGBO(172, 69, 150, 1),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Harian'),
              Tab(text: 'Bulanan'),
              Tab(text: 'Tahunan'),
            ],
            indicator: const BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1), // Warna latar belakang putih
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.only(right: 30.0.w ,left: 30.0.w,top: 8.0.h,bottom: 8.0.h),
            unselectedLabelColor: Colors.white,
            labelColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            Column(
                children: [
                  SizedBox(height: 30.h,),
                  Row(
                    children: [
                      const Text('Tanggal :'),
                      SizedBox(width: 10.w,),
                      GestureDetector(
                        onTap: ()async{
                        },
                        child: Container(
                          width: 160.w,height: 40.h,color: const Color.fromRGBO(217, 217, 217, 1),
                        child: const Row(
                          children: [
                            Text(""),
                            Spacer(),
                            Icon(Icons.calendar_month_outlined)
                          ],
                        ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            Column(
                children: [
                  SizedBox(height: 30.h,),
                  Row(
                    children: [
                      const Text('Tanggal :'),
                      SizedBox(width: 10.w,),
                      GestureDetector(
                        onTap: ()async{
                        },
                        child: Container(
                          width: 160.w,height: 40.h,color: const Color.fromRGBO(217, 217, 217, 1),
                        child: const Row(
                          children: [
                            Text(""),
                            Spacer(),
                            Icon(Icons.calendar_month_outlined)
                          ],
                        ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            Column(
                children: [
                  SizedBox(height: 30.h,),
                  Row(
                    children: [
                      const Text('Tanggal :'),
                      SizedBox(width: 10.w,),
                      GestureDetector(
                        onTap: ()async{
                        },
                        child: Container(
                          width: 160.w,height: 40.h,color: const Color.fromRGBO(217, 217, 217, 1),
                        child: const Row(
                          children: [
                            Text(""),
                            Spacer(),
                            Icon(Icons.calendar_month_outlined)
                          ],
                        ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
