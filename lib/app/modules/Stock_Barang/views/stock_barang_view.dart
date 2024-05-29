import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/stock_barang_controller.dart';

class StockBarangView extends GetView<StockBarangController> {
  const StockBarangView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Barang'),
        titleTextStyle: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold,color: Colors.black),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(172, 69, 150, 1),
        actions: [
            IconButton(
              icon: const Icon(Icons.search,color: Colors.black,),
              onPressed: () {
              
              },
            ),
        ],
      ),
       body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Obx(() {
                return DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Makanan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stock',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: controller.makananList.map((item) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          GestureDetector(
                            onTap: (){
                              controller.editDeleteBarang(item['docId']);
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: item['imageURL'] != null && item['imageURL'] != ""
                                    ? NetworkImage(item['imageURL'])
                                    : const AssetImage("assets/images/Logo_Funtime.jpg") as ImageProvider,
                                ),
                                SizedBox(width: 10.w),
                                Flexible(child: Text(item['nama'].length <= 15 ? item['nama'] : item['nama'].substring(0, 15) + '...',
                                )),
                              ],
                            ),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                int newStock = item['Banyak'] + 1;
                                controller.updateStock(item['docId'], newStock);
                              },
                              icon: const Icon(Icons.add),
                            ),
                            Text(
                              item['Banyak'] > 999 ? '999+' : item['Banyak'].toString()
                            ),
                            IconButton(
                              onPressed: () {
                                int newStock = item['Banyak'] - 1;
                                if (newStock >= 0) {
                                  controller.updateStock(item['docId'], newStock);
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                );
              }),
              SizedBox(height: 20.h),
              Obx(() {
                return DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Minuman',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stock',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: controller.minumanList.map((item) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          GestureDetector(
                            onTap: (){
                              controller.editDeleteBarang(item['docId']);
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: item['imageURL'] != null && item['imageURL'] != ""
                                    ? NetworkImage(item['imageURL'])
                                    : const AssetImage("assets/images/Logo_Funtime.jpg") as ImageProvider,
                                ),
                                SizedBox(width: 10.w),
                                Flexible(child: Text(item['nama'].length <= 15 ? item['nama'] : item['nama'].substring(0, 15) + '...'
                                )),
                              ],
                            ),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                int newStock = item['Banyak'] + 1;
                                controller.updateStock(item['docId'], newStock);
                              },
                              icon: const Icon(Icons.add),
                            ),
                            Text(item['Banyak'] > 999 ? '999+' : item['Banyak'].toString()),
                            IconButton(
                              onPressed: () {
                                int newStock = item['Banyak'] - 1;
                                if (newStock >= 0) {
                                  controller.updateStock(item['docId'], newStock);
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                );
              }),
              SizedBox(height: 20.h),
              Obx(() {
                return DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Lainnya',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stock',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: controller.lainnyaList.map((item) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          GestureDetector(
                            onTap: (){
                              controller.editDeleteBarang(item['docId']);
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: item['imageURL'] != null && item['imageURL'] != ""
                                    ? NetworkImage(item['imageURL'])
                                    : const AssetImage("assets/images/Logo_Funtime.jpg") as ImageProvider,
                                ),
                                SizedBox(width: 10.w),
                                Flexible(child: Text(item['nama'].length <= 15 ? item['nama'] : item['nama'].substring(0, 15) + '...'
                                )),
                              ],
                            ),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                int newStock = item['Banyak'] + 1;
                                controller.updateStock(item['docId'], newStock);
                              },
                              icon: const Icon(Icons.add),
                            ),
                            Text(item['Banyak'] > 999 ? '999+' : item['Banyak'].toString()),
                            IconButton(
                              onPressed: () {
                                int newStock = item['Banyak'] - 1;
                                if (newStock >= 0) {
                                  controller.updateStock(item['docId'], newStock);
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: (){
        controller.tambahBarang();
      },
      child: const Icon(Icons.add),
      ) ,
    );
  }
}
