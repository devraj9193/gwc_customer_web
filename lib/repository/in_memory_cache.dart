
import '../model/new_user_model/about_program_model/about_program_model.dart';

class InMemoryCache {
  static InMemoryCache? _instance;
  factory InMemoryCache() => _instance ??=  InMemoryCache._();
  InMemoryCache._();


  static Map<String, AboutProgramModel> aboutProgramModel = {};
  static void updateAboutProgramModel(String key, AboutProgramModel data) {
    aboutProgramModel[key] = data;
  }



  final Map<String, dynamic> cache = {};

  dynamic get(String key) => cache[key];

  void set(String key, dynamic value) => cache[key] = value;


}