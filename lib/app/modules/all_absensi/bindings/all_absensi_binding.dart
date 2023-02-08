import 'package:get/get.dart';

import '../controllers/all_absensi_controller.dart';

class AllAbsensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllAbsensiController>(
      () => AllAbsensiController(),
    );
  }
}
