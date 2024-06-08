import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/lihat_laporan_controller.dart';

class LihatLaporanView extends GetView<LihatLaporanController> {
  const LihatLaporanView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laporan'),
          titleTextStyle: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
          backgroundColor: const Color.fromRGBO(41, 128, 185, 1),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Harian'),
              Tab(text: 'Bulanan'),
              Tab(text: 'Tahunan'),
            ],
            indicator: const BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.only(right: 30.0.w ,left: 30.0.w,top: 8.0.h,bottom: 8.0.h),
            unselectedLabelColor: Colors.white,
            labelColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            controller.harianLaporan(),
            controller.bulananLaporan(),
            controller.tahunLaporan(),
          ],
        ),
      ),
    );
  }
}
