// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../formatindo.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Funtime Juice'),
        titleTextStyle: TextStyle(
            fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(233, 107, 107, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              controller.showPopupMenu(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 20.0.w, left: 20.0.w, top: 40.0.h),
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('TotalTransactions')
                      .doc('Transaksi')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Container(
                        width: double.infinity,
                        height: 100.h,
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        child: const Center(
                          child: Text(
                            "Tidak ada transaksi",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }
                    var totalSalesData =
                        snapshot.data!.data() as Map<String, dynamic>?;
                    var totalSales = totalSalesData?['Total Transaksi'] ?? 0;
                    var transactionDate =
                        totalSalesData?['Date']?.toDate() ?? DateTime.now();

                    bool isNegative = totalSales < 0;
                    String formattedTotalSales = formatRupiah(totalSales.abs());
                    Color salesColor = isNegative ? Colors.red : Colors.green;

                    return GestureDetector(
                      onTap: () {
                        controller.toggleTextVisibility();
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String newValue = totalSales.toString();

                            return AlertDialog(
                              title: const Text("Edit Total Penjualan"),
                              content: TextField(
                                onChanged: (value) {
                                  newValue = value;
                                },
                                controller:
                                    TextEditingController(text: newValue),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('TotalTransactions')
                                        .doc('Transaksi')
                                        .update({
                                      'Total Transaksi': int.parse(newValue)
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Simpan'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100.h,
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "Total Penjualan",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(DateFormat('dd/MM/yyyy')
                                      .format(transactionDate)),
                                ],
                              ),
                              Obx(
                                () => controller.isTextHidden.value
                                    ? Container()
                                    : Text(
                                        formattedTotalSales,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32.sp,
                                          color: salesColor,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed("/lihat-laporan");
                      },
                      child: Container(
                        width: 175.w,
                        height: 175.h,
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        child: Center(
                          child: Text(
                            "Lihat Laporan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.sp),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed("/costumer");
                      },
                      child: Container(
                        width: 175.w,
                        height: 175.h,
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        child: Center(
                            child: Text(
                          "Customer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed("/stock-barang");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 175.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    child: Center(
                      child: Text(
                        "Stock Barang",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
