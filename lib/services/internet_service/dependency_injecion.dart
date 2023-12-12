import 'package:get/get.dart';

import 'network_service.dart';

class DependencyInjection {
  static void init() async {
    //services
    Get.put<NetworkStatusService>(NetworkStatusService(), permanent: true);
  }
}