import 'package:get/get.dart';

import '../controllers/workhome_controller.dart';

class WorkhomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkhomeController>(
      () => WorkhomeController(),
    );
  }
}
