import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/resi_controller.dart';

class ResiView extends GetView<ResiController> {
  const ResiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        titleTextStyle: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255)),
          backgroundColor: const Color.fromRGBO(16, 44, 87, 1),
          centerTitle: true,
          automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              const Text('Tanggal :'),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () async {
                },
                child: Container(
                  width: 160.w,
                  height: 40.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 8.h,
                      ),
                      const Spacer(),
                      const Icon(Icons.calendar_month_outlined)
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 20.w,
              ), 
              GestureDetector(
                onTap: () async {
                },
                child: Container(
                  width: 100.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.grey, 
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Refresh', 
                      style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    )
    );
  }
}
