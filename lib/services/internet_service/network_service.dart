
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get/get.dart';
import 'network_error_item.dart';

class NetworkStatusService extends GetxService {
  NetworkStatusService() {
    DataConnectionChecker().onStatusChange.listen(
          (status) async {
         _getNetworkStatus(status);
      },
    );
  }

  void _getNetworkStatus(DataConnectionStatus status) {
    if (status == DataConnectionStatus.connected) {
      _validateSession(); //after internet connected it will redirect to home page
    } else {
      Get.dialog(const NetworkErrorItem(), useSafeArea: false); // If internet loss then it will show the NetworkErrorItem widget
    }
  }

  void _validateSession() {
     // Navigator.pushNamed((_), "/MyApp");
     Get.offNamedUntil("MyApp", (_) => false); //Here redirecting to home page
  }
}