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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Barang'),
        titleTextStyle: TextStyle(
            fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(172, 69, 150, 1),
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
      ),
      body: FutureBuilder(
        future: controller.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Center(
                  child: Obx(
                () => Column(
                  children: [
                    if (controller.makananList.isNotEmpty)
                      controller.buildDataTable(
                          'Makanan', controller.makananList),
                    if (controller.minumanList.isNotEmpty)
                      controller.buildDataTable(
                          'Minuman', controller.minumanList),
                    if (controller.lainnyaList.isNotEmpty)
                      controller.buildDataTable(
                          'Lainnya', controller.lainnyaList),
                  ],
                ),
              )),
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
    );
  }
}
