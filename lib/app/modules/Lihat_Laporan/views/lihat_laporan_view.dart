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
  titleTextStyle: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
  backgroundColor: const Color.fromRGBO(16, 44, 87, 1),
  centerTitle: true,
  automaticallyImplyLeading: false,
  bottom: TabBar(
    tabs: const [
      Tab(
        child: Text(
          'Harian',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Tab(
        child: Text(
          'Bulanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Tab(
        child: Text(
          'Tahunan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ],
    indicator: BoxDecoration(
      color: Color.fromRGBO(217, 217, 217, 1),
      borderRadius: BorderRadius.circular(25.0),
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.0.h),
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
