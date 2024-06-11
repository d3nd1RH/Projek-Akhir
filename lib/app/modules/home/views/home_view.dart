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
        title: const Text(
          'Funtime Juice',
        ),
        titleTextStyle: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: "Pattaya"),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(41, 128, 185, 1),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
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
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          width: double.infinity,
                          height: 100.h,
                          color: const Color.fromRGBO(41, 128, 185, 1),
                          child: const Center(
                            child: Text(
                              "Tidak ada transaksi",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                                    Get.back();
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

                                    Get.back();
                                  },
                                  child: const Text('Simpan'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          width: double.infinity,
                          height: 100.h,
                          color: const Color.fromRGBO(41, 128, 185, 1),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 50.w,
                                    ),
                                    const Text(
                                      "Total Penjualan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Obx(() => controller.isTextHidden.value
                                        ? const Icon(
                                            Icons.visibility_off,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                            color: Colors.white,
                                          )),
                                    SizedBox(
                                      width: 50.w,
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(transactionDate),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 50.w,
                                    ),
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
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(37.0),
                            child: Container(
                              width: 175.w,
                              height: 175.h,
                              color: const Color.fromRGBO(41, 128, 185, 1),
                              child: Center(
                                child: Icon(
                                  Icons.file_present_outlined,
                                  color: Colors.black,
                                  size: 120.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          const Text("Lihat Laporan")
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed("/costumer");
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(37.0),
                            child: Container(
                              width: 175.w,
                              height: 175.h,
                              color: const Color.fromRGBO(41, 128, 185, 1),
                              child: Icon(
                                Icons.group_outlined,
                                color: Colors.black,
                                size: 120.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          const Text("Consumer")
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    Get.toNamed("/stock-barang");
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(37.0),
                        child: Container(
                          width: double.infinity,
                          height: 175.h,
                          color: const Color.fromRGBO(41, 128, 185, 1),
                          child: Center(
                            child: Icon(
                              Icons.fastfood,
                              color: Colors.black,
                              size: 120.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Text("Stock Barang")
                    ],
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
