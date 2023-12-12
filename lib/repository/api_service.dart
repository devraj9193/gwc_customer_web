import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gwc_customer_web/model/combined_meal_model/combined_meal_model.dart';
import 'package:gwc_customer_web/model/home_remedy_model/home_remedies_model.dart';
import 'package:gwc_customer_web/model/prepratory_meal_model/get_prep_meal_track_model.dart';
import 'package:gwc_customer_web/model/prepratory_meal_model/prep_meal_model.dart';
import 'package:gwc_customer_web/model/prepratory_meal_model/transition_meal_model.dart';
import 'package:gwc_customer_web/model/user_slot_for_schedule_model/user_slot_days_schedule_model.dart';
import 'package:gwc_customer_web/repository/in_memory_cache.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:gwc_customer_web/model/dashboard_model/get_appointment/get_appointment_after_appointed.dart';
import 'package:gwc_customer_web/model/dashboard_model/get_dashboard_data_model.dart';
import 'package:gwc_customer_web/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer_web/model/enquiry_status_model.dart';
import 'package:gwc_customer_web/model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import 'package:gwc_customer_web/model/login_model/login_otp_model.dart';
import 'package:gwc_customer_web/model/login_model/resend_otp_model.dart';
import 'package:gwc_customer_web/model/message_model/get_chat_groupid_model.dart';
import 'package:gwc_customer_web/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:gwc_customer_web/model/notification_model/NotificationModel.dart';
import 'package:gwc_customer_web/model/post_program_model/breakfast/protocol_breakfast_get.dart';
import 'package:gwc_customer_web/model/post_program_model/post_program_base_model.dart';
import 'package:gwc_customer_web/model/post_program_model/post_program_new_model/pp_get_model.dart';
import 'package:gwc_customer_web/model/post_program_model/post_program_new_model/protocol_calendar_model.dart';
import 'package:gwc_customer_web/model/post_program_model/protocol_guide_day_score.dart';
import 'package:gwc_customer_web/model/post_program_model/protocol_summary_model.dart';
import 'package:gwc_customer_web/model/profile_model/feedback_model.dart';
import 'package:gwc_customer_web/model/profile_model/logout_model.dart';
import 'package:gwc_customer_web/model/profile_model/user_profile/update_user_model.dart';
import 'package:gwc_customer_web/model/program_model/proceed_model/get_proceed_model.dart';
import 'package:gwc_customer_web/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer_web/model/program_model/program_days_model/program_day_model.dart';
import 'package:gwc_customer_web/model/program_model/start_post_program_model.dart';
import 'package:gwc_customer_web/model/program_model/start_program_on_swipe_model.dart';
import 'package:gwc_customer_web/model/rewards_model/reward_point_model.dart';
import 'package:gwc_customer_web/model/rewards_model/reward_point_stages.dart';
import 'package:gwc_customer_web/model/ship_track_model/shiprocket_auth_model/shiprocket_auth_model.dart';
import 'package:gwc_customer_web/model/ship_track_model/shopping_model/get_shopping_model.dart';
import 'package:gwc_customer_web/model/ship_track_model/sipping_approve_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import '../meal_json.dart';
import '../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../model/consultation_model/appointment_slot_model.dart';
import '../model/dashboard_model/report_upload_model/report_list_model.dart';
import '../model/dashboard_model/report_upload_model/report_upload_model.dart';
import '../model/dashboard_model/shipping_approved/ship_approved_model.dart';
import '../model/error_model.dart';
import '../model/evaluation_from_models/get_country_details_model.dart';
import '../model/faq_model/faq_list_model.dart';
import '../model/home_model/bmi_bmr_model.dart';
import '../model/home_model/get_remainder_model.dart';
import '../model/home_model/graph_list_model.dart';
import '../model/medical_feedback_answer_model.dart';
import '../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../model/new_user_model/choose_your_problem/submit_problem_response.dart';
import '../model/new_user_model/register/register_model.dart';
import '../model/profile_model/terms_condition_model.dart';
import '../model/profile_model/user_profile/user_profile_model.dart';
import '../model/program_model/meal_plan_details_model/meal_plan_details_model.dart';
import '../model/ship_track_model/shipping_track_model.dart';
import '../model/success_message_model.dart';
import '../model/uvdesk_model/get_ticket_list_model.dart';
import '../model/uvdesk_model/get_ticket_threads_list_model.dart';
import '../model/uvdesk_model/new_ticket_details_model.dart';
import '../model/uvdesk_model/ticket_details_model.dart';
import '../utils/api_urls.dart';
import '../utils/app_config.dart';
import 'package:gwc_customer_web/model/home_model/home_model.dart';

class ApiClient {
  ApiClient({
    required this.httpClient,
  }) : assert(httpClient != null);

  final http.Client httpClient;

  final _prefs = AppConfig().preferences;

  late String agentToken =
      "Bearer ${_prefs?.getString(AppConfig.UV_API_ACCESS_TOKEN)}";

  String getHeaderToken() {
    if (_prefs != null) {
      final token = _prefs!.getString(AppConfig().BEARER_TOKEN);
      // AppConfig().tokenUser
      // .substring(2, AppConstant().tokenUser.length - 1);
      return "Bearer $token";
    } else {
      return "Bearer not got";
    }
  }

  Map<String, String> header = {
    "Content-Type": "application/json",
    "Keep-Alive": "timeout=5, max=1"
  };

  Future serverGetProblemList() async {
    final String path = getProblemListUrl;

    print('serverGetProblemList Response header: $path');
    dynamic result;

    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: header,
      )
          .timeout(const Duration(seconds: 45));

      print('serverGetProblemList Response header: $path');
      print('serverGetProblemList Response status: ${response.statusCode}');
      print('serverGetProblemList Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverGetProblemList result: $json');

