/*
here we r showing both submit and get tracket

Api used:
var getPrepratoryMealTrackUrl = "${AppConfig().BASE_URL}/api/getDataList/tracking_prep_meal";

we r hitting this api
if there is a success response than we r hiding submit button by using param showDetails

and adding all the details to raio button

if there is no data than user needs to submit the tracker by using api

var submitPrepratoryMealTrackUrl = "${AppConfig().BASE_URL}/api/submitForm/prep_meal_submit";

 */

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/prepratory_repository/prep_repository.dart';
import 'package:gwc_customer_web/screens/dashboard_screen.dart';
import 'package:gwc_customer_web/services/prepratory_service/prepratory_service.dart';
import 'package:gwc_customer_web/utils/app_config.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../model/prepratory_meal_model/get_prep_meal_track_model.dart';
import '../../../model/success_message_model.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class PrepratoryMealCompletedScreen extends StatefulWidget {
  const PrepratoryMealCompletedScreen({Key? key}) : super(key: key);

  @override
  State<PrepratoryMealCompletedScreen> createState() => _PrepratoryMealCompletedScreenState();
}

class _PrepratoryMealCompletedScreenState extends State<PrepratoryMealCompletedScreen> {

  List<QuestionsView> questions = [
    QuestionsView("Has your hunger improved?", -1, 'hunger_improved'),
    QuestionsView("Has your appetite improved?", -1, 'appetite_improved'),
    QuestionsView("Are you feeling light?", -1, 'feeling_light'),
    QuestionsView("Are you feeling energetic? ", -1, 'feeling_energetic'),
    QuestionsView("Are you feeling a mild reduction in your primary symptoms?", -1, 'mild_reduction')
  ];

  bool showProgress = false;

  bool showDetails = false;

  bool showCenterLoading = true;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrepratoryMealTrackDetails();
  }
  getPrepratoryMealTrackDetails() async{

    final res = await PrepratoryMealService(repository: repository).getPrepratoryMealTrackDetailsService();

    if(res.runtimeType == ErrorModel){
      ErrorModel err = res as ErrorModel;
      print("error: ${err.message}");
    }
    else{
      final result = res as GetPreparatoryMealTrackModel;

      if(result.trackingPrepMeals != null){
        showDetails = true;
        questions.forEach((element) {
          final json = result.trackingPrepMeals!.toJson();
          json.forEach((key, value) {
            if(key == element.sendKey){
              element.selected = (value == "Yes") ? 0 : 1;
            }
          });
        });
        setState(() {

        });
      }
    }
    setState(() {
      showCenterLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: (showCenterLoading) ? Center(child: buildCircularIndicator(),) : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              buildAppBar((){
                Navigator.pop(context);
              }),
              Center(child: SizedBox(
                width: 50.w,
                height: 50.w,
                child: Image.asset("assets/images/prep_meal_completed.png",
                  fit: BoxFit.scaleDown,
                ),
              )),
              SizedBox(
                height: 2.h,
              ),
              Center(
                child: Text("You Have Successfully Completed \n The Preparatory Meal Plan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontFamily: kFontMedium,
                    fontSize: 12.sp,
                    color: gPrimaryColor
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: questions.length,
                  itemBuilder: (_, index){
                    return radioView(questions[index], index);
                  },
              ),
              SizedBox(
                height: 5.h,
              ),
              Visibility(
                visible: !showDetails,
                child: GestureDetector(
                  onTap: (){
                    if(questions.any((element) => element.selected == -1)){
                      AppConfig().showSnackbar(context, "Please Fill all questions", isError: true);
                    }
                    else{
                      submitPrepratoryMealTrackDetails();
                    }
                  },
                  child: Center(
                    child: Container(
                      width: 40.w,
                      height: 4.5.h,
                      // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: eUser().buttonColor,
                        borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                        // border: Border.all(color: eUser().buttonBorderColor,
                        //     width: eUser().buttonBorderWidth),
                      ),
                      child: (showProgress)
                          ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                          : Center(
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontFamily:
                            kFontBold,
                            color: gWhiteColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  radioView(QuestionsView view, int index){
    return IgnorePointer(
      ignoring: showDetails,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(view.question,
              style: TextStyle(
                  fontFamily: kFontMedium,
                  fontSize: 11.sp,
                  color: gBlackColor
              ),
            ),
            Row(
              children: [
                radioBtnView(view.selected, "Yes", index),
                SizedBox( width: 25,),
                radioBtnView(view.selected, "No", index)
              ],
            ),
            Container(
              height: 5,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.7),
                    width: 1.0,
                  ),
                ),
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Colors.grey.withOpacity(0.3),
                //     Colors.grey.withOpacity(0.3),
                //   ],
                // ),
              ),
            )
          ],
        ),
      ),
    );
  }

  radioBtnView(int selected, String btnName, index){
    return GestureDetector(
      onTap: (){
        if(btnName == "Yes"){
          setState(() {
            questions[index].selected = 0;
          });
          print("selected: $selected");
        }
        else{
          setState(() {
            questions[index].selected = 1;
          });
          print(selected);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 25,
            child: Radio(
              value: (btnName == "Yes") ? 0 : 1,
              groupValue: selected,
              onChanged: (value){
                print("value: $value");
                setState(() {
                  questions[index].selected = value as int;
                });
              },
              activeColor: gsecondaryColor,
            ),
          ),
          SizedBox( width: 10,),
          Text(btnName,
            style: TextStyle(
                fontFamily: kFontMedium,
                fontSize: 10.sp,
                color: (questions[index].selected == 1 && btnName == "No" ||
                    questions[index].selected == 0 && btnName == "Yes" ) ? gsecondaryColor : gBlackColor,
            ),
          )
        ],
      ),
    );
  }

  final PrepratoryRepository repository = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  submitPrepratoryMealTrackDetails() async{
    setState(() {
      showProgress = true;
    });
    Map sendDetailsMap = {};
    questions.forEach((element) {
      sendDetailsMap.putIfAbsent(element.sendKey, () => element.selected == 0 ? 'Yes' : 'No');
    });

    print(sendDetailsMap);
    final res = await PrepratoryMealService(repository: repository).sendPrepratoryMealTrackDetailsService(sendDetailsMap);

    if(res.runtimeType == ErrorModel){
      setState(() {
        showProgress = false;
      });
      final result = res as ErrorModel;
      print("Submit error: ${res.message}");
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    }
    else{
      setState(() {
        showProgress = false;
      });
      final result = res as SuccessMessageModel;
      // AppConfig().showSnackbar(context, result.errorMsg ?? '');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(index: 2,),
        ), (route)=> route.isFirst
      );
      print("submit success");
    }

  }


}

class QuestionsView{
  String question;
  int selected;
  String sendKey;

  QuestionsView(this.question, this.selected, this.sendKey);
}