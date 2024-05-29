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
            indicatorPadding: EdgeInsets.only(right: 30.0.w ,left: 30.0.w,top: 8.0.h,bottom: 8.0.h),
            unselectedLabelColor: Colors.white,
            labelColor: Colors.black,
          ),
        ),
        body: TabBarView(
          children: [
            controller.buildTab(controller.makananList),
            controller.buildTab(controller.minumanList),
            controller.buildTab(controller.lainnyaList),
          ],
        ),
      ),
    );
  }
}
