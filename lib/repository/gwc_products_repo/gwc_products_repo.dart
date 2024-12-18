import 'package:file_picker/file_picker.dart';

import '../api_service.dart';

class GwcProductsRepository{
  ApiClient apiClient;

  GwcProductsRepository({required this.apiClient});

  Future submitGwcProductsRepo(Map details) async{
    return await apiClient.submitGwcProductsApi(details);
  }

  Future getGwcProductsRepo() async{
    return await apiClient.getGwcProductsApi();
  }
}