      if (response.statusCode != 200) {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        if (json['status'] != 200) {
          result = ErrorModel.fromJson(json);
        } else {
          result = ChooseProblemModel.fromJson(json);
        }
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future submitProblemList(String deviceId,
      {List? problemList, String? otherProblem}) async {
    var url = submitProblemListUrl;

    Map param = {"device_id": deviceId, "problems[]": problemList.toString()};
    // if(problemList != null){
    //   problemList.forEach((element) {
    //     param.putIfAbsent(
    //         "problems[${problemList.indexWhere((ele) => ele == element)}]",
    //             () => element.toString());
    //   });
    // }
    if (otherProblem != null) {
      param.putIfAbsent("other_problem", () => otherProblem);
    }

    print(jsonEncode(param));
    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(url),
        body: param,
      );

      print('submitProblemList Response status: ${response.statusCode}');
      print('submitProblemList Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('submitProblemList result: $json');
        result = SubmitProblemResponse.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('submitProblemList error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(),
            message: 'error getting quotes');
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future serverRegisterUser(
      {required String name,
        required int age,
        required String gender,
        required String email,
        required String countryCode,
        required String phone,
        required String deviceId,
        required String fcmToken}) async {
    final String path = registerUserUrl;

    Map bodyParam = {
      'name': name,
      'age': age.toString(),
      'gender': gender,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      "device_id": deviceId,
      "device_token": fcmToken
    };

    print(bodyParam);
    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(path),
        body: bodyParam,
      );

      print('serverRegisterUser Response header: $path');
      print('serverRegisterUser Response status: ${response.statusCode}');
      print('serverRegisterUser Response body: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('submitProblemList result: $json');
        if (json['status'].toString() == '201') {
          result = RegisterResponse.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      }
    } catch (e) {
      print("catch error: $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  final inMemoryStorage = InMemoryCache();

  Future serverGetAboutProgramDetails() async {
    final String path = getAboutProgramUrl;
    dynamic result;

    print('serverGetAboutProgramDetails Response header: $path');

    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: header,
      )
          .timeout(const Duration(seconds: 45));

      print('serverGetAboutProgramDetails Response header: $path');
      print(
          'serverGetAboutProgramDetails Response status: ${response.statusCode}');
      print('serverGetAboutProgramDetails Response body: ${response.body}');

      final json = jsonDecode(response.body);
      print('serverGetAboutProgramDetails result: $json');

      if (response.statusCode != 200) {
        print("error: $json");
        result = ErrorModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else if (json['status'].toString().contains("200")) {
        print("else 1st");
        final newHash = sha1.convert(utf8.encode(json.toString())).toString();

        result = AboutProgramModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  Future getShippingTokenApi(String email, String password) async {
    final path = shippingApiLoginUrl;

    Map bodyParam = {"email": email, "password": password};

    dynamic result;

    try {
      final response = await httpClient
          .post(Uri.parse(path), body: bodyParam)
          .timeout(Duration(seconds: 45));

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ShipRocketTokenModel.fromJson(jsonDecode(response.body));
        storeShipRocketToken(result);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverShippingTrackerApi(String awbNumber) async {
    print(awbNumber);
    final String path = '$shippingApiUrl/$awbNumber';
    dynamic result;

    String shipToken = _prefs?.getString(AppConfig().shipRocketBearer) ?? '';

    Map<String, String> shipRocketHeader = {
      "Authorization": "Bearer $shipToken",
      "Content-Type": "application/json"
    };

    print('shiptoken: $shipToken');
    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: shipRocketHeader,
      )
          .timeout(const Duration(seconds: 45));

      print('serverShippingTrackerApi Response header: $path');
      print('serverShippingTrackerApi Response status: ${response.statusCode}');
      print('serverShippingTrackerApi Response body: ${response.body}');

      if (response.statusCode != 200) {
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        final res = jsonDecode(response.body);
        result = ShippingTrackModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  serverLoginWithOtpApi(String phone, String otp, String fcm) async {
    var path = loginWithOtpUrl;

    dynamic result;

    Map bodyParam = {'phone': phone, 'otp': otp, 'device_token': fcm};

    try {
      final response = await httpClient
          .post(Uri.parse(path), body: bodyParam)
          .timeout(Duration(seconds: 45));

      print('serverLoginWithOtpApi Response header: $path');
      print('serverLoginWithOtpApi Response status: ${response.statusCode}');
      print('serverLoginWithOtpApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (res['status'] == 200) {
          result = loginOtpFromJson(response.body);
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  serverLogoutApi() async {
    var path = logOutUrl;

    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 45));

      print('serverLogoutApi Response header: $path');
      print('serverLogoutApi Response status: ${response.statusCode}');
      print('serverLogoutApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (res['status'] == 200) {
          result = LogoutModel.fromJson(res);
          inMemoryStorage.cache.clear();
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  serverGetOtpApi(String phone) async {
    String path = getOtpUrl;

    dynamic result;

    Map bodyParam = {'phone': phone};

    try {
      final response = await httpClient
          .post(Uri.parse(path), body: bodyParam)
          .timeout(Duration(seconds: 45));

      print('serverGetOtpApi Response header: $path');
      print('serverGetOtpApi Response status: ${response.statusCode}');
      print('serverGetOtpApi Response body: ${response.body}');

      final res = jsonDecode(response.body);

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        if (res['status'] == 200) {
          result = getOtpFromJson(response.body);
        } else {
          result = ErrorModel.fromJson(res);
        }
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  /// date should be 2022-04-15 format
  Future getAppointmentSlotListApi(String selectedDate,
      {String? appointmentId}) async {
    final path = getAppointmentSlotsListUrl + selectedDate;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    var result;
    print("appointmentId: $appointmentId");

    Map<String, dynamic> param = {'appointment_id': appointmentId};
    Map<String, String> header = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      if (appointmentId == null) {
        print("First Slot");
      } else {
        print("Existing Slot");
      }

      final response = (appointmentId != null)
          ? await httpClient
          .post(Uri.parse(path), headers: header, body: param)
          .timeout(const Duration(seconds: 45))
          : await httpClient
          .get(
        Uri.parse(path),
        headers: header,
      )
          .timeout(const Duration(seconds: 45));

      print("getAppointmentSlotListApi response path:" + path);

      print("getAppointmentSlotListApi response code:" +
          response.statusCode.toString());
      print("getAppointmentSlotListApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'] == 200) {
        result = SlotModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future bookAppointmentApi(String date, String slotTime,
      {String? appointmentId, bool isPostprogram = false}) async {
    final path = bookAppointmentUrl;

    print("is from postprogram==> ${isPostprogram}");

    var startTime = DateTime.now().millisecondsSinceEpoch;

    Map param = {'booking_date': date, 'slot': slotTime};
    if (isPostprogram == true) {
      param.putIfAbsent("status", () => 'post_program');
    }
    if (appointmentId != null) {
      param.putIfAbsent('appointment_id', () => appointmentId);
    }
    var result;

    try {
      if (appointmentId == null) {
        print("Normal Appointment");
      } else {
        print("Reschedule Appointment");
      }
      print("param: ${param}");
      final response = await httpClient.post(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
        body: param,
      );
      print(
          "bookAppointmentApi response code:" + response.statusCode.toString());
      print("bookAppointmentApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        print(res);
        result = AppointmentBookingModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future enquiryStatusApi(String deviceId) async {
    final path = enquiryStatusUrl;

    Map<String, String> param = {
      'device_id': deviceId,
    };

    final startTime = DateTime.now().millisecondsSinceEpoch;

    var result;

    try {
      print("param: $param");

      // final response = await httpClient.post(
      //   Uri.parse(path),
      //   body: param,
      // ).timeout(Duration(seconds: 45));

      var request = http.MultipartRequest('POST', Uri.parse(path));

      request.fields.addAll(param);
      request.persistentConnection = false;

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print("enquiryStatusApi response code:" + response.statusCode.toString());
      print("enquiryStatusApi response body:" + response.body);

      print("getAppointmentSlotListApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;

      print("response: $totalTime");

      final res = jsonDecode(response.body);

      print('${res['status'].runtimeType} ${res['status']}');

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(res);
      } else if (res['status'].toString() == '200') {
        result = EnquiryStatusModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future submitEvaluationFormApi(
      Map form, List<PlatformFile>? medicalReports) async {
    final path = submitEvaluationFormUrl;

    var result;
    var startTime = DateTime.now().millisecondsSinceEpoch;
    print("form: $form");

    form.forEach((key, value) {
      print("$key---$value");
    });

    print("medical reports : $medicalReports");

    Map<String, String> m2 = Map.from(form);
    print(m2);
    // try {
    var request = http.MultipartRequest('POST', Uri.parse(path));
    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
      'Accept': 'application/json',
    };

    if (medicalReports != null) {
      medicalReports.forEach((element) async {
        request.files.add(await http.MultipartFile.fromBytes(
            'medical_report[]', medicalReports.first.bytes as List<int>,
            filename: medicalReports.first.name));
      });
    }

    // //-------Send request
    // var resp = await request.send();
    //
    // //------Read response
    // String results = await resp.stream.bytesToString();
    //
    // //-------Your response
    // print(results);

    request.headers.addAll(headers);
    request.fields.addAll(m2);

    print("upload files : ${request.files}");

    var response = await http.Response.fromStream(await request.send())
        .timeout(Duration(seconds: 50));

    print("submitEvaluationFormApi response code:" + path);
    print("submitEvaluationFormApi response code:" +
        response.statusCode.toString());
    print("submitEvaluationFormApi response body:" + response.body);
    var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
    print("response Time:" + (totalTime / 1000).round().toString());

    print(
        "start: $startTime end: ${DateTime.now().millisecondsSinceEpoch}  total: $totalTime");

    final res = jsonDecode(response.body);
    print('${res['status'].runtimeType} ${res['status']}');
    if (res['status'].toString() == '200') {
      result = ReportUploadModel.fromJson(res);
    } else if (response.statusCode == 500) {
      result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
    } else {
      result = ErrorModel.fromJson(res);
    }
    // } catch (e) {
    //   print("catch error: ${e}");
    //   result = ErrorModel(status: "0", message: e.toString());
    // }
    return result;
  }

  jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  Future serverGetEvaluationDetails() async {
    final String path = getEvaluationDataUrl;

    dynamic result;
    print(inMemoryStorage.cache.containsKey(path));

    // if(inMemoryStorage.cache.containsKey(path)){
    //   print("from cache");
    //   return result = GetEvaluationDataModel.fromJson(inMemoryStorage.get(path));
    // }

    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: headers,
      )
          .timeout(const Duration(seconds: 45));

      print('serverGetEvaluationDetails Response header: $path');
      print(
          'serverGetEvaluationDetails Response status: ${response.statusCode}');
      print('serverGetEvaluationDetails Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverGetEvaluationDetails result: $json');

      if (response.statusCode == 200) {
        if (json['status'].toString() != '200') {
          result = ErrorModel.fromJson(json);
        } else {
          inMemoryStorage.set(path, json);
          result = GetEvaluationDataModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetGutData() async {
    final String path = getDashboardDataUrl;

    dynamic result;

    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: headers,
      )
          .timeout(const Duration(seconds: 45));

      print('serverGetDashboardData Response header: $path');
      print('serverGetDashboardData Response status: ${response.statusCode}');
      print('serverGetDashboardData Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverGetDashboardData result: $json');

      if (response.statusCode == 200) {
        if (json['status'].toString() != '200') {
          result = ErrorModel.fromJson(json);
        } else {
          result = GetDashboardDataModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getUserProfileApi() async {
    final path = getUserProfileUrl;
    var result;

    print("token: ${getHeaderToken()}");
    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print(
          "getUserProfileApi response code:" + response.statusCode.toString());
      print("getUserProfileApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        final newHash = sha1.convert(utf8.encode(res.toString())).toString();

        print(inMemoryStorage.cache.containsKey(path));
        result = UserProfileModel.fromJson(res);
        _prefs?.setString(AppConfig.User_Name, res['data']['name'] ?? '');
        _prefs?.setString(AppConfig.User_Profile, res['data']['profile'] ?? '');
        _prefs?.setString(AppConfig.User_Number, res['data']['phone'] ?? '');
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("getUserProfileApi catch error ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future updateUserProfileApi(Map user) async {
    final path = updateUserProfileUrl;
    print(user);
    var result;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));
      var headers = {
        // "Authorization": "Bearer ${AppConfig().bearerToken}",
        "Authorization": getHeaderToken(),
      };
      Map bodyParam = {};
      user.forEach((key, value) {
        if (key != 'photo') {
          bodyParam.putIfAbsent(key, () => value);
        }
      });

      request.fields.addAll(Map.from(bodyParam));

      print("bodyParam: ${bodyParam}");
      if (user['photo'] != null) request.files.add(user['photo']);

      print(request.files);

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });
      request.headers.addAll(headers);

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      // final response = await httpClient
      //     .post(Uri.parse(path),
      //         headers: {
      //           // "Authorization": "Bearer ${AppConfig().bearerToken}",
      //           "Authorization": getHeaderToken(),
      //         },
      //         body: user)
      //     .timeout(const Duration(seconds: 45));

      print("updateUserProfileApi response code:" +
          response.statusCode.toString());
      print("updateUserProfileApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = UpdateUserModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("updateUserProfileApi catch error $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetTermsAndCondition() async {
    final String path = termsConditionUrl;

    final response = await httpClient.get(
      Uri.parse(path),
      headers: {"Content-Type": "application/json"},
    ).timeout(const Duration(seconds: 45));
    if (kDebugMode) {
      print('serverGetTermsAndCondition Response header: $path');
      print(
          'serverGetTermsAndCondition Response status: ${response.statusCode}');
      print('serverGetTermsAndCondition Response body: ${response.body}');
    }
    dynamic result;

    if (response.statusCode == 401) {
      final json = jsonDecode(response.body);
      print('serverGetTermsAndCondition error: $json');
      result = ErrorModel.fromJson(json);
    } else if (response.statusCode == 500) {
      result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
    } else if (response.statusCode != 200) {
      throw Exception('error  getting quotes');
    }

    final json = jsonDecode(response.body);
    print('serverGetTermsAndCondition result: $json');
    result = TermsConditionModel.fromJson(json);
    return result;
  }

  Future uploadReportApi(List reportList) async {
    final path = uploadReportUrl;

    var result;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));

      var headers = {
        // "Authorization": "Bearer ${AppConfig().bearerToken}",
        "Authorization": getHeaderToken(),
      };

      request.files.addAll(reportList as List<http.MultipartFile>);

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });
      request.headers.addAll(headers);

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      print("uploadReportApi response code:" + path);
      print("uploadReportApi response code:" + response.statusCode.toString());
      print("uploadReportApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print(
          "start: $startTime end: ${DateTime.now().millisecondsSinceEpoch}  total: $totalTime");

      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = ReportUploadModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getUploadedReportListListApi() async {
    String path = getUserReportListUrl;
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print("getUploadedReportListApi Url:" + getUserReportListUrl);
      print("getUploadedReportListApi response code:" +
          response.statusCode.toString());
      print("getUploadedReportListApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = GetReportListModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getProgramDayListApi() async {
    final path = getMealProgramDayListUrl;
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print("getProgramDayListApi response code:" +
          response.statusCode.toString());
      print("getProgramDayListApi response body:" + response.body);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        print('${res['status'].runtimeType} ${res['status']}');
        if (res['status'].toString() == '200') {
          result = ProgramDayModel.fromJson(jsonDecode(response.body));
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('status not equal called');
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error::> $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  /// need to pass day 1,2,3,4.......... like this
  Future getMealPlanDetailsApi(String day) async {
    final path = '$getMealPlanDataUrl/$day';
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));
      print("url: $path");
      print("getMealPlanDetailsApi response code:" +
          response.statusCode.toString());
      print("getMealPlanDetailsApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');

      if (res['status'].toString() == '200') {
        result = MealPlanDetailsModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error$e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future proceedDayProgramList(
      ProceedProgramDayModel model,
      List<PlatformFile> files,
      String from,
      List<PlatformFile> mandatoryFile,
      ) async {
    var url = submitDayPlanDetailsUrl;

    dynamic result;

    print("proceedDayProgramList path: $url $from");

    print(Map.from(model.toJson()));
    Map<String, String> m = Map.from(model.toJson());

    if (from == "detox") {
      m.putIfAbsent("meal_plan_type", () => 1.toString());
    } else {
      m.putIfAbsent("meal_plan_type", () => 2.toString());
    }

    print("meal_plan_type: $m");
    // print(
    //     "model: ${json.encode(model.toJson()) == jsonEncode(model.toJson())}");

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      var headers = {
        // "Authorization": "Bearer ${AppConfig().bearerToken}",
        "Authorization": getHeaderToken(),
      };

      if (files != null) {
        files.forEach((element) async {
          request.files.add(await http.MultipartFile.fromBytes(
              'tracking_attachment', files.first.bytes as List<int>,
              filename: files.first.name));
        });
      }

      if (mandatoryFile != null) {
        mandatoryFile.forEach((element) async {
          request.files.add(await http.MultipartFile.fromBytes(
              'tongue_image', mandatoryFile.first.bytes as List<int>,
              filename: mandatoryFile.first.name));
        });
      }

      // if (files != null) {
      //   files.forEach((element) async {
      //     request.files.add(await http.MultipartFile.fromBytes(
      //         'tracking_attachment', element));
      //   });
      // }
      //
      // if (mandatoryFile != null) {
      //   mandatoryFile.forEach((element) async {
      //     request.files
      //         .add(await http.MultipartFile.fromBytes('tongue_image', element));
      //   });
      // }

      // request.files.addAll(files);
      // request.files.addAll(mandatoryFile);
      request.fields.addAll(m);

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });
      request.headers.addAll(headers);

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      print('proceedDayProgramList Response status: ${response.statusCode}');
      print('proceedDayProgramList Response body: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('proceedDayProgramList result: $json');
        if (json['status'].toString() == "200") {
          result = GetProceedModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('proceedDayProgramList error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future shoppingDetailsListApi() async {
    final String path = shoppingListApiUrl;
    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('shoppingDetailsListApi Response header: $path');
      print('shoppingDetailsListApi Response status: ${response.statusCode}');
      print('shoppingDetailsListApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'] == 200) {
          result = GetShoppingListModel.fromJson(res);
        } else if (response.statusCode == 500) {
          result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
        } else {
          result = ErrorModel.fromJson(jsonDecode(response.body));
        }
      } else {
        print('proceedDayProgramList error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  Future shippingApproveApi(String approveStatus, String selectedDate) async {
    final String path = shoppingApproveApiUrl;
    dynamic result;

    /// new parameter added as date:
    /// by default status should be yes
    Map bodyParam = {'status': 'yes', 'date': selectedDate};

    try {
      final response = await httpClient
          .post(Uri.parse(path),
          headers: {
            // "Authorization": "Bearer ${AppConfig().bearerToken}",
            "Authorization": getHeaderToken(),
          },
          body: bodyParam)
          .timeout(const Duration(seconds: 45));

      print('shippingApproveApi Response header: $path');
      print('shippingApproveApi Response status: ${response.statusCode}');
      print('shippingApproveApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'] == 200) {
          result = ShippingApproveModel.fromJson(res);
        } else {
          result = ErrorModel.fromJson(jsonDecode(response.body));
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('shippingApproveApi error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }
  //https://api.worldpostallocations.com/?postalcode=570008&countrycode=IN

  getCountryDetails(String pincode, String countryCode) async {
    final String url = "http://www.postalpincode.in/api/pincode/";
    final String path = url + pincode;
    // final String url = "https://api.worldpostallocations.com/";
    // final String path = url + "?postalcode=$pincode&countrycode=$countryCode";
    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('getCountryDetails Response header: $path');
      print('getCountryDetails Response status: ${response.statusCode}');
      print('getCountryDetails Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['Status'].toString().toLowerCase() == "success") {
          result = GetCountryDetailsModel.fromJson(res);
        } else {
          result = ErrorModel(status: "0", message: "No Data");
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('getCountryDetails error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  Future submitUserFeedbackDetails(
      Map feedback, List<MultipartFile> files) async {
    final String path = submitFeedbackUrl;

    dynamic result;

    Map bodyParam = feedback;

    print(bodyParam);
    print(files);
    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));

      request.headers.addAll(headers);
      request.fields.addAll(Map.from(bodyParam));

      if (files.isNotEmpty) {
        request.files.addAll(files);
      }
      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      print('submitUserFeedbackDetails Response header: $path');
      print(
          'submitUserFeedbackDetails Response status: ${response.statusCode}');
      print('submitUserFeedbackDetails Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('submitUserFeedbackDetails result: $json');

      if (response.statusCode == 200) {
        if (json['status'].toString() != '200') {
          result = ErrorModel.fromJson(json);
        } else {
          result = FeedbackModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetCallSupportDetails() async {
    final String path = getCallSupportUrl;

    print('serverGetCallSupportDetails Response header: $path');

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('serverGetCallSupportDetails Response header: $path');
      print(
          'serverGetCallSupportDetails Response status: ${response.statusCode}');
      print('serverGetCallSupportDetails Response body: ${response.body}');

      final json = jsonDecode(response.body);
      print('serverGetCallSupportDetails result: $json');
      print(json['status'].toString().contains("200"));
      if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else if (json['status'].toString().contains("200")) {
        result = AboutProgramModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  /// need to send 1 to startProgram
  /// 1 -- detox
  /// 2 -- prep
  /// 3 -- nourish trans
  /// 4 -- healing
  Future startProgramOnSwipeApi(String startProgram) async {
    final path = startProgramOnSwipeUrl;

    Map<String, String> param = {
      'start_program': startProgram,
      'date': DateFormat('dd-MM-yyyy').format(DateTime.now())
    };

    final startTime = DateTime.now().millisecondsSinceEpoch;

    var result;

    try {
      print("param: $param");

      // final response = await httpClient.post(
      //   Uri.parse(path),
      //   body: param,
      // ).timeout(Duration(seconds: 45));

      var request = http.MultipartRequest('POST', Uri.parse(path));
      var headers = {
        "Authorization": getHeaderToken(),
      };
      request.headers.addAll(headers);

      request.fields.addAll(param);
      request.persistentConnection = false;

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print("startProgramOnSwipeApi response url:" + path);
      print("startProgramOnSwipeApi response code:" +
          response.statusCode.toString());
      print("startProgramOnSwipeApi response body:" + response.body);

      print("startProgramOnSwipeApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;

      print("response: $totalTime");

      final res = jsonDecode(response.body);

      print('${res['status'].runtimeType} ${res['status']}');

      if (response.statusCode != 200) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else if (res['status'].toString() == '200') {
        result = StartProgramOnSwipeModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  getChatGroupId() async {
    String path = chatGroupIdUrl;

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('getChatGroupId Response header: $path');
      print('getChatGroupId Response status: ${response.statusCode}');
      print('getChatGroupId Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'].toString() == '200') {
          result = GetChatGroupIdModel.fromJson(res);
        } else {
          result = ErrorModel(
              status: res['status'].toString(), message: res.toString());
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('getChatGroupId error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  Future startPostProgram() async {
    var url = startPostProgramUrl;

    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('startPostProgram Response status: ${response.statusCode}');
      print('startPostProgram Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('startPostProgram result: $json');
        result = StartPostProgramModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('startPostProgram error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  // this function is used for old flow now not using
  Future submitPostProgramMealTrackingApi(
      String mealType, int selectedType, int? dayNumber) async {
    print("submit :");
    var url = submitPostProgramMealTrackingUrl;

    dynamic result;

    Map bodyParam = {
      'type': mealType.toString(),
      'follow_id': selectedType.toString(),
      'day': dayNumber.toString()
    };

    print('body: $bodyParam');
    // print("token: ${getHeaderToken()}");

    try {
      final response = await httpClient.post(Uri.parse(url),
          headers: {
            "Authorization": getHeaderToken(),
          },
          body: bodyParam);

      print(
          'submitPostProgramMealTrackingApi Response status: ${response.statusCode}');
      print('submitPostProgramMealTrackingApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('submitPostProgramMealTrackingApi result: $json');
        result = PostProgramBaseModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print(
            'submitPostProgramMealTrackingApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future submitPPMealsApi(
      String stageType, String followId, int itemId, int? dayNumber) async {
    print("submit :");
    var url = submitPostProgramMealTrackingUrl;

    dynamic result;

    Map bodyParam = {
      'type': stageType,
      'follow_id': followId,
      'day': dayNumber.toString(),
      'item_id': itemId.toString()
    };

    print('body: $bodyParam');
    // print("token: ${getHeaderToken()}");

    try {
      final response = await httpClient.post(Uri.parse(url),
          headers: {
            "Authorization": getHeaderToken(),
          },
          body: Map.from(bodyParam));

      print('submitPPMealsApi Response status: ${response.statusCode}');
      print('submitPPMealsApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('submitPPMealsApi result: $json');
        result = PostProgramBaseModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('submitPPMealsApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  /// selectedType ==> breakfast/lunch/dinner
  Future getPPMealsOnStagesApi(int stage, String day) async {
    var url;
    switch (stage) {
      case 0:
        url = '$getPPEarlyMorningUrl/$day';
        break;
      case 1:
        url = '$getPPBreakfastUrl/$day';
        break;
      case 2:
        url = '$getPPMidDayUrl/$day';
        break;
      case 3:
        url = '$getPPLunchUrl/$day';
        break;
      case 4:
        url = '$getPPEveningUrl/$day';
        break;
      case 5:
        url = '$getPPDinnerUrl/$day';
        break;
      case 6:
        url = '$getPPPostDinnerUrl/$day';
        break;
    }

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getPPMealsOnStagesApi Response url: $url');

      print('getPPMealsOnStagesApi Response status: ${response.statusCode}');
      print('getPPMealsOnStagesApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getPPMealsOnStagesApi result: $json');
        result = PPGetMealModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('getPPMealsOnStagesApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getLunchOnclickApi(String day) async {
    // var url = '$getLunchOnclickUrl/$day';
    var url = '';

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getLunchOnclickApi Response status: ${response.statusCode}');
      print('getLunchOnclickApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getLunchOnclickApi result: $json');
        result = GetProtocolBreakfastModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('getLunchOnclickApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getDinnerOnclickApi(String day) async {
    // var url = '$getDinnerOnclickUrl/$day';
    var url = '';

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getDinnerOnclickApi Response status: ${response.statusCode}');
      print('getDinnerOnclickApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getDinnerOnclickApi result: $json');
        result = GetProtocolBreakfastModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('getDinnerOnclickApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  /// this is for old flow
  Future getProtocolDayDetailsApi({String? dayNumber}) async {
    var url;
    if (dayNumber != null) {
      url = '$getProtocolDayDetailsUrl/$dayNumber';
    } else {
      url = getProtocolDayDetailsUrl;
    }

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getProtocolDayDetailsApi Response status: ${response.statusCode}');
      print('getProtocolDayDetailsApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getProtocolDayDetailsApi result: $json');
        result = ProtocolGuideDayScoreModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('getProtocolDayDetailsApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future submitDoctorRequestedReportApi(
      List reportIds, List uploadFiles) async {
    final path = submitDoctorRequestedReportUrl;

    var result;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));
      var headers = {
        "Authorization": getHeaderToken(),
      };
      request.headers.addAll(headers);

      if (reportIds.isNotEmpty) {
        request.fields.addAll({'report_ids[]': reportIds.join(',').toString()});
      }
      // if(reportIds.isNotEmpty){
      //   reportIds.forEach((element) {
      //     request.fields.addAll({
      //       'report_ids[]': element.toString()
      //     });
      //   });
      // }

      print(request.fields);

      // if(reportId != "others"){
      //   request.fields.addAll({
      //     'report_id': reportId
      //   });
      // }
      // request.files.addAll(multipartFile);

      request.persistentConnection = false;

      if (uploadFiles != null) {
        uploadFiles.forEach((element) async {
          request.files
              .add(await http.MultipartFile.fromBytes('files[]', element));
        });
      }

      print("upload files : ${request.files}");

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print("submitDoctorRequestedReportApi response code:" + path);
      print("submitDoctorRequestedReportApi response code:" +
          response.statusCode.toString());
      print("submitDoctorRequestedReportApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print(
          "start: $startTime end: ${DateTime.now().millisecondsSinceEpoch}  total: $totalTime");

      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = ReportUploadModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future doctorRequestedReportListApi() async {
    final String path = doctorRequestedReportListUrl;

    print('doctorRequestedReportListApi Response header: $path');
    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('doctorRequestedReportListApi Response header: $path');
      print(
          'doctorRequestedReportListApi Response status: ${response.statusCode}');
      print('doctorRequestedReportListApi Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('doctorRequestedReportListApi result: $json');

      if (response.statusCode == 200) {
        if (json['status'] != 200) {
          result = ErrorModel.fromJson(json);
        } else {
          result = GetReportListModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  getNotificationListApi() async {
    String url = notificationListUrl;
    print(url);

    dynamic result;
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 45));

      print('getNotificationListApi Response status: ${response.statusCode}');
      print('getNotificationListApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'].toString() == '200') {
          result = NotificationModel.fromJsonMap(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getRewardPointsApi() async {
    var url = rewardPointsUrl;

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getRewardPointsApi Response status: ${response.statusCode}');
      print('getRewardPointsApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getRewardPointsApi result: $json');
        result = RewardPointModel.fromJson(json);
      } else {
        print('getRewardPointsApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getRewardPointsStagesApi() async {
    var url = rewardPointsStagesUrl;

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getRewardPointsStagesApi Response status: ${response.statusCode}');
      print('getRewardPointsStagesApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getRewardPointsStagesApi result: $json');
        result = RewardPointsStagesModel.fromJson(json);
      } else {
        print('getRewardPointsStagesApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getFaqListApi() async {
    String url = faqListUrl;
    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getFaqListApi result: $json');

        if (json['status'].toString() == '200') {
          result = FaqListModel.fromJson(json);
        } else {
          print('getFaqListApi error: $json');
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
    return result;
  }

  Future getHomeDetailsApi() async {
    String url = getHomeDetailsUrl;
    dynamic result;

    print("getHomeDetailsApi: $url");
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 50));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("getHomeDetailsApi result: $json");

        if (json['status'].toString() == '200') {
          result = HomeScreenModel.fromJson(json);
          print("getHomeDetailsApi serialize result: ${result}");
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getPPDayDetailsApi({String? dayNumber}) async {
    var url;
    if (dayNumber != null) {
      url = '$getProtocolDayDetailsUrl/$dayNumber';
    } else {
      url = getProtocolDayDetailsUrl;
    }

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getPPDayDetailsApi Response status: ${response.statusCode}');
      print('getPPDayDetailsApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getPPDayDetailsApi result: $json');
        result = PPGetMealModel.fromJson(json);
      } else {
        print('getPPDayDetailsApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getPPDaySummaryApi(String day) async {
    dynamic res;
    dynamic result;
    try {
      final response =
      await http.get(Uri.parse("$daySummaryUrl/$day"), headers: {
        'Authorization': getHeaderToken(),
      });
      res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        result = ProtocolSummary.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      return ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getPPCalendarApi() async {
    dynamic result;
    try {
      final response = await http.get(Uri.parse(ppCalendarUrl), headers: {
        'Authorization': getHeaderToken(),
      });
      print("PPCalendar response: ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        result = ProtocolCalendarModel.fromJson(res);
        // print("PPCalendar: ${calendarEvents[0].date?.year}, ${calendarEvents[0].date?.month}, ${calendarEvents[0].date?.day}");
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getKaleyraAccessTokenApi(String kaleyraUID) async {
    dynamic result;
    // production or sandbox
    final environment = "sandbox";
    final region = "eu";

    // testing api key: ak_live_c1ef0ed161003e0a2b419d20
    // final endPoint = "https://cs.${environment}.${region}.bandyer.com";

    /// live endpoint
    final endPoint = "https://api.in.bandyer.com";

    final String url = "$endPoint/rest/sdk/credentials";
    try {
      final response = await httpClient.post(Uri.parse(url),
          headers: {'apikey': 'ak_live_d2ad6702fe931fbeb2fa9cb4'},
          body: {"user_id": kaleyraUID});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        result = json['access_token'];
        print("access token got");
        _prefs!.setString(AppConfig.KALEYRA_ACCESS_TOKEN, result);
      } else {
        final json = jsonDecode(response.body);
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getPrepraoryMealsApi() async {
    dynamic result;

    try {
      final response =
      await httpClient.get(Uri.parse(prepratoryMealUrl), headers: {
        'Authorization': getHeaderToken(),
      });
      print("getPrepraoryMealsApi status code: ${response.statusCode}");
      print("getPrepraoryMealsApi body : ${response.body}");

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status'].toString() == '200') {
          result = PrepratoryMealModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getTransitionMealsApi() async {
    dynamic result;

    try {
      final response = await httpClient.get(Uri.parse(transitionMealUrl),
          // final response = await httpClient.get(Uri.parse(prepratoryMealUrl),
          headers: {
            'Authorization': getHeaderToken(),
          });

      print("getTransitionMealsApi url : ${transitionMealUrl}");
      print("getTransitionMealsApi status code: ${response.statusCode}");
      print("getTransitionMealsApi body... : ${response.body}");

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status'].toString() == '200') {
          result = TransitionMealModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future sendPrepratoryMealTrackDetailsApi(Map trackDetails) async {
    dynamic result;

    try {
      final response =
      await httpClient.post(Uri.parse(submitPrepratoryMealTrackUrl),
          headers: {
            'Authorization': getHeaderToken(),
          },
          body: trackDetails);
      print("submitPrepratoryMealTrackApi status code: ${response.statusCode}");
      print("submitPrepratoryMealTrackApi body : ${response.body}");

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status'].toString() == '200') {
          print('result: $response');
          result = SuccessMessageModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getPrepratoryMealTrackDetailsApi() async {
    dynamic result;

    try {
      final response =
      await httpClient.get(Uri.parse(getPrepratoryMealTrackUrl), headers: {
        'Authorization': getHeaderToken(),
      });
      print(
          "getPrepratoryMealTrackDetailsApi status code: ${response.statusCode}");
      print("getPrepratoryMealTrackDetailsApi body : ${response.body}");

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status'].toString() == '200') {
          result = GetPreparatoryMealTrackModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future proceedTransitionDayProgramList(
      ProceedProgramDayModel model, List<PlatformFile> files, List<PlatformFile> mandatoryFile) async {
    var url = submitTransMealTrackingUrl;

    //tracking_attachment
    dynamic result;

    print("proceedTransitionDayProgramList path: $url");

    print(Map.from(model.toJson()));
    Map<String, String> m = Map.unmodifiable(model.toJson());

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      var headers = {
        // "Authorization": "Bearer ${AppConfig().bearerToken}",
        "Authorization": getHeaderToken(),
      };

      if (files != null) {
        files.forEach((element) async {
          request.files.add(await http.MultipartFile.fromBytes(
              'tracking_attachment', files.first.bytes as List<int>,
              filename: files.first.name));
        });
      }

      if (mandatoryFile != null) {
        mandatoryFile.forEach((element) async {
          request.files.add(await http.MultipartFile.fromBytes(
              'tongue_image', mandatoryFile.first.bytes as List<int>,
              filename: mandatoryFile.first.name));
        });
      }

      // if (files != null) {
      //   files.forEach((element) async {
      //     request.files.add(await http.MultipartFile.fromBytes(
      //         'tracking_attachment', element));
      //   });
      // }
      //
      // if (mandatoryFile != null) {
      //   mandatoryFile.forEach((element) async {
      //     request.files
      //         .add(await http.MultipartFile.fromBytes('tongue_image', element));
      //   });
      // }

      // request.files.addAll(files);
      // request.files.addAll(mandatoryFile);
      request.fields.addAll(m);

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });
      request.headers.addAll(headers);

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      print(
          'proceedTransitionDayProgramList Response status: ${response.statusCode}');
      print('proceedTransitionDayProgramList Response body: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('proceedTransitionDayProgramList result: $json');
        if (json['status'].toString() == "200") {
          result = GetProceedModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print(
            'proceedTransitionDayProgramList error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getSlotsDaysForScheduleApi() async {
    final path = getUserSlotDaysForScheduleUrl;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    var result;

    Map<String, String> header = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: header,
      )
          .timeout(const Duration(seconds: 45));

      print("getSlotsDaysForScheduleApi response path:" + path);

      print("getSlotsDaysForScheduleApi response code:" +
          response.statusCode.toString());
      print("getSlotsDaysForScheduleApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'] == 200) {
        result = GetUserSlotDaysForScheduleModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
        print("res: $result");
      }
    } catch (e) {
      print("catch error $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getFollowUpSlotsApi(String selectedDate,
      {String? appointmentId}) async {
    final path = getFollowUpSlotUrl + selectedDate;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    var result;

    // Map<String, dynamic> param = {'appointment_id': appointmentId};
    Map<String, String> header = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: header,
      )
          .timeout(const Duration(seconds: 45));

      print("getFollowUpSlotsApi response path:" + path);

      print("getFollowUpSlotsApi response code:" +
          response.statusCode.toString());
      print("getFollowUpSlotsApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'] == 200) {
        result = SlotModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future submitSlotSelectedApi(
      String selectedDate, String start, String endTime) async {
    final path = submitSlotSelectedUrl;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    var result;

    Map m = {
      'date': selectedDate,
      'slot_start_time': start,
      'slot_end_time': endTime
    };

    print("map: $m");

    // Map<String, dynamic> param = {'appointment_id': appointmentId};
    Map<String, String> header = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .post(Uri.parse(path), headers: header, body: Map.from(m))
          .timeout(const Duration(seconds: 45));

      print("submitSlotSelectedApi response path:" + path);

      print("submitSlotSelectedApi response code:" +
          response.statusCode.toString());
      print("submitSlotSelectedApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'] == 200) {
        result = SuccessMessageModel.fromJson(res);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getHomeRemediesApi() async {
    final String path = homeRemediesUrl;

    print('serverGetProblemList Response header: $path');
    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('serverGetProblemList Response header: $path');
      print('serverGetProblemList Response status: ${response.statusCode}');
      print('serverGetProblemList Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverGetProblemList result: $json');

      if (response.statusCode != 200) {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        if (json['status'] != 200) {
          result = ErrorModel.fromJson(json);
        } else {
          result = HomeRemediesModel.fromJson(json);
        }
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future submitMedicalFeedbackForm({
    required String resolvedDigestiveIssue,
    required String unresolvedDigestiveIssue,
    required String mealPreferences,
    required String hungerPattern,
    required String bowelPattern,
    required String lifestyleHabits,
  }) async {
    final String path = submitMedicalFeedbackFormUrl;

    Map bodyParam = {
      'resolved_digestive_issue': resolvedDigestiveIssue,
      'unresolved_digestive_issue': unresolvedDigestiveIssue,
      'meal_preferences': mealPreferences,
      'hunger_pattern': hungerPattern,
      'bowel_pattern': bowelPattern,
      'lifestyle_habits': lifestyleHabits,
    };

    print("Medical Form Details : $bodyParam");
    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(path),
        body: bodyParam,
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('submitMedicalFeedbackForm Response header: $path');
      print(
          'submitMedicalFeedbackForm Response status: ${response.statusCode}');
      print('submitMedicalFeedbackForm Response body: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('submitMedicalFeedbackForm result: $json');
        if (json['status'].toString() == '201') {
          result = RegisterResponse.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      }
    } catch (e) {
      print("catch error: $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future sumbitProgramFeedbackForm({
    required int programStatus,
    required String changesAfterProgram,
    required String otherChangesAfterProgram,
    required String didProgramHeal,
    required String stickToPlan,
    required String mealPlanEasyToFollow,
    required String yogaPlanEasyToFollow,
    required String commentsOnMealYogaPlans,
    required String programPositiveHighlights,
    required String programNegativeHighlights,
    required String infusions,
    required String soups,
    required String porridges,
    required String podi,
    required String kheer,
    required String kitItemsImproveSuggestions,
    required String supportFromDoctors,
    required String supportInWhatsappGroup,
    required String homeRemediesDuringProgram,
    required String improvementAndSuggestions,
    required String programImproveHealthAnotherWay,
    required String briefTestimonial,
    required String referProgram,
    required String membership,
    required List<PlatformFile> faceToFeedback,
    required String reasonOfProgramDiscontinue,
  }) async {
    final String path = submitProgramFeedbackFormUrl;

    Map bodyParam = {
      'program_status': programStatus.toString(),
      // 'face_to_feedback': faceToFeedback,
      'changes_after_program': changesAfterProgram,
      'other_changes_after_program': otherChangesAfterProgram,
      'did_program_heal': didProgramHeal,
      'stick_to_plan': stickToPlan,
      'meal_plan_easy_to_follow': mealPlanEasyToFollow,
      'yoga_plan_easy_to_follow': yogaPlanEasyToFollow,
      'comments_on_meal_yoga_plans': commentsOnMealYogaPlans,
      'program_positive_heighlights': programPositiveHighlights,
      'program_negative_heighlights': programNegativeHighlights,
      'infusions': infusions,
      'soups': soups,
      'porridges': porridges,
      'podi': podi,
      'kheer': kheer,
      'kit_items_improve_suggestions': kitItemsImproveSuggestions,
      'support_from_doctors': supportFromDoctors,
      'support_in_whatsapp_group': supportInWhatsappGroup,
      'home_remedies_during_program': homeRemediesDuringProgram,
      'improvement_and_suggestions': improvementAndSuggestions,
      'program_improve_health_anotherway': programImproveHealthAnotherWay,
      'brief_testimonial': briefTestimonial,
      'refer_program': referProgram,
      'membership': membership,
      'reason_of_program_discontinue': reasonOfProgramDiscontinue,
    };

    print("Program Form Details : $bodyParam");
    dynamic result;
    print("Face To FaceBook : $faceToFeedback");

    print(bodyParam);
    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));

      request.headers.addAll(headers);
      request.fields.addAll(Map.from(bodyParam));

      if (faceToFeedback != null) {
        faceToFeedback.forEach((element) async {
          request.files.add(await http.MultipartFile.fromBytes(
              'face_to_feedback', faceToFeedback.first.bytes as List<int>,
              filename: faceToFeedback.first.name));
        });
      }

      // if (faceToFeedback != null) {
      //   faceToFeedback.forEach((element) async {
      //     request.files.add(
      //         await http.MultipartFile.fromBytes('face_to_feedback', element));
      //   });
      // }

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      print('submitProgramFeedbackForm Response header: $path');
      print(
          'submitProgramFeedbackForm Response status: ${response.statusCode}');
      print('submitProgramFeedbackForm Response body: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        result = RegisterResponse.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('submitProgramFeedbackForm result: $json');
        if (json['status'].toString() == '200') {
          result = RegisterResponse.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      }
    } catch (e) {
      print("catch error: $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future submitGutDiagnosisApi(Map formDetails) async {
    final String path = submitGutDiagnosisFormUrl;

    Map bodyParam = formDetails;

    print("Medical Form Details : $bodyParam");
    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(path),
        body: bodyParam,
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('submitGutDiagnosisApi Response header: $path');
      print('submitGutDiagnosisApi Response status: ${response.statusCode}');
      print('submitGutDiagnosisApi Response body: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        print('submitGutDiagnosisApi result: $json');
        if (json['status'].toString() == '201') {
          result = RegisterResponse.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      }
    } catch (e) {
      print("catch error: $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getDiagnosisDetailsApi() async {
    final String path = getGutDiagnosisUrl;

    dynamic result;
    print(inMemoryStorage.cache.containsKey(path));

    // if(inMemoryStorage.cache.containsKey(path)){
    //   print("from cache");
    //   return result = MedicalFeedbackModel.fromJson(inMemoryStorage.get(path));
    // }

    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: headers,
      )
          .timeout(const Duration(seconds: 45));

      print('getDiagnosisDetailsApi Response header: $path');
      print('getDiagnosisDetailsApi Response status: ${response.statusCode}');
      print('getDiagnosisDetailsApi Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('getDiagnosisDetailsApi result: $json');

      if (response.statusCode == 200) {
        if (json['status'].toString() != '200') {
          result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
        } else {
          // inMemoryStorage.set(path, json);
          result = MedicalFeedbackModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(),
            message: AppConfig.oopsMessage);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
    }
    return result;
  }

  Future downloadFile(String url, String filename, String path) async {
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      //(await getApplicationDocumentsDirectory()).path;
      File file = File('${path}/$filename');
      await file.writeAsBytes(bytes);
      print('downloaded file path = ${file.path}');
      return file;
    } catch (error) {
      print('pdf downloading error = $error');
      return error;
    }
  }

  submitIsMrReadApi() async {
    String path = mrReadUrl;

    dynamic result;

    try {
      final response = await http.get(
        Uri.parse(path),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      if (response.statusCode != 200) {
        final json = jsonDecode(response.body);
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetMedicalFeedbackDetails() async {
    final String path = getMedicalFeedbackDataUrl;

    dynamic result;
    print(inMemoryStorage.cache.containsKey(path));

    // if(inMemoryStorage.cache.containsKey(path)){
    //   print("from cache");
    //   return result = MedicalFeedbackModel.fromJson(inMemoryStorage.get(path));
    // }

    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: headers,
      )
          .timeout(const Duration(seconds: 45));

      print('serverMedicalFeedbackDetails Response header: $path');
      print(
          'serverMedicalFeedbackDetails Response status: ${response.statusCode}');
      print('serverMedicalFeedbackDetails Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverMedicalFeedbackDetails result: $json');

      if (response.statusCode == 200) {
        if (json['status'].toString() != '200') {
          result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
        } else {
          // inMemoryStorage.set(path, json);
          result = MedicalFeedbackModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(),
            message: AppConfig.oopsMessage);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
    }
    return result;
  }

  Future getCombinedMealApi() async {
    final path = getCombinedMealUrl;
    var result;

    // try {
    final response = await httpClient.get(
      Uri.parse(path),
      headers: {
        // "Authorization": "Bearer ${AppConfig().bearerToken}",
        "Authorization": getHeaderToken(),
      },
    ).timeout(const Duration(seconds: 45));

    print("getCombinedMealApi response url:" + path);
    print("getCombinedMealApi response code:" + response.statusCode.toString());
    print("getCombinedMealApi response body:" + response.body);

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      print(res['Detox']);

      if (res['status'].toString() == '200') {
        // result = CombinedMealModel.fromJson(mealJson);

        result = CombinedMealModel.fromJson(jsonDecode(response.body));
      } else {
        result = ErrorModel.fromJson(res);
      }
    } else if (response.statusCode == 500) {
      result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
    } else {
      print('status not equal called');
      final res = jsonDecode(response.body);
      result = ErrorModel.fromJson(res);
    }
    // } catch (e) {
    //   print("catch error::> $e");
    //   result = ErrorModel(status: "0", message: e.toString());
    // }
    return result;
  }

  getBmiBmrApi() async {
    String url = getBmiBmrUrl;
    print(url);

    dynamic result;
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 45));

      print('getBmiBmrApi Url: $url');
      print('getBmiBmrApi Response status: ${response.statusCode}');
      print('getBmiBmrApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'].toString() == '200') {
          result = BmiBmrModel.fromJson(jsonDecode(response.body));
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  submitBmiBmrApi(String bmi, String bmr) async {
    dynamic result;

    Map bodyParam = {
      'BMI': bmi,
      'BMR': bmr,
    };

    print("submitBmiBmrApi body : $bodyParam ");

    try {
      final response = await httpClient.post(
        Uri.parse(submitBmiBmrUrl),
        headers: {
          'Authorization': getHeaderToken(),
        },
        body: bodyParam,
      );
      print("submitBmiBmrApi status code: ${response.statusCode}");
      print("submitBmiBmrApi body : ${response.body}");

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status'].toString() == '200') {
          print('result: $response');
          result = SuccessMessageModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getRemainderApi() async {
    String url = getRemainderUrl;
    print(url);

    dynamic result;
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 45));

      print('getRemainderApi Url: $url');
      print('getRemainderApi Response status: ${response.statusCode}');
      print('getRemainderApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'].toString() == '200') {
          result = GetRemainderModel.fromJson(jsonDecode(response.body));
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  submitRemainderApi(String waterTiming) async {
    dynamic result;

    Map bodyParam = {
      'water_timings': waterTiming,
    };

    print("submitRemainderApi body : $bodyParam ");

    try {
      final response = await httpClient.post(
        Uri.parse(submitRemainderUrl),
        headers: {
          'Authorization': getHeaderToken(),
        },
        body: bodyParam,
      );
      print("submitRemainderApi status code: ${response.statusCode}");
      print("submitRemainderApi body : ${response.body}");

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status'].toString() == '200') {
          print('result: $response');
          result = SuccessMessageModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  getGraphListApi() async {
    String url = getGraphUrl;
    print(url);

    dynamic result;
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 45));

      print('getGraphListApi Url: $url');
      print('getGraphListApi Response status: ${response.statusCode}');
      print('getGraphListApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'].toString() == '200') {
          result = GraphListModel.fromJson(jsonDecode(response.body));
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  submitGutHealthTrackerApi(Map trackerDetails) async {
    dynamic result;

    try {
      final response =
      await httpClient.post(Uri.parse(submitGutHealthTrackerUrl),
          headers: {
            'Authorization': getHeaderToken(),
          },
          body: trackerDetails);
      print("submitGutHealthTrackerApi status code: ${response.statusCode}");
      print("submitGutHealthTrackerApi body : ${response.body}");

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status'].toString() == '200') {
          print('result: $response');
          result = SuccessMessageModel.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  //1- open
  //2- pending
  //3- answered
  //4- resolved
  //5- closed
  getTicketListApi(String email, int index) async {
    String url = uvDesk_baseUrl +
        ticketListApiPath +
        '?actAsType=customer&actAsEmail=$email&status=$index';
    print(url);

    Map queryParam = {"actAsType": "customer", "actAsEmail": email};

    print("agentToken : $agentToken");
    print(_prefs!.getString(AppConfig.UV_API_ACCESS_TOKEN));
    print("uvSuccesId : ${_prefs?.getString(AppConfig.UV_SUCCESS_ID)}");

    dynamic result;
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": agentToken,
        },
      ).timeout(Duration(seconds: 45));

      print('getTicketListApi Url: $url');
      print('getTicketListApi Response status: ${response.statusCode}');
      print('getTicketListApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        result = GetTicketListModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  /// id -> ticketId
  getTicketDetailsApi(String id) async {
    String url = uvDesk_baseUrl + '${ticketDetailsPath + id}';
    print(url);

    dynamic result;
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": agentToken,
        },
      ).timeout(Duration(seconds: 45));

      print("agentToken : $agentToken");

      print('getTicketDetailsApi Url: $url');
      print('getTicketDetailsApi Response status: ${response.statusCode}');
      print('getTicketDetailsApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        result = NewTicketDetailsModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  /// params needed
  /*
Parameter	    Type	  Required	    Description
type	       integer	true	        1|2|3|4|5|6 for open|pending|resolved|closed|Spam|Answered repectively
name	        string	true	         ticket name
from	        string	true	        email address
reply	        string	true	        reply content
subject     	string	true	        ticket subject
customFields	array	  false	        custom fields (if present) could be provided
actAsType	    string	false       	admin can actAsType customer, agent
actAsEmail	  string	false        	provide when acting as agent
attachments[]   files   false
   */
  createTicketApi(Map data, {List<File>? attachments}) async {
    String url = uvDesk_baseUrl + '$createTicketPath';
    print(url);

    dynamic result;
    var headers = {
      // "Authorization": adminToken,
      "Authorization": agentToken,
    };

    print("Details : $data");
    print("agentToken : $agentToken");

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headers);
      request.fields.addAll(Map.from(data));
      request.persistentConnection = false;

      if (attachments != null) {
        for (int i = 0; i < attachments.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'attachments[$i]', attachments[i].path));
        }
      }

      // print("attachment .length: ${attachments!.length}");

      print("request.files.length: ${request.files.length}");

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print('createTicketApi Url: $url');
      print('createTicketApi Response status: ${response.statusCode}');
      print('createTicketApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        result = TicketdetailsModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  /// it will give
  getTicketListByCustomerIdApi(String customerId, String statusId) async {
    String url = uvDesk_baseUrl +
        ticketListByCustomerId +
        customerId +
        "&status=$statusId";
    print(url);

    dynamic result;
    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": agentToken,
        },
      ).timeout(Duration(seconds: 45));

      print('getTicketListByCustomerIdApi Url: $url');
      print(
          'getTicketListByCustomerIdApi Response status: ${response.statusCode}');
      print('getTicketListByCustomerIdApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        result = GetTicketListModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print("error: ${e.toString()}");
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  sendReplyApi(String ticketId, Map data, {List<PlatformFile>? attachments}) async {
    String url = uvDesk_baseUrl + getTicketReplyPath(ticketId);
    print(url);
    print(data);

    dynamic result;
    var headers = {
      // "Authorization": adminToken,
      "Authorization": agentToken,
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headers);
      request.fields.addAll(Map.from(data));
      request.persistentConnection = false;

      if (attachments != null) {
        for (int i = 0; i < attachments.length; i++) {
          request.files.add(await http.MultipartFile.fromBytes(
              'attachments[$i]', attachments[i].bytes as List<int>,filename: attachments.first.name));
        }
        print("attachment .length: ${attachments.length}");
      }
      ;

      print("request.files.length: ${request.files.length}");

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print('reply Url: $url');
      print('reply Response status: ${response.statusCode}');
      print('reply Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        result = TicketdetailsModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  /// api/ticket/{ticket id}.json
  reOpenTicketApi(String ticketId) async {
    String url = uvDesk_baseUrl + ticketReplyPath + ticketId;
    print(url);

    Map body = {"property": "status", "value": "1"};

    dynamic result;
    try {
      final response = await httpClient
          .patch(Uri.parse(url),
          headers: {
            // "Authorization": adminToken,
            "Authorization": agentToken,
          },
          body: Map.from(body))
          .timeout(Duration(seconds: 45));

      print('reOpenTicketApi Url: $url');
      print('reOpenTicketApi Response status: ${response.statusCode}');
      print('reOpenTicketApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        result = GetTicketListModel.fromJson(json);
      } else if (response.statusCode == 500) {
        result = ErrorModel(status: "0", message: AppConfig.oopsMessage);
      } else {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print("error: ${e.toString()}");
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  void storeShipRocketToken(ShipRocketTokenModel result) {
    _prefs!.setString(AppConfig().shipRocketBearer, result.token ?? '');
  }
}
