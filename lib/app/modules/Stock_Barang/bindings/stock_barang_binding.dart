import 'package:get/get.dart';

import '../controllers/stock_barang_controller.dart';

class StockBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockBarangController>(
      () => StockBarangController(),
    );
  }
}
