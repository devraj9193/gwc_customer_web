import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../model/error_model.dart';
import '../../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import '../../../model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import '../evaluation_form_page1.dart';
import '../evaluation_form_page2.dart';
import '../evaluation_form_screen.dart';
import '../evaluation_upload_report.dart';

class EvalModels {
  final int id;
  final String title;
  int? isCompleted;
  int? presentDetails;

  EvalModels({
    required this.id,
    required this.title,
    this.isCompleted,
    this.presentDetails,
  });
}

class WebEvalScreen extends StatefulWidget {
  const WebEvalScreen({Key? key}) : super(key: key);

  @override
  State<WebEvalScreen> createState() => _WebEvalScreenState();
}

class _WebEvalScreenState extends State<WebEvalScreen> {
  final SharedPreferences pref = AppConfig().preferences!;

  int? selectedDetails;

  List<EvalModels> details = [
    EvalModels(
      id: 1,
      title: "Personal & Health",
      isCompleted: 0,
      presentDetails: 0,
    ),
    EvalModels(
      id: 2,
      title: "Food & Lifestyle",
      isCompleted: 0,
      presentDetails: 0,
    ),
    EvalModels(
      id: 3,
      title: "Reports",
      isCompleted: 0,
      presentDetails: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    getEvalData();
  }

  ChildGetEvaluationDataModel? childGetEvaluationDataModel;
  bool isLoading = false;

  getEvalData() async {
    setState(() {
      isLoading = true;
    });
    final result = await EvaluationFormService(repository: evalRepository)
        .getEvaluationDataService();
    print("result: $result");

    if (result.runtimeType == GetEvaluationDataModel) {
      print("Ticket List");
      GetEvaluationDataModel model = result as GetEvaluationDataModel;
      setState(() {
        childGetEvaluationDataModel = model.data;

        // print(
        //     "Stage : ${childGetEvaluationDataModel!.anyTherapiesHaveDoneBefore!.isEmpty}");
        print("Stage : ${childGetEvaluationDataModel!.bowelPattern}");
        // print("Stage : ${childGetEvaluationDataModel!.medicalReport!.isEmpty}");

        if (childGetEvaluationDataModel!.anyTherapiesHaveDoneBefore!.isEmpty) {
          selectedDetails = 1;
        } else if (childGetEvaluationDataModel!.bowelPattern == null) {
          selectedDetails = 2;
          details[0].isCompleted = 1;
        } else if (childGetEvaluationDataModel!.medicalReport!.isEmpty) {
          selectedDetails = 3;
          details[0].isCompleted = 1;
          details[1].isCompleted = 1;
        } else {
          selectedDetails = 1;
          details[0].isCompleted = 1;
          details[1].isCompleted = 1;
          details[2].isCompleted = 1;
        }
      });
      //   if (childGetEvaluationDataModel!.bowelPattern!.isEmpty) {
      //     selectedDetails = 2;
      //     details[1].presentDetails = 1;
      //   } else {
      //     selectedDetails = 3;
      //     details[1].isCompleted = 1;
      //     details[1].presentDetails = 0;
      //   }
      //
      //   print("Details : ${childGetEvaluationDataModel!.medicalReport}");
      //   if (childGetEvaluationDataModel!.medicalReport!.isEmpty) {
      //     selectedDetails = 3;
      //     details[2].presentDetails = 1;
      //   } else {
      //     selectedDetails = 1;
      //     details[2].isCompleted = 1;
      //     details[2].presentDetails = 0;
      //   }
      // });

      print("Details : ${details[0].isCompleted}");
      print("Details : ${details[1].isCompleted}");
      print("Details : ${details[2].isCompleted}");
    } else {
      ErrorModel model = result as ErrorModel;
      setState(() {
        selectedDetails = 1;
        details[0].presentDetails = 1;
        print("error: ${model.message}");
      });
    }
    setState(() {
      isLoading = false;
    });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
      body: SafeArea(
        child: (isLoading)
            ? Center(
                child: buildCircularIndicator(),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 1.w),
                              child: buildAppBar(
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          const EvaluationFormScreen(),
                                    ),
                                  );
                                },
                                showLogo: false,
                                showChild: true,
                                child: Text(
                                  "Evaluation Form",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: kFontBold,
                                    color: gBlackColor,
                                    fontSize: 16.dp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            ListView.builder(
                              itemCount: details.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool isSelected =
                                    selectedDetails == details[index].id;

                                bool currentPage =
                                    details[index].presentDetails == 1;

                                bool completedPage =
                                    details[index].isCompleted == 1;

                                return GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   selectedDetails = details[index].id;
                                    // });
                                  },
                                  child: Center(
                                    child: Container(
                                      width: 15.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.w, vertical: 1.5.h),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 0.w),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? gsecondaryColor
                                            : completedPage
                                                ? gPrimaryColor
                                                : gWhiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          details[index].title,
                                          style: TextStyle(
                                            color: isSelected
                                                ? gWhiteColor
                                                : completedPage
                                                    ? gWhiteColor
                                                    : gBlackColor,
                                            fontFamily: isSelected
                                                ? kFontMedium
                                                : completedPage
                                                    ? kFontMedium
                                                    : kFontBook,
                                            fontSize: 14.dp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: double.maxFinite,
                      margin:
                          EdgeInsets.only(top: 2.h, bottom: 2.h, right: 2.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: selectedDetails == 1
                          ? EvaluationFormPage1(
                              isWeb: true,
                              padding: EdgeInsets.symmetric(
                                vertical: 1.5.h,
                                horizontal: 1.5.w,
                              ),
                            )
                          : selectedDetails == 2
                              ? EvaluationFormPage2(
                                  isWeb: true,
                                  childGetEvaluationDataModel:
                                      childGetEvaluationDataModel,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.5.h,
                                    horizontal: 1.5.w,
                                  ),
                                )
                              : selectedDetails == 3
                                  ? EvaluationUploadReport(
                                      isWeb: true,
                                      childGetEvaluationDataModel:
                                          childGetEvaluationDataModel,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1.5.h,
                                        horizontal: 1.5.w,
                                      ),
                                    )
                                  : const SizedBox(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  final EvaluationFormRepository evalRepository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
