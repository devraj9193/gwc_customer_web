import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import '../../../model/profile_model/terms_condition_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/profile_repository/settings_repo.dart';
import '../../../services/profile_screen_service/settings_service.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class WebTerms extends StatefulWidget {
  const WebTerms({Key? key}) : super(key: key);

  @override
  State<WebTerms> createState() => _WebTermsState();
}

class _WebTermsState extends State<WebTerms> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                Text(
                  "Terms & Conditions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: kFontBold,
                      color: gBlackColor,
                      fontSize: 15.dp),
                ),
                SizedBox(
                  height: 2.h
                ),
                FutureBuilder(
                    future:
                        SettingsService(repository: repository).getData(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasData) {
                          TermsConditionModel model =
                              snapshot.data as TermsConditionModel;
                          return Text(
                            model.data ?? '',
                            style: TextStyle(
                              height: 2,
                              fontSize: 13.dp,
                              color: gBlackColor,
                              fontFamily: "GothamBook",
                            ),
                          );
                        } else if (snapshot.hasError) {
                          if (kDebugMode) {
                            print("snapshot.error:${snapshot.error}");
                          }
                          return GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: SizedBox(
                              height: 100.h,
                              width: double.infinity,
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
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
                    })
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
