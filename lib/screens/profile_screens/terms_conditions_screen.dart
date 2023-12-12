/*
  Api used:
  var termsConditionUrl = "${AppConfig().BASE_URL}/api/list/terms_and_conditions";

 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/profile_model/terms_condition_model.dart';
import '../../repository/api_service.dart';
import '../../repository/profile_repository/settings_repo.dart';
import '../../services/profile_screen_service/settings_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                SizedBox(height: 3.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Terms & Conditions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: kFontBold,
                            color: gBlackColor,
                            fontSize: 12.sp
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      FutureBuilder(
                          future: SettingsService(repository: repository).getData(),
                          builder: (_, snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              if(snapshot.hasData){
                                TermsConditionModel model = snapshot.data as TermsConditionModel;
                                return Text(model.data ?? '',
                                  style: TextStyle(
                                    height: 1.8,
                                    fontSize: 10.sp,
                                    color: gTextColor,
                                    fontFamily: "GothamBook",
                                  ),
                                );
                              }
                              else if(snapshot.hasError){
                                if (kDebugMode) {
                                  print("snapshot.error:${snapshot.error}");
                                }
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {});
                                  },
                                  child: SizedBox(
                                    height: 100.h,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.cloud_off),
                                        Text('Network Error, Please Retry!')
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.2,
                              child: buildCircularIndicator(),
                            );
                          }
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final SettingsRepository repository = SettingsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
