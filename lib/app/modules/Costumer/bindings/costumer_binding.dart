import 'package:get/get.dart';

import '../controllers/costumer_controller.dart';

class CostumerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CostumerController>(
      () => CostumerController(),
    );
  }
}
