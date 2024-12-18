import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import '../../../model/chief_qa_model/get_chief_qa_list_model.dart';
import '../../../model/chief_qa_model/send_qa_model.dart';
import '../../../model/combined_meal_model/meal_plan_tracker_modl/send_meal_plan_tracker_model.dart';
import '../../../model/error_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/chief_question_repo/chief_question_repo.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class ChiefQuestionPage extends StatefulWidget {
  final String? phases;
  final SubmitMealPlanTrackerModel? proceedProgramDayModel;
  final PageController controller;
  const ChiefQuestionPage({
    Key? key,
    this.phases,
    this.proceedProgramDayModel,
    required this.controller,
  }) : super(key: key);

  @override
  State<ChiefQuestionPage> createState() => _ChiefQuestionPageState();
}

class _ChiefQuestionPageState extends State<ChiefQuestionPage> {
  @override
  void initState() {
    super.initState();
    getQAList();
  }

  bool isLoading = false;
  List<String> chiefQAList = [];

  getQAList() async {
    setState(() {
      isLoading = true;
    });
    final result = await repository.getChiefQuestionListRepo();
    print("result: $result");

    if (result.runtimeType == GetChiefQaListModel) {
      print("Ticket List");
      GetChiefQaListModel model = result as GetChiefQaListModel;

      chiefQAList = model.data ?? [];
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    print(result);
  }

  List<String> options = [
    // "No Improvement","Completely Resolved",
    // "Intensity/Occurrence Reduced",
    "Below 50%",
    "50%-60%",
    "60%-70%",
    "70%-80%",
    "Above 80%",
    // "Below 50%",
    //   "50% - 60%",
    //   "60% - 70%",
    //   "70% - 80%",
    //   "80% - 90%",
    //   "90% - 100%",
  ];

  Map<String, String?> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Center(
            child: buildCircularIndicator(),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Below 50% --- No Improvement, Above 80% --- Resolved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.dp,
                      fontFamily: kFontBook,
                      color: gsecondaryColor,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'To what extend did the Gut Issues heal Today?',
                    style: TextStyle(
                      fontSize: 15.dp,
                      fontFamily: kFontBold,
                      color: eUser().mainHeadingColor,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chiefQAList.length,
                    itemBuilder: (_, index) {
                      var title = chiefQAList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.h),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.dp,
                              fontFamily: kFontMedium,
                              color: eUser().mainHeadingColor,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.w),
                            child: Wrap(
                              children: options.map((option) {
                                bool isSelected =
                                    selectedOptions[title] == option;
                                return GestureDetector(
                                  onTap: () {
                                    _selectOption(title, option);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.2.h, horizontal: 1.5.w),
                                    margin: EdgeInsets.only(
                                        left: 1.w,
                                        right: 1.w,
                                        top: 1.h,
                                        bottom: 1.h),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? gsecondaryColor // Selected color
                                          : gWhiteColor, // Default color
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 2,
                                          spreadRadius: 0.5,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 13.dp,
                                        fontFamily: kFontBook,
                                        color: isSelected
                                            ? gWhiteColor
                                            : gBlackColor,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              // alignment: WrapAlignment.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Center(
                      child: ButtonWidget(
                        text: 'Submit',
                        onPressed: submitLoading
                            ? () {}
                            : () {
                                print("Data : $data");
                                sendDataToApi();
                              },
                        isLoading: submitLoading,
                        radius: 10,
                        buttonWidth: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Map<String, dynamic> data = {};

  void _selectOption(String item, String option) {
    setState(() {
      selectedOptions[item] = option;
      data['QA[$item]'] = option; // Add or update in the map
    });
  }

  bool _validateSelections() {
    for (String item in chiefQAList) {
      if (selectedOptions[item] == null) {
        return false; // Return false if any item has no selected option
      }
    }
    return true; // All items have selections
  }

  bool submitLoading = false;

  Future<void> sendDataToApi() async {
    if (_validateSelections()) {
      setState(() {
        submitLoading = true;
      });

      data['day'] = widget.proceedProgramDayModel?.day;
      data['phase'] = widget.phases;

      final res = await repository.submitChiefQuestionAnswerRepo(data);

      print("medicalFeedbackForm:$res");
      print("res.runtimeType: ${res.runtimeType}");

      if (res.runtimeType == SendChiefQaModel) {
        SendChiefQaModel response = res;
        print("response : $response");
        widget.controller
            .nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .then((value) {});
      } else {
        String result = (res as ErrorModel).message ?? '';
        AppConfig().showSnackbar(context, result, isError: true, duration: 4);
      }
      setState(() {
        submitLoading = false;
      });
    } else {
      AppConfig().showSnackbar(context, 'Please select an option for all items',
          isError: true, duration: 4);
    }
  }

  final ChiefQuestionRepo repository = ChiefQuestionRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
