import 'package:get/get.dart';

import '../controllers/scurity_controller.dart';

class ScurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScurityController>(
      () => ScurityController(),
    );
  }
}
