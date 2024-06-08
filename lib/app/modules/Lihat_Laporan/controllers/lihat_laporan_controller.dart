import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../formatindo.dart';

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
            '${dateFormat.format(selectedDateValue)}-Costumer';
        final dateDocIdReseller =
            '${dateFormat.format(selectedDateValue)}-Reseller';

        final dateDocIdStock = '${dateFormat.format(selectedDateValue)}-Stock';

        DocumentSnapshot costumerDayDoc = await FirebaseFirestore.instance
            .collection('Purchases')
            .doc(dateDocIdCostumer)
            .get();

        DocumentSnapshot resellerDayDoc = await FirebaseFirestore.instance
            .collection('Purchases')
            .doc(dateDocIdReseller)
            .get();

        DocumentSnapshot stocDayDoc = await FirebaseFirestore.instance
            .collection('Purchases')
            .doc(dateDocIdStock)
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
        if (stocDayDoc.exists) {
          var stocData = stocDayDoc.data() as Map<String, dynamic>;
          combinedData.add(stocData);
        }

        purchasesDay.value = combinedData;
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        Get.snackbar('Maaf',
            'Anda Mencurigakan!!\nBeritahu Pemilik Toko apabila ini kesalahan',
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', 'Error saat mengambil Data: $e',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error saat mengambil Data: $e',
          backgroundColor: Colors.red);
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
            .where('Date', isGreaterThanOrEqualTo: selectedMonthString)
            .where('Date', isLessThanOrEqualTo: '$selectedMonthString-31')
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
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        Get.snackbar('Maaf',
            'Anda Mencurigakan!!\nBeritahu Pemilik Toko apabila ini kesalahan',
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', 'Error saat mengambil Data: $e',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error saat mengambil Data: $e',
          backgroundColor: Colors.red);
    }
  }

  Future<void> fetchYearlyMonthlyPurchases() async {
    try {
      if (pilihyear.value != 0) {
        final year = pilihyear.value.toString();

        QuerySnapshot yearSnapshot = await FirebaseFirestore.instance
            .collection('Purchases')
            .where('Date', isGreaterThanOrEqualTo: '$year-01-01')
            .where('Date', isLessThanOrEqualTo: '$year-12-31')
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
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        Get.snackbar('Maaf',
            'Anda Mencurigakan!!\nBeritahu Pemilik Toko apabila ini kesalahan',
            backgroundColor: Colors.red);
      } else {
        Get.snackbar('Error', 'Error saat mengambil Data: $e',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error saat mengambil Data: $e',
          backgroundColor: Colors.red);
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
              GestureDetector(
                onTap: () async {
                  await printPdf(purchasesDay, "Harian", 10);
                },
                child: Container(
                    width: 100.w,
                    height: 40.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    child: const Center(child: Text("Print"))),
              ),
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
                          DataColumn(label: Text('Transaksi')),
                          DataColumn(label: Text('Jenis')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Harga')),
                          DataColumn(label: Text('Total (per item)')),
                        ],
                        rows: purchasesDay.expand((purchase) {
                          final typeTransaksi =
                              purchase['Type Transaksi'] ?? 'Unknown';
                          final items = purchase['items'] ?? [];

                          Map<String, Map<String, dynamic>> itemMap = {};

                          items.forEach((item) {
                            final itemName = item['Nama Barang'] ?? 'Unknown';
                            final modal = (typeTransaksi == 'Stok')
                                ? item['Harga Modal']
                                : item['Harga Awal'] ?? 0;
                            final unit = item['Banyak Barang'] ?? 0;
                            if (unit == 0) return;
                            final jenis = item['Jenis Barang'] ?? 'Unknown';
                            final price = (typeTransaksi == 'Stok')
                                ? modal
                                : item['Harga Jual'] ?? 0;

                            final key = '$itemName-$jenis-$modal-$price';
                            if (itemMap.containsKey(key)) {
                              itemMap[key]!['Unit'] += unit;
                              itemMap[key]!['Total'] =
                                  itemMap[key]!['Unit'] * price;
                            } else {
                              itemMap[key] = {
                                'Nama Barang': itemName,
                                'Transaksi': typeTransaksi,
                                'Jenis Barang': jenis,
                                'Unit': unit,
                                'Harga': price,
                                'Total': unit * price,
                              };
                            }
                          });

                          List<DataRow> rows = itemMap.values.map((item) {
                            final DataRow row = DataRow(cells: [
                              DataCell(Text(item['Nama Barang'])),
                              DataCell(Text(item['Transaksi'])),
                              DataCell(Text(item['Jenis Barang'])),
                              DataCell(Text(item['Unit'].toString())),
                              DataCell(Text(formatRupiah(item['Harga']))),
                              DataCell(Text(formatRupiah(item['Total']))),
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
                            int totalHarga = 0;
                            for (var purchase in purchasesDay) {
                              if (purchase['Type Transaksi'] != 'Stok') {
                                totalHarga +=
                                    (purchase['Total Harga'] ?? 0) as int;
                              }
                            }
                            return Text(formatRupiah(totalHarga),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Capital :", textAlign: TextAlign.left),
                          SizedBox(width: 140.w),
                          Obx(() {
                            num totalCapital = 0;
                            for (var purchase in purchasesDay) {
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Modal'] ?? 0;
                                totalCapital += unit * modal;
                              });
                            }
                            return Text(formatRupiah(totalCapital as int));
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
                            num totalHarga = 0;
                            num totalCapital = 0;
                            for (var purchase in purchasesDay) {
                              totalHarga += purchase['Total Harga'] ?? 0;
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Modal'] ?? 0;
                                totalCapital += unit * modal;
                              });
                            }
                            final netIncome = totalHarga - totalCapital;
                            return Text(formatRupiah(netIncome as int),
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
              GestureDetector(
                onTap: () async {
                  await printPdf(purchasesMount, "Bulanan", 7);
                },
                child: Container(
                    width: 100.w,
                    height: 40.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    child: const Center(child: Text("Print"))),
              ),
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
                          DataColumn(label: Text('Transaksi')),
                          DataColumn(label: Text('Jenis')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Harga')),
                          DataColumn(label: Text('Total (per item)')),
                        ],
                        rows: purchasesMount.expand((purchase) {
                          final typeTransaksi =
                              purchase['Type Transaksi'] ?? 'Unknown';
                          final items = purchase['items'] ?? [];

                          Map<String, Map<String, dynamic>> itemMap = {};

                          items.forEach((item) {
                            final itemName = item['Nama Barang'] ?? 'Unknown';
                            final modal = (typeTransaksi == 'Stok')
                                ? item['Harga Modal']
                                : item['Harga Awal'] ?? 0;
                            final unit = item['Banyak Barang'] ?? 0;
                            if (unit == 0) return;
                            final jenis = item['Jenis Barang'] ?? 'Unknown';
                            final price = (typeTransaksi == 'Stok')
                                ? modal
                                : item['Harga Jual'] ?? 0;

                            final key = '$itemName-$jenis-$modal-$price';
                            if (itemMap.containsKey(key)) {
                              itemMap[key]!['Unit'] += unit;
                              itemMap[key]!['Total'] =
                                  itemMap[key]!['Unit'] * price;
                            } else {
                              itemMap[key] = {
                                'Nama Barang': itemName,
                                'Transaksi': typeTransaksi,
                                'Jenis Barang': jenis,
                                'Unit': unit,
                                'Harga': price,
                                'Total': unit * price,
                              };
                            }
                          });

                          List<DataRow> rows = itemMap.values.map((item) {
                            final DataRow row = DataRow(cells: [
                              DataCell(Text(item['Nama Barang'])),
                              DataCell(Text(item['Transaksi'])),
                              DataCell(Text(item['Jenis Barang'])),
                              DataCell(Text(item['Unit'].toString())),
                              DataCell(Text(formatRupiah(item['Harga']))),
                              DataCell(Text(formatRupiah(item['Total']))),
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
                            int totalHarga = 0;
                            for (var purchase in purchasesMount) {
                              if (purchase['Type Transaksi'] != 'Stok') {
                                totalHarga +=
                                    (purchase['Total Harga'] ?? 0) as int;
                              }
                            }
                            return Text(formatRupiah(totalHarga),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Capital :", textAlign: TextAlign.left),
                          SizedBox(width: 140.w),
                          Obx(() {
                            num totalCapital = 0;
                            for (var purchase in purchasesMount) {
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Modal'] ?? 0;
                                totalCapital += unit * modal;
                              });
                            }
                            return Text(formatRupiah(totalCapital as int));
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
                            num totalHarga = 0;
                            num totalCapital = 0;
                            for (var purchase in purchasesMount) {
                              totalHarga += purchase['Total Harga'] ?? 0;
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Modal'] ?? 0;
                                totalCapital += unit * modal;
                              });
                            }
                            final netIncome = totalHarga - totalCapital;
                            return Text(formatRupiah(netIncome as int),
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
              GestureDetector(
                onTap: () async {
                  await printPdf(purchasesYearly, "Tahunan", 4);
                },
                child: Container(
                    width: 100.w,
                    height: 40.h,
                    color: const Color.fromRGBO(217, 217, 217, 1),
                    child: const Center(child: Text("Print"))),
              ),
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
                          DataColumn(label: Text('Transaksi')),
                          DataColumn(label: Text('Jenis')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Harga')),
                          DataColumn(label: Text('Total (per item)')),
                        ],
                        rows: purchasesYearly.expand((purchase) {
                          final typeTransaksi =
                              purchase['Type Transaksi'] ?? 'Unknown';
                          final items = purchase['items'] ?? [];

                          Map<String, Map<String, dynamic>> itemMap = {};

                          items.forEach((item) {
                            final itemName = item['Nama Barang'] ?? 'Unknown';
                            final modal = (typeTransaksi == 'Stok')
                                ? item['Harga Modal']
                                : item['Harga Awal'] ?? 0;
                            final unit = item['Banyak Barang'] ?? 0;
                            if (unit == 0) return;
                            final jenis = item['Jenis Barang'] ?? 'Unknown';
                            final price = (typeTransaksi == 'Stok')
                                ? modal
                                : item['Harga Jual'] ?? 0;

                            final key = '$itemName-$jenis-$modal-$price';
                            if (itemMap.containsKey(key)) {
                              itemMap[key]!['Unit'] += unit;
                              itemMap[key]!['Total'] =
                                  itemMap[key]!['Unit'] * price;
                            } else {
                              itemMap[key] = {
                                'Nama Barang': itemName,
                                'Transaksi': typeTransaksi,
                                'Jenis Barang': jenis,
                                'Unit': unit,
                                'Harga': price,
                                'Total': unit * price,
                              };
                            }
                          });

                          List<DataRow> rows = itemMap.values.map((item) {
                            final DataRow row = DataRow(cells: [
                              DataCell(Text(item['Nama Barang'])),
                              DataCell(Text(item['Transaksi'])),
                              DataCell(Text(item['Jenis Barang'])),
                              DataCell(Text(item['Unit'].toString())),
                              DataCell(Text(formatRupiah(item['Harga']))),
                              DataCell(Text(formatRupiah(item['Total']))),
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
                            int totalHarga = 0;
                            for (var purchase in purchasesYearly) {
                              if (purchase['Type Transaksi'] != 'Stok') {
                                totalHarga +=
                                    (purchase['Total Harga'] ?? 0) as int;
                              }
                            }
                            return Text(formatRupiah(totalHarga),
                                textAlign: TextAlign.right);
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Capital :", textAlign: TextAlign.left),
                          SizedBox(width: 140.w),
                          Obx(() {
                            num totalCapital = 0;
                            for (var purchase in purchasesYearly) {
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Modal'] ?? 0;
                                totalCapital += unit * modal;
                              });
                            }
                            return Text(formatRupiah(totalCapital as int));
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
                            num totalHarga = 0;
                            num totalCapital = 0;
                            for (var purchase in purchasesYearly) {
                              totalHarga += purchase['Total Harga'] ?? 0;
                              final items = purchase['items'] ?? [];
                              items.forEach((item) {
                                final unit = item['Banyak Barang'] ?? 0;
                                final modal = item['Harga Modal'] ?? 0;
                                totalCapital += unit * modal;
                              });
                            }
                            final netIncome = totalHarga - totalCapital;
                            return Text(formatRupiah(netIncome as int),
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

  Future<void> printPdf(List<Map<String, dynamic>> purchasinData, String jenis,
      int datecut) async {
    final pdf = pw.Document();
    final List<Map<String, dynamic>> rows = [];
    int totalHarga = 0;
    for (var purchase in purchasinData) {
      if (purchase['Type Transaksi'] != 'Stok') {
        totalHarga += (purchase['Total Harga'] ?? 0) as int;
      }
    }
    num totalCapital = 0;
    for (var purchase in purchasinData) {
      final items = purchase['items'] ?? [];
      items.forEach((item) {
        final unit = item['Banyak Barang'] ?? 0;
        final modal = item['Harga Modal'] ?? 0;
        totalCapital += unit * modal;
      });
    }
    final netIncome = totalHarga - totalCapital;
    for (var purchase in purchasinData) {
      final typeTransaksi = purchase['Type Transaksi'] ?? 'Unknown';
      final items = purchase['items'] ?? [];

      for (var item in items) {
        final itemName = item['Nama Barang'] ?? 'Unknown';
        final modal = (typeTransaksi == 'Stok')
            ? item['Harga Modal']
            : item['Harga Awal'] ?? 0;
        final unit = item['Banyak Barang'] ?? 0;
        if (unit == 0) continue;
        final jenis = item['Jenis Barang'] ?? 'Unknown';
        final price =
            (typeTransaksi == 'Stok') ? modal : item['Harga Jual'] ?? 0;
        final total = unit * price;

        final existingItemIndex = rows.indexWhere((row) =>
            row['Nama Barang'] == itemName &&
            row['Jenis Barang'] == jenis &&
            row['Modal'] == modal &&
            row['Harga'] == price);

        if (existingItemIndex != -1) {
          rows[existingItemIndex]['Unit'] += unit;
          rows[existingItemIndex]['Total'] += total;
        } else {
          rows.add({
            'Nama Barang': itemName,
            'Transaksi': typeTransaksi,
            'Jenis Barang': jenis,
            'Unit': unit,
            'Modal': modal,
            'Harga': price,
            'Total': total,
          });
        }
      }
    }
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 10),
              child: pw.Text(
                'Laporan $jenis',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    'Tanggal : ${purchasinData.isNotEmpty ? purchasinData[0]['Date'].toString().substring(0, datecut) : ''}',
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 10.h,
            ),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {0: const pw.FlexColumnWidth(1)},
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors
                          .grey300, // Warna latar belakang untuk baris tabel
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Nama',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Container(
                      color: PdfColors
                          .grey300, // Warna latar belakang untuk baris tabel
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Transaksi',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Container(
                      color: PdfColors.grey300,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Jenis',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Container(
                      color: PdfColors.grey300,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Unit',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Container(
                      color: PdfColors.grey300,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Harga',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Container(
                      color: PdfColors.grey300,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Total (per item)',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                ...rows.map((row) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(row['Nama Barang'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(row['Transaksi'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(row['Jenis Barang'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(row['Unit'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(formatRupiah(row['Harga'] as int)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(formatRupiah(row['Total'] as int)),
                      ),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(
              height: 10.h,
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    'Total Income :     ${formatRupiah(totalHarga)}',
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    'Capital :               ${formatRupiah(totalCapital as int)}',
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.SizedBox(
                  width: 200.w,
                  child: pw.Divider(thickness: 1, color: PdfColors.black),
                ),
                pw.SizedBox(width: 10.w),
                pw.SizedBox(
                  width: 10.w,
                  child: pw.Divider(thickness: 1, color: PdfColors.black),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    'Net Income :        ${formatRupiah(netIncome as int)}',
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
