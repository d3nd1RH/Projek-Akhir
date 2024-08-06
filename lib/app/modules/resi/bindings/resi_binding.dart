import 'package:get/get.dart';

import '../controllers/resi_controller.dart';

class ResiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResiController>(
      () => ResiController(),
    );
  }
}
