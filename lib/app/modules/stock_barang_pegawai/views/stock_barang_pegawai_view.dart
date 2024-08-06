import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/stock_barang_pegawai_controller.dart';

class StockBarangPegawaiView extends GetView<StockBarangPegawaiController> {
  const StockBarangPegawaiView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stock Barang'),
          titleTextStyle: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(16, 44, 87, 1),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(
                    context: context, delegate: HomeSearchDelegate(controller));
              },
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(
                child: Text(
                  'Makanan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'Minuman',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'Lainnya',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            indicator: BoxDecoration(
              color: const Color.fromRGBO(217, 217, 217, 1),
              borderRadius: BorderRadius.circular(25.0),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.0.h),
            unselectedLabelColor: Colors.white,
            labelColor: Colors.black,
          ),
        ),
        body: FutureBuilder(
          future: controller.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Tunggu Sebentar"));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return TabBarView(
                children: [
                  Obx(() => controller.buildDataTable(
                      'Makanan', controller.makananList, context)),
                  Obx(() => controller.buildDataTable(
                      'Minuman', controller.minumanList, context)),
                  Obx(() => controller.buildDataTable(
                      'Lainnya', controller.lainnyaList, context)),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
