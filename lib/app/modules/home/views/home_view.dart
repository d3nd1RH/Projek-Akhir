import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utill/custom_text_field.dart';
import '../../../utill/formatindo.dart';
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
          fontSize: 25.sp,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 255, 255, 255),
          fontFamily: "Pattaya",
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(16, 44, 87, 1),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color.fromARGB(255, 255, 255, 255),
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
                Container(
                  height: 250.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "assets/images/finance.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
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
                      return buildTransactionContainer(
                        content: const Center(
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
                    Color salesColor = isNegative ? Colors.red : Color.fromRGBO(37, 255, 124, 1);

                    return GestureDetector(
                      onTap: () {
                        controller.toggleTextVisibility();
                      },
                      onLongPress: () {
                        showEditDialog(context, totalSales);
                      },
                      child: buildTransactionContainer(
                        content: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: 50.w),
                                  const Text(
                                    "Total Penjualan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
                                  SizedBox(width: 50.w),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(transactionDate),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 50.w),
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
                    buildFeatureCard(
                      icon: Icons.file_present_outlined,
                      label: "Lihat Laporan",
                      onTap: () {
                        Get.toNamed("/lihat-laporan");
                      },
                    ),
                    SizedBox(width: 20.w),
                    buildFeatureCard(
                      icon: Icons.group_outlined,
                      label: "Consumer",
                      onTap: () {
                        Get.toNamed("/costumer");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                buildFeatureCard(
                  icon: Icons.fastfood,
                  label: "Stock Barang",
                  onTap: () {
                    Get.toNamed("/stock-barang");
                  },
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTransactionContainer({required Widget content}) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: double.infinity,
          height: 100.h,
          color: const Color.fromRGBO(41, 128, 185, 1),
          child: content,
        ),
      ),
    );
  }

  Widget buildFeatureCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(37.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37.0),
              child: Container(
                width: fullWidth ? double.infinity : 175.w,
                height: 175.h,
                color: const Color.fromRGBO(41, 128, 185, 1),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 120.sp,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  void showEditDialog(BuildContext context, int totalSales) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String initialValue = totalSales.toString();
        controller.totalsale.text = initialValue;

        return AlertDialog(
          title: const Text("Edit Total Penjualan"),
          content: CustomTextField(
            controller: controller.totalsale,
            isUseCustomKeyBoard: true,
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
                String newValue = controller.totalsale.text;
                await FirebaseFirestore.instance
                    .collection('TotalTransactions')
                    .doc('Transaksi')
                    .update({
                  'Total Transaksi': int.parse(newValue),
                });

                Get.back();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
