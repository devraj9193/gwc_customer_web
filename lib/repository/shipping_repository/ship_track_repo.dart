import '../api_service.dart';

class ShipTrackRepository{
  ApiClient apiClient;

  ShipTrackRepository({required this.apiClient}) : assert(apiClient != null);

  Future getShiprockeTokenRepo(String email, String password) async{
    return await apiClient.getShippingTokenApi(email, password);
  }

  Future getTrackingDetailsRepo(String awbNumber) async{
    return await apiClient.shipRocketTrackingTrackerApi(awbNumber);
  }

  Future getShoppingDetailsListRepo() async{
    return await apiClient.shoppingDetailsListApi();
  }

  Future sendSippingApproveStatusRepo(String approveStatus, String selectedDate) async{
    return await apiClient.shippingApproveApi(approveStatus, selectedDate);
  }

  Future getUserAddressRepo() async{
    return await apiClient.getUserAddressApi();
  }

  Future sendUserAddressRepo(Map details) async{
    return await apiClient.sendUserAddressApi(details);
  }
}