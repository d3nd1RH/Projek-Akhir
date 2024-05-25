import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/lihat_laporan_controller.dart';

class LihatLaporanView extends GetView<LihatLaporanController> {
  const LihatLaporanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LihatLaporanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LihatLaporanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
