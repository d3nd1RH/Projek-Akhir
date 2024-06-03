import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LihatLaporanController extends GetxController {
  final Rx<DateTime?> selectedMonth = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxInt pilihyear = 0.obs;
  var purchasesDay = <Map<String, dynamic>>[].obs;
  var purchasesMount = <Map<String, dynamic>>[].obs;
  var purchasesYearly = <Map<String, dynamic>>[].obs;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
    }
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null) {
      selectedMonth.value = DateTime(pickedDate.year, pickedDate.month, 1);
    }
  }

  Future<int?> selectyear(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null) {
      return pickedDate.year;
    } else {
      return null;
    }
  }

  Future<void> fetchDailyPurchases() async {
    try {
      if (selectedDate.value != null) {
        final selectedDateValue = selectedDate.value!;
        final dateFormat = DateFormat('yyyy-MM-dd');

        final dateDocIdCostumer =
            '${dateFormat.format(selectedDateValue)}-Customer';
        final dateDocIdReseller =
            '${dateFormat.format(selectedDateValue)}-Reseller';

        DocumentSnapshot costumerDayDoc = await FirebaseFirestore.instance
            .collection('Purchases')
            .doc(dateDocIdCostumer)
            .get();

        DocumentSnapshot resellerDayDoc = await FirebaseFirestore.instance
            .collection('Purchases')
            .doc(dateDocIdReseller)
            .get();

        List<Map<String, dynamic>> combinedData = [];

        if (costumerDayDoc.exists) {
          var costumerData = costumerDayDoc.data() as Map<String, dynamic>;
          combinedData.add(costumerData);
        }
        if (resellerDayDoc.exists) {
          var resellerData = resellerDayDoc.data() as Map<String, dynamic>;
          combinedData.add(resellerData);
        }

        purchasesDay.value = combinedData;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error saat mengambil data: $e',
          backgroundColor: Colors.red);
      purchasesDay.value = [];
    }
  }

  Future<void> fetchMonthlyPurchases() async {
    try {
      if (selectedMonth.value != null) {
        final selectedMonthValue = selectedMonth.value!;
        final year = selectedMonthValue.year;
        final month = selectedMonthValue.month;

        final selectedMonthString = '$year-${month.toString().padLeft(2, '0')}';

        QuerySnapshot monthSnapshot = await FirebaseFirestore.instance
            .collection('Purchases')
            .where('date', isGreaterThanOrEqualTo: selectedMonthString)
            .where('date', isLessThanOrEqualTo: '$selectedMonthString-31')
            .get();

        if (monthSnapshot.docs.isNotEmpty) {
          purchasesMount.value = monthSnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['docId'] = doc.id;
            return data;
          }).toList();
        } else {
          purchasesMount.value = [];
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Error saat mengambil data: $e',
          backgroundColor: Colors.red);
      purchasesMount.value = [];
    }
  }

  Future<void> fetchYearlyMonthlyPurchases() async {
    try {
      if (pilihyear.value != 0) {
        final year = pilihyear.value.toString();

        QuerySnapshot yearSnapshot = await FirebaseFirestore.instance
            .collection('Purchases')
            .where('date', isGreaterThanOrEqualTo: '$year-01-01')
            .where('date', isLessThanOrEqualTo: '$year-12-31')
            .get();

        if (yearSnapshot.docs.isNotEmpty) {
          purchasesYearly.value = yearSnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['docId'] = doc.id;
            return data;
          }).toList();
        } else {
          purchasesYearly.value = [];
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Error saat mengambil data: $e',
          backgroundColor: Colors.red);
      purchasesYearly.value = [];
    }
  }

  Widget harianLaporan() {
    return SingleChildScrollView(
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
                  await selectDate(Get.context!);
                  await fetchDailyPurchases();
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
                      Obx(() => Text(
                            selectedDate.value != null
                                ? '${selectedDate.value!.year}/${selectedDate.value!.month.toString().padLeft(2, '0')}/${selectedDate.value!.day.toString().padLeft(2, '0')}'
                                : 'Pilih Tanggal',
                          )),
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
              Container(
                  width: 100.w,
                  height: 40.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                  child: const Center(child: Text("Print"))),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await fetchDailyPurchases();
                },
                child: Container(
                  width: 100.w,
                  height: 40.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                  child: const Center(child: Text('Refresh')),
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
          Obx(() {
            if (purchasesDay.isEmpty) {
              return Column(
                children: [
                  SizedBox(
                    height: 150.h,
                  ),
                  const Text('Tidak ada data pembelian untuk tanggal ini.'),
                ],
              );
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataTable(
                        border: TableBorder.all(color: Colors.black),
                        columns: const [
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Pelanggan')),
                          DataColumn(label: Text('Jenis')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Modal')),
                          DataColumn(label: Text('Harga')),
                          DataColumn(label: Text('Total (per item)')),
                        ],
                        rows: purchasesDay.expand((purchase) {
                          final customerType =
                              purchase['customer_type'] ?? 'Unknown';
                          final items = purchase['items'] ?? [];

                          Map<String, Map<String, dynamic>> itemMap = {};

                          items.forEach((item) {
                            final itemName = item['Nama Barang'] ?? 'Unknown';
                            final modal = item['Harga Awal'] ?? 0.0;
                            final unit = item['Banyak Barang'] ?? 0;
                            final jenis = item['Jenis Barang'] ?? 'Unknown';
                            final price = item['Harga Jual'] ?? 0.0;

                            final key = '$itemName-$jenis';
                            if (itemMap.containsKey(key)) {
                              itemMap[key]!['Unit'] += unit;
                              itemMap[key]!['Total'] =
                                  itemMap[key]!['Unit'] * price;
                            } else {
                              itemMap[key] = {
                                'Nama Barang': itemName,
                                'Pelanggan': customerType,
                                'Jenis Barang': jenis,
                                'Unit': unit,
                                'Modal': modal,
                                'Harga': price,
                                'Total': unit * price,
                              };
                            }
                          });

                          List<DataRow> rows = itemMap.values.map((item) {
                            final DataRow row = DataRow(cells: [
                              DataCell(Text(item['Nama Barang'])),
                              DataCell(Text(item['Pelanggan'])),
                              DataCell(Text(item['Jenis Barang'])),
                              DataCell(Text(item['Unit'].toString())),
                              DataCell(Text(item['Modal'].toString())),
                              DataCell(Text(item['Harga'].toString())),
                              DataCell(Text(item['Total'].toString())),
                            ]);
                            return row;
                          }).toList();

                          return rows;
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Total Income :",
                              textAlign: TextAlign.left),
                          SizedBox(
                            width: 100.w,
                          ),
                          Obx(() {
                            double totalHarga = 0.0;
                            for (var purchase in purchasesDay) {
                              totalHarga += purchase['Total Harga'] ?? 0.0;
                            }
                            return Text(totalHarga.toString(),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Capital :", textAlign: TextAlign.left),
                          SizedBox(width: 140.w),
                          Obx(() {
                            double totalCapital = 0.0;
                            for (var purchase in purchasesDay) {
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Awal'] ?? 0.0;
                                totalCapital += unit * modal;
                              });
                            }
                            return Text(
                              totalCapital.toString(),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 300.w,
                            child: const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: 10.w,
                            child: const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          const Text("Net Income :", textAlign: TextAlign.left),
                          SizedBox(width: 115.w),
                          Obx(() {
                            double totalHarga = 0.0;
                            double totalCapital = 0.0;
                            for (var purchase in purchasesDay) {
                              totalHarga += purchase['Total Harga'] ?? 0.0;
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Awal'] ?? 0.0;
                                totalCapital += unit * modal;
                              });
                            }
                            final netIncome = totalHarga - totalCapital;
                            return Text(netIncome.toString(),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget bulananLaporan() {
    return SingleChildScrollView(
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
                  await selectMonth(Get.context!);
                  await fetchMonthlyPurchases();
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
                      Obx(() => Text(
                            selectedMonth.value != null
                                ? '${selectedMonth.value!.year}/${selectedMonth.value!.month.toString().padLeft(2, '0')}'
                                : 'Pilih Bulan',
                          )),
                      const Spacer(),
                      const Icon(Icons.calendar_month_outlined)
                    ],
                  ),
                ),
              )
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
              Container(
                  width: 100.w,
                  height: 40.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                  child: const Center(child: Text("Print"))),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await fetchMonthlyPurchases();
                },
                child: Container(
                  width: 100.w,
                  height: 40.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                  child: const Center(child: Text('Refresh')),
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
          Obx(() {
            if (purchasesMount.isEmpty) {
              return Column(
                children: [
                  SizedBox(
                    height: 150.h,
                  ),
                  const Text('Tidak ada data pembelian untuk bulan ini.'),
                ],
              );
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataTable(
                        border: TableBorder.all(color: Colors.black),
                        columns: const [
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Pelanggan')),
                          DataColumn(label: Text('Jenis')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Modal')),
                          DataColumn(label: Text('Harga')),
                          DataColumn(label: Text('Total (per item)')),
                        ],
                        rows: purchasesMount.expand((purchase) {
                          final customerType =
                              purchase['customer_type'] ?? 'Unknown';
                          final items = purchase['items'] ?? [];

                          Map<String, Map<String, dynamic>> itemMap = {};

                          items.forEach((item) {
                            final itemName = item['Nama Barang'] ?? 'Unknown';
                            final modal = item['Harga Awal'] ?? 0.0;
                            final unit = item['Banyak Barang'] ?? 0;
                            final jenis = item['Jenis Barang'] ?? 'Unknown';
                            final price = item['Harga Jual'] ?? 0.0;

                            final key = '$itemName-$jenis';
                            if (itemMap.containsKey(key)) {
                              itemMap[key]!['Unit'] += unit;
                              itemMap[key]!['Total'] =
                                  itemMap[key]!['Unit'] * price;
                            } else {
                              itemMap[key] = {
                                'Nama Barang': itemName,
                                'Pelanggan': customerType,
                                'Jenis Barang': jenis,
                                'Unit': unit,
                                'Modal': modal,
                                'Harga': price,
                                'Total': unit * price,
                              };
                            }
                          });

                          List<DataRow> rows = itemMap.values.map((item) {
                            final DataRow row = DataRow(cells: [
                              DataCell(Text(item['Nama Barang'])),
                              DataCell(Text(item['Pelanggan'])),
                              DataCell(Text(item['Jenis Barang'])),
                              DataCell(Text(item['Unit'].toString())),
                              DataCell(Text(item['Modal'].toString())),
                              DataCell(Text(item['Harga'].toString())),
                              DataCell(Text(item['Total'].toString())),
                            ]);
                            return row;
                          }).toList();
                          return rows;
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Total Income :",
                              textAlign: TextAlign.left),
                          SizedBox(
                            width: 100.w,
                          ),
                          Obx(() {
                            double totalHarga = 0.0;
                            for (var purchase in purchasesMount) {
                              totalHarga += purchase['Total Harga'] ?? 0.0;
                            }
                            return Text(totalHarga.toString(),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Capital :", textAlign: TextAlign.left),
                          SizedBox(width: 140.w),
                          Obx(() {
                            double totalCapital = 0.0;
                            for (var purchase in purchasesMount) {
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Awal'] ?? 0.0;
                                totalCapital += unit * modal;
                              });
                            }
                            return Text(
                              totalCapital.toString(),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 300.w,
                            child: const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: 10.w,
                            child: const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          const Text("Net Income :", textAlign: TextAlign.left),
                          SizedBox(width: 115.w),
                          Obx(() {
                            double totalHarga = 0.0;
                            double totalCapital = 0.0;
                            for (var purchase in purchasesMount) {
                              totalHarga += purchase['Total Harga'] ?? 0.0;
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Awal'] ?? 0.0;
                                totalCapital += unit * modal;
                              });
                            }
                            final netIncome = totalHarga - totalCapital;
                            return Text(netIncome.toString(),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget tahunLaporan() {
    return SingleChildScrollView(
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
                  int? year = await selectyear(Get.context!);
                  if (year != null) {
                    pilihyear.value = year;
                  }
                  await fetchYearlyMonthlyPurchases();
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
                      Obx(() => Text(
                            pilihyear.value != 0
                                ? pilihyear.value.toString()
                                : 'Pilih Tahun',
                          )),
                      const Spacer(),
                      const Icon(Icons.calendar_month_outlined)
                    ],
                  ),
                ),
              )
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
              Container(
                  width: 100.w,
                  height: 40.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                  child: const Center(child: Text("Print"))),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await fetchYearlyMonthlyPurchases();
                },
                child: Container(
                  width: 100.w,
                  height: 40.h,
                  color: const Color.fromRGBO(217, 217, 217, 1),
                  child: const Center(child: Text('Refresh')),
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
          Obx(() {
            if (purchasesYearly.isEmpty) {
              return Column(
                children: [
                  SizedBox(
                    height: 150.h,
                  ),
                  const Text('Tidak ada data pembelian untuk tahun ini.'),
                ],
              );
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataTable(
                        border: TableBorder.all(color: Colors.black),
                        columns: const [
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Pelanggan')),
                          DataColumn(label: Text('Jenis')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Modal')),
                          DataColumn(label: Text('Harga')),
                          DataColumn(label: Text('Total (per item)')),
                        ],
                        rows: purchasesYearly.expand((purchase) {
                          final customerType =
                              purchase['customer_type'] ?? 'Unknown';
                          final items = purchase['items'] ?? [];

                          Map<String, Map<String, dynamic>> itemMap = {};

                          items.forEach((item) {
                            final itemName = item['Nama Barang'] ?? 'Unknown';
                            final modal = item['Harga Awal'] ?? 0.0;
                            final unit = item['Banyak Barang'] ?? 0;
                            final jenis = item['Jenis Barang'] ?? 'Unknown';
                            final price = item['Harga Jual'] ?? 0.0;

                            final key = '$itemName-$jenis';
                            if (itemMap.containsKey(key)) {
                              itemMap[key]!['Unit'] += unit;
                              itemMap[key]!['Total'] =
                                  itemMap[key]!['Unit'] * price;
                            } else {
                              itemMap[key] = {
                                'Nama Barang': itemName,
                                'Pelanggan': customerType,
                                'Jenis Barang': jenis,
                                'Unit': unit,
                                'Modal': modal,
                                'Harga': price,
                                'Total': unit * price,
                              };
                            }
                          });

                          List<DataRow> rows = itemMap.values.map((item) {
                            final DataRow row = DataRow(cells: [
                              DataCell(Text(item['Nama Barang'])),
                              DataCell(Text(item['Pelanggan'])),
                              DataCell(Text(item['Jenis Barang'])),
                              DataCell(Text(item['Unit'].toString())),
                              DataCell(Text(item['Modal'].toString())),
                              DataCell(Text(item['Harga'].toString())),
                              DataCell(Text(item['Total'].toString())),
                            ]);
                            return row;
                          }).toList();
                          return rows;
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Total Income :",
                              textAlign: TextAlign.left),
                          SizedBox(
                            width: 100.w,
                          ),
                          Obx(() {
                            double totalHarga = 0.0;
                            for (var purchase in purchasesYearly) {
                              totalHarga += purchase['Total Harga'] ?? 0.0;
                            }
                            return Text(totalHarga.toString(),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Capital :", textAlign: TextAlign.left),
                          SizedBox(width: 140.w),
                          Obx(() {
                            double totalCapital = 0.0;
                            for (var purchase in purchasesYearly) {
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Awal'] ?? 0.0;
                                totalCapital += unit * modal;
                              });
                            }
                            return Text(
                              totalCapital.toString(),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 300.w,
                            child: const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: 10.w,
                            child: const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          const Text("Net Income :", textAlign: TextAlign.left),
                          SizedBox(width: 115.w),
                          Obx(() {
                            double totalHarga = 0.0;
                            double totalCapital = 0.0;
                            for (var purchase in purchasesYearly) {
                              totalHarga += purchase['Total Harga'] ?? 0.0;
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Awal'] ?? 0.0;
                                totalCapital += unit * modal;
                              });
                            }
                            final netIncome = totalHarga - totalCapital;
                            return Text(netIncome.toString(),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
