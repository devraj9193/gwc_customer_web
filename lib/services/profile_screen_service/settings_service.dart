import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../model/profile_model/terms_condition_model.dart';
import '../../repository/profile_repository/settings_repo.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';

class SettingsService extends ChangeNotifier{
  final SettingsRepository repository;

  SettingsService({required this.repository}) : assert(repository != null);

  Future<TermsConditionModel> getData() async{
    return await repository.getTermsCondition();
  }

  /// click to call method
  Future getCallSupportService() async{
    return await repository.getCallSupportRepo();
  }

  Future getFaqListService() async{
    return await repository.getFaqListRepo();
  }


  // voice call methods****************

  Future callToSupportTeam(String name, String successTeamId, String accessToken) async{
    final String channelName = "callNative";


    var channel = MethodChannel(channelName);
    print("callToSupportTeam");

    Map m = {
      'user_id': name,
      'access_token': accessToken,
      'success_id': successTeamId
    };

    print("m: $m");

    try{
      listenForCall();
      var result = await channel.invokeMethod("call_support", m).whenComplete(() {
        // _showProgress = false;
        // notifyListeners();
      });
      print("Provider callToSupportTeam" + result.toString());
      // final users = result['users'];
      // print("users: ${users.runtimeType}");
      notifyListeners();

    } on PlatformException catch(e){
      print("Provider callToSupportTeam error" + e.message.toString());
      // _errorMsg = e.message.toString();
      // _isGetHomeListSuccess = false;
      notifyListeners();
    }
    // return _isGetHomeListSuccess;
  }

  Future getAccessToken(String kaleyraUID) async{
    return await repository.getAccessTokenRepo(kaleyraUID);
  }

  listenForCall() async
  {
    String eventChannelName = "callNative1";

    print("Listen call");
    var channel1 = EventChannel(eventChannelName);

    //same key is used in the native code also
    try {
      print('called');
      var result;
      final result1 = channel1.receiveBroadcastStream('eventChannel');
      result1.asBroadcastStream().listen((event) async {
        // ("type","onNetworkStatusChanged");
        print("event==>: $event");

        if(event['error'] != null){
          // if(event['error'].toString().toLowerCase().contains("the chat i not ready to be loaded")){
          //   final _pref = AppConfig().preferences;
          //   final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
          //   await getAccessToken(uId!).then((value) {
          //
          //   });
          // }
          Get.snackbar(event['status'], event['error'].toString(),
            colorText: gWhiteColor,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: gsecondaryColor.withOpacity(0.55),
          );
        }

        // if(event['type'].toString().contains(Constants.onNetworkChange)){
        //   _deviceNetworkStatus = event['status'];
        // }
        // if(event['type'].toString().contains(Constants.onStatusChange)){
        //   _deviceStatus = event['status'].toString().contains("false") ? false : true;
        // }
      });
      // print("eventchannel: ${result1.asBroadcastStream().listen((event) async {
      //   // ("type","onNetworkStatusChanged");
      //   print("event==>: $event");
      //
      //   if(event['error'] != null){
      //     if(event['error'].toString().toLowerCase().contains("the chat i not ready to be loaded")){
      //       final _pref = AppConfig().preferences;
      //       final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
      //       await getAccessToken(uId!);
      //     }
      //     Get.snackbar(event['status'], event['error'].toString(),
      //       colorText: gWhiteColor,
      //       snackPosition: SnackPosition.BOTTOM,
      //       backgroundColor: gsecondaryColor.withOpacity(0.55),
      //     );
      //   }
      //
      //   // if(event['type'].toString().contains(Constants.onNetworkChange)){
      //   //   _deviceNetworkStatus = event['status'];
      //   // }
      //   // if(event['type'].toString().contains(Constants.onStatusChange)){
      //   //   _deviceStatus = event['status'].toString().contains("false") ? false : true;
      //   // }
      // })}");
      print("result1: $result1");
      notifyListeners();
      return result1;
    }
    on PlatformException catch (e) {
      print('error: $e');
      notifyListeners();
      // Unable to open the browser print(e);
    }
  }

// *************************************

  /// kaleyra Chat methods****************
  ///   // we need to get access token and need to pass here...

  Future openKaleyraChat(String name, String opponentId, String accessToken) async{
    final String channelName = "callNative";


    var channel = MethodChannel(channelName);
    print("CHAT");

    Map m = {
      'user_id': name,
      'access_token': accessToken,
      'opponent_id': opponentId
    };

    print("m: $m");

    try{
      listenForCall();
      var result = await channel.invokeMethod("chat_support", m).whenComplete(() {
        // _showProgress = false;
        // notifyListeners();
      });
      print("Provider openKaleyraChat" + result.toString());
      // final users = result['users'];
      // print("users: ${users.runtimeType}");
      notifyListeners();

    } on PlatformException catch(e){
      print("Provider openKaleyraChat error" + e.message.toString());
      // _errorMsg = e.message.toString();
      // _isGetHomeListSuccess = false;
      notifyListeners();
    }
    // return _isGetHomeListSuccess;
  }

  Future callKaleyraGloballyChannel(String name, String accessToken) async{
    final String channelName = "callNative";


    var channel = MethodChannel(channelName);
    print("CALL GLOBAL");

    Map m = {
      'user_id': name,
      'access_token': accessToken,
    };

    print("m: $m");

    try{
      var result = await channel.invokeMethod("call_global", m).whenComplete(() {
        // _showProgress = false;
        // notifyListeners();
      });
      print("Provider callKaleyraGloballyChannel" + result.toString());
      // final users = result['users'];
      // print("users: ${users.runtimeType}");
      notifyListeners();

    } on PlatformException catch(e){
      print("Provider callKaleyraGloballyChannel error" + e.message.toString());
      // _errorMsg = e.message.toString();
      // _isGetHomeListSuccess = false;
      notifyListeners();
    }
    // return _isGetHomeListSuccess;
  }


// *************************************





}