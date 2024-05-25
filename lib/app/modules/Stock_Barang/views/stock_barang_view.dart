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
      body: Center(
        child: Column(
          children: [
            DataTable(
              border: TableBorder.all(color: Colors.black),
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Makanan',
                    style: TextStyle(fontWeight: FontWeight.bold,),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Stock',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Row(
                      children: [
                        const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Logo_Funtime.jpg")),
                        SizedBox(width: 10.w),
                        const Flexible(child: Text('Pisang Goreng Crispy')),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.add)
                        ),
                        const Text('25'),
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.remove)
                        ),
                      ],
                    )),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Row(
                      children: [
                        const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Logo_Funtime.jpg")),
                        SizedBox(width: 10.w),
                        const Flexible(child: Text('Kentang Goreng')),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.add)
                        ),
                        const Text('25'),
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.remove)
                        ),
                      ],
                    )),
                  ],
                ),
               DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Row(
                      children: [
                        const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Logo_Funtime.jpg")),
                        SizedBox(width: 10.w),
                        const Flexible(child: Text('Sosis Keju')),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.add)
                        ),
                        const Text('25'),
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.remove)
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            DataTable(
              border: TableBorder.all(color: Colors.black),
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Minuman',
                    style: TextStyle(fontWeight: FontWeight.bold,),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Stock',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Row(
                      children: [
                        const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Logo_Funtime.jpg")),
                        SizedBox(width: 10.w),
                        const Flexible(child: Text('Juice Mangga')),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.add)
                        ),
                        const Text('25'),
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.remove)
                        ),
                      ],
                    )),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Row(
                      children: [
                        const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Logo_Funtime.jpg")),
                        SizedBox(width: 10.w),
                        const Flexible(child: Text('Juice Jeruk')),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.add)
                        ),
                        const Text('25'),
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.remove)
                        ),
                      ],
                    )),
                  ],
                ),
               DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Row(
                      children: [
                        const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/Logo_Funtime.jpg")),
                        SizedBox(width: 10.w),
                        const Flexible(child: Text('Juice Nanas')),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.add)
                        ),
                        const Text('25'),
                        IconButton(
                          onPressed: (){
                        }, 
                        icon: const Icon(Icons.remove)
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: (){

      },
      child: const Icon(Icons.add),
      ) ,
    );
  }
}
