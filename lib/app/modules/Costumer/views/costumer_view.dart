import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../utill/formatindo.dart';
import '../controllers/costumer_controller.dart';

class CostumerView extends GetView<CostumerController> {
  const CostumerView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
  title: Obx(() =>
      Text(controller.isReseller.value ? 'Reseller' : 'Customer')),
  titleTextStyle: TextStyle(
      fontSize: 25.sp,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 255, 255, 255)),
  backgroundColor: const Color.fromRGBO(16, 44, 87, 1),
  centerTitle: true,
  automaticallyImplyLeading: false,
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
    indicatorPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.0.h),
    unselectedLabelColor: Colors.white,
    labelColor: Colors.black,
  ),
),

        body: FutureBuilder<void>(
          future: controller.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Tunggu Sebentar"));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return TabBarView(
                children: [
                  controller.buildTab(controller.makananList, 0),
                  controller.buildTab(
                      controller.minumanList, controller.makananList.length),
                  controller.buildTab(
                      controller.lainnyaList,
                      controller.makananList.length +
                          controller.minumanList.length),
                ],
              );
            }
          },
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                bottom: 8.0.h, top: 8.0.h, right: 30.h, left: 30.h),
            child: ElevatedButton(
              onPressed: () {
                controller.showConfirmationDialog(context, () {
                  controller.savePurchase();
                });
              },
              onLongPress: () {
                controller.toggleReseller();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 41, 128, 185)),
                foregroundColor: WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 250, 250, 250)),
                minimumSize: WidgetStateProperty.all<Size>(
                    Size(double.infinity, 50.h)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                shadowColor: WidgetStateProperty.all<Color>(
                    Colors.black.withOpacity(0.5)),
                elevation: WidgetStateProperty.all<double>(5.0),
              ),
              child: Obx(() => Text(
                    formatRupiah(controller.selectedPrice.value),
                    style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  )),
            )),
      ),
    );
  }
}
