/*
this file is used as common functions for the call support methods
 */

import '../../repository/api_service.dart';
import '../../repository/profile_repository/settings_repo.dart';
import 'package:http/http.dart' as http;

import '../../services/profile_screen_service/settings_service.dart';


callSupport() async{
  final res = await SettingsService(repository: repository).getCallSupportService();
  print(res);
  return res;
}


final SettingsRepository repository = SettingsRepository(
  apiClient: ApiClient(
    httpClient: http.Client(),
  ),
);


supportVoiceCall(String kaleyraUID, String kaleyraSuccessID, String accessToken) async{
  final res = await SettingsService(repository: repository).callToSupportTeam(kaleyraUID, kaleyraSuccessID, accessToken);
  return res;
}

Future openKaleyraChat(String name, String opponentId, String accessToken) async{
  final res = await SettingsService(repository: repository).openKaleyraChat(name, opponentId, accessToken);
  return res;
}

void callKaleyraGlobally(String name,String accessToken) async{
  final res = await SettingsService(repository: repository).callKaleyraGloballyChannel(name, accessToken);
  return res;
}


Future getAccessToken(String kaleyraUID) async{
  final res = await SettingsService(repository: repository).getAccessToken(kaleyraUID);
  return res;
}