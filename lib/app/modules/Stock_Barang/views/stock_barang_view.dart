import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/stock_barang_controller.dart';

class StockBarangView extends GetView<StockBarangController> {
  const StockBarangView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockBarangView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StockBarangView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
