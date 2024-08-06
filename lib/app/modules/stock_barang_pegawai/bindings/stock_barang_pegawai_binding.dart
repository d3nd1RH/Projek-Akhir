import 'package:get/get.dart';

import '../controllers/stock_barang_pegawai_controller.dart';

class StockBarangPegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockBarangPegawaiController>(
      () => StockBarangPegawaiController(),
    );
  }
}
