import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/stock_barang_controller.dart';

class StockBarangView extends GetView<StockBarangController> {
  const StockBarangView({super.key});
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
              fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(41, 128, 185, 1),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                showSearch(
                    context: context, delegate: HomeSearchDelegate(controller));
              },
            ),
          ],
          bottom: TabBar(
              tabs: const [
                Tab(text: 'Makanan'),
                Tab(text: 'Minuman'),
                Tab(text: 'Lainnya'),
              ],
              indicator: const BoxDecoration(
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.only(
                  right: 30.0.w, left: 30.0.w, top: 8.0.h, bottom: 8.0.h),
              unselectedLabelColor: Colors.white,
              labelColor: Colors.black,
            ),
        ),
        body: FutureBuilder(
          future: controller.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Expanded(
              child: TabBarView(
                children: [
                    Obx(() => controller.buildDataTable('Makanan', controller.makananList,context)),
                    Obx(() =>controller.buildDataTable('Minuman', controller.minumanList,context)),
                    Obx(() =>controller.buildDataTable('Lainnya', controller.lainnyaList,context)),
                ],
              ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.tambahBarang();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
