import 'package:get/get.dart';

import '../controllers/lihat_laporan_controller.dart';

class LihatLaporanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LihatLaporanController>(
      () => LihatLaporanController(),
    );
  }
}
