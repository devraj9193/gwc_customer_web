import 'package:gwc_customer/model/home_remedy_model/home_remedies_model.dart';

import '../api_service.dart';

class HomeRemediesRepository {
  ApiClient? apiClient;

  HomeRemediesRepository({required this.apiClient}) : assert(apiClient != null);

  Future<HomeRemediesModel> getHomeRemediesRepo() async{
    return await apiClient?.getHomeRemediesApi();
  }
}