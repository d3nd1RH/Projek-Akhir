import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/costumer_controller.dart';

class CostumerView extends GetView<CostumerController> {
  const CostumerView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer'),
          titleTextStyle: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          backgroundColor: const Color.fromRGBO(172, 69, 150, 1),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
        body: TabBarView(
          children: [
            controller.buildTab(controller.makananList, 0),
            controller.buildTab(
                controller.minumanList, controller.makananList.length),
            controller.buildTab(controller.lainnyaList,
                controller.makananList.length + controller.minumanList.length),
          ],
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: 8.0.h, top: 8.0.h,right: 30.h,left: 30.h),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Atur radius sudut di sini
                ),
                backgroundColor:
                    const Color.fromRGBO(203, 82, 82, 1), // Atur warna latar belakang di sini
              ),
              child: Obx(()=>Text("Rp ${controller.selectedPrice.value}",style: const TextStyle(color:Colors.black),)),
            )),
      ),
    );
  }
}
