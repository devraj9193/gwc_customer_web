import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/post_program_model/post_program_new_model/pp_get_model.dart';
import 'package:gwc_customer_web/model/post_program_model/protocol_guide_day_score.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/post_program_repo/post_program_repository.dart';
import 'package:gwc_customer_web/screens/post_program_screens/new_post_program/early_morning.dart';
import 'package:gwc_customer_web/services/post_program_service/post_program_service.dart';
import 'package:gwc_customer_web/utils/app_config.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class PPDailyTasksUI extends StatefulWidget {
  final String day;
  const PPDailyTasksUI({Key? key, required this.day}) : super(key: key);

  @override
  State<PPDailyTasksUI> createState() => _PPDailyTasksUIState();
}

class _PPDailyTasksUIState extends State<PPDailyTasksUI> {

  int selectedIndex = -1;
  List<StageTypes> stageMap = [
    StageTypes(stageImage: 'assets/images/gmg/early_morning.png', stageName: 'Early Morning', stageSubText: ''),
    StageTypes(stageImage: 'assets/images/gmg/breakfast.png', stageName: 'Breakfast', stageSubText: 'South Indian option chosen'),
    StageTypes(stageImage: 'assets/images/gmg/midDay.png', stageName: 'Mid Day', stageSubText: ''),
    StageTypes(stageImage: 'assets/images/gmg/lunch.png', stageName: 'Lunch', stageSubText: 'South Indian option chosen'),
    StageTypes(stageImage: 'assets/images/gmg/evening.png', stageName: 'Evening', stageSubText: ''),
    StageTypes(stageImage: 'assets/images/gmg/dinner.png', stageName: 'Dinner', stageSubText: 'South Indian option chosen'),
    StageTypes(stageImage: 'assets/images/gmg/postDinner.png', stageName: 'Post Dinner', stageSubText: ''),
  ];
  // // static values
  // List<RoutineTask> earlyMorning = [
  //   RoutineTask(title: 'Coriander Ginger Tea'),
  //   RoutineTask(title: 'Indian Tea'),
  //   RoutineTask(title: 'Malnad Kashaya'),
  //   RoutineTask(title: 'Tulasi Tea'),
  //   RoutineTask(title: 'Kattam chai'),
  //   RoutineTask(title: 'Green Tea'),
  // ];
  // List<RoutineTask> breakfast = [
  //   RoutineTask(title: 'Pesarattu'),
  //   RoutineTask(title: 'Idiyappam With Diluted Coconut Milk+Palm Candy Sugar'),
  //   RoutineTask(title: 'Rice Ambali'),
  //   RoutineTask(title: 'Steamed Idli With Moong Dal Sambar And Vegetable Peel Chutneys'),
  //   RoutineTask(title: 'Bottle gourd idli'),
  //   RoutineTask(title: 'Kadabus with chutneys of mint or coriander.'),
  // ];
  // List<RoutineTask> midDay = [
  //   RoutineTask(title: 'Gala apple juice OR whole fruit'),
  //   RoutineTask(title: 'Fruit Bowl'),
  //   RoutineTask(title: 'Bulb black grapes juice'),
  //   RoutineTask(title: 'Veg soup'),
  //   RoutineTask(title: 'Pomegranate juice'),
  //   RoutineTask(title: 'Pear fruit'),
  // ];
  // List<RoutineTask> lunch = [
  //   RoutineTask(title: 'South Indian Thali Including Soft Cooked Boiled Matta Rice + Buttermilk + Avial + Vegetable Rasam'),
  //   RoutineTask(title: 'South Indian Thali Including Soft Cooked White Rice + Buttermilk + Vegetable Poriyal(Limit The Coconut To 1 Tsp)+ Vegetable Rasam (Use Carrot Or Any Gourd Vegetable Instead Of Tomato)'),
  //   RoutineTask(title: 'South Indian Thali Including Soft Cooked White Rice + Curd(4 Tsp-Made From Cow Milk And Fresh) + Vegetable Poriyal(Limit The Coconut To 1 Tsp)+ Cooked Snake Gourd Pachadi '),
  // ];
  // List<RoutineTask> evening = [
  //   RoutineTask(title: 'Veg clear soup'),
  //   RoutineTask(title: 'Coriander Ginger Tea'),
  //   RoutineTask(title: 'Dry fruits smoothie'),
  //   RoutineTask(title: 'Senna tea'),
  //   RoutineTask(title: 'Avocado dry fruits smoothie'),
  //   RoutineTask(title: 'Apple avocado dry fruits smoothie'),
  // ];
  // List<RoutineTask> dinner = [
  //   RoutineTask(title: 'Idiyappam With Vegetable Stew(Prepared By Using Only 2-3 Tsp Of Coconut Milk)'),
  //   RoutineTask(title: 'Steamed Idli With Moong Dal Sambar And Vegetable Peel Chutneys.'),
  //   RoutineTask(title: 'Savoury Pongal'),
  //   RoutineTask(title: 'Neer Dosa With Diluted Coconut Milk+Palm Candy Sugar + Mint Chutney'),
  //   RoutineTask(title: 'Soft Cooked Rice + Avial'),
  // ];
  // List<RoutineTask> postDinner = [
  //   RoutineTask(title: 'Fruit bowl'),
  //   RoutineTask(title: 'Turmeric Latte'),
  //   RoutineTask(title: 'Castor oil Hot water'),
  //   RoutineTask(title: 'Castor oil hot milk'),
  //   RoutineTask(title: 'Diluted skimmed plain milk'),
  // ];

  List<RoutineTask> earlyMorning = [];
  List<RoutineTask> breakfast = [];
  List<RoutineTask> midDay = [];
  List<RoutineTask> lunch = [];
  List<RoutineTask> evening = [];
  List<RoutineTask> dinner = [];
  List<RoutineTask> postDinner = [];



  List stages = [0,1,2,3,4,5,6];
  int currentStage = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEarlyMorningApi(widget.day);
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
          child: Scaffold(
            backgroundColor: PPConstants().bgColor,
            body: showUIBasedOnStage(currentStage),
          )
      ),
    );
  }

  Future<bool> _onWillPop() async {
    var value;
    setState(() {
      if (currentStage != 0) {
        currentStage--;
      }
      // else if(currentStage == 0){
      //   AppConfig().showSnackbar(context, "Please Submit");
      //   value =
      // }
      else{
        value = Future.value(true);
      }
    });
    return value ?? Future.value(false);
  }

  dayWithImage(BuildContext context, String imageName, String stage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Day 1',
            style: TextStyle(
                fontFamily: PPConstants().kDayTextFont,
                fontSize: PPConstants().kDayTextFontSize,
                color: PPConstants().kDayText
            )
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Center(child: Image(
              // height: 20.h,
              width: 70.w,
              image: AssetImage(imageName),
              fit: BoxFit.fitHeight,
            )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Center(
            child: Column(
              children: [
                Text(stage,
                    style: TextStyle(
                        fontFamily: PPConstants().topViewHeadingFont,
                        fontSize: PPConstants().topViewHeadingFontSize,
                        color: PPConstants().topViewHeadingText
                    )
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Suggested for your Gut type',
                    style: TextStyle(
                        fontFamily: PPConstants().topViewSubFont,
                        fontSize: PPConstants().topViewSubFontSize,
                        color: PPConstants().topViewSubText
                    )
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  bottomSendView(BuildContext context, int stageIndex , List<RoutineTask> items) {
    return (isLoading) ? Center(child: buildCircularIndicator(),) :
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: (items.isNotEmpty) ?
      Column(
        children: [
          showBottomHeadingView(stageMap[stageIndex].stageName, stageMap[stageIndex].stageSubText, 'This meal should not skip'),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
                itemBuilder: (_, index){
                  // return listViewItems(stageIndex, index, items);
                  return programItemsList(stageIndex, index, items);
                }
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: (isSubmitted) ? null : () {
                print(stages.length);
                switch(stageIndex){
                  case 0:
                    if(!stageMap[stageIndex].stageCompleted){
                      if(earlyMorning.any((element) => element.isSelected == true)){
                        earlyMorningSelected = items.indexWhere((element) => element.isSelected == true);
                        submitPPMeals(stageIndex, 'early_morning', earlyMorning[earlyMorningSelected].followId ?? '',widget.day,earlyMorning[earlyMorningSelected].itemId ?? 0);
                      }
                      else{
                        AppConfig().showSnackbar(context, "Please select any one meal item");
                      }
                    }
                    else{
                      AppConfig().showSnackbar(context, "Already completed");
                      showBenefitsSheet(stageIndex).then((value) {
                        print("currentStage==> $currentStage");
                        setState(() {
                          if(currentStage < stages.length-1){
                            setState(() {
                              currentStage++;
                            });
                          }
                          else if(currentStage == stages.length-1){

                          }
                          print("currentStage after==> $currentStage");

                        });
                      });
                    }
                  break;
                  case 1:
                    if(!stageMap[stageIndex].stageCompleted){
                      if(breakfast.any((element) => element.isSelected == true)){
                        breakfastSelected = items.indexWhere((element) => element.isSelected == true);
                        submitPPMeals(stageIndex, 'breakfast', breakfast[breakfastSelected].followId ?? '',widget.day,breakfast[breakfastSelected].itemId ?? 0);
                      }
                      else{
                        AppConfig().showSnackbar(context, "Please select any one meal item");
                      }
                    }
                    else{
                      AppConfig().showSnackbar(context, "Already completed");
                      showBenefitsSheet(stageIndex).then((value) {
                        print("currentStage==> $currentStage");
                        setState(() {
                          if(currentStage < stages.length-1){
                            setState(() {
                              currentStage++;
                            });
                          }
                          else if(currentStage == stages.length-1){

                          }
                          print("currentStage after==> $currentStage");

                        });
                      });
                    }
                  break;
                  case 2:
                    if(!stageMap[stageIndex].stageCompleted){
                      if(midDay.any((element) => element.isSelected == true)){
                        midDaySelected = items.indexWhere((element) => element.isSelected == true);
                        submitPPMeals(stageIndex, 'mid_day', midDay[midDaySelected].followId ?? '',widget.day,midDay[midDaySelected].itemId ?? 0);
                      }
                      else{
                        AppConfig().showSnackbar(context, "Please select any one meal item");
                      }
                    }
                    else{
                      AppConfig().showSnackbar(context, "Already completed");
                      showBenefitsSheet(stageIndex).then((value) {
                        print("currentStage==> $currentStage");
                        setState(() {
                          if(currentStage < stages.length-1){
                            setState(() {
                              currentStage++;
                            });
                          }
                          else if(currentStage == stages.length-1){

                          }
                          print("currentStage after==> $currentStage");

                        });
                      });
                    }
                  break;
                  case 3:
                    if(!stageMap[stageIndex].stageCompleted){
                      if(lunch.any((element) => element.isSelected == true)){
                        lunchSelected = items.indexWhere((element) => element.isSelected == true);
                        submitPPMeals(stageIndex, 'lunch', lunch[lunchSelected].followId ?? '',widget.day,lunch[lunchSelected].itemId ?? 0);
                      }
                      else{
                        AppConfig().showSnackbar(context, "Please select any one meal item");
                      }
                    }
                    else{
                      AppConfig().showSnackbar(context, "Already completed");
                      showBenefitsSheet(stageIndex).then((value) {
                        print("currentStage==> $currentStage");
                        setState(() {
                          if(currentStage < stages.length-1){
                            setState(() {
                              currentStage++;
                            });
                          }
                          else if(currentStage == stages.length-1){

                          }
                          print("currentStage after==> $currentStage");

                        });
                      });
                    }
                  break;
                  case 4:
                    if(!stageMap[stageIndex].stageCompleted){
                      if(evening.any((element) => element.isSelected == true)){
                        eveningSelected = items.indexWhere((element) => element.isSelected == true);
                        submitPPMeals(stageIndex, 'evening', evening[eveningSelected].followId ?? '',widget.day,evening[eveningSelected].itemId ?? 0);
                      }
                      else{
                        AppConfig().showSnackbar(context, "Please select any one meal item");
                      }
                    }
                    else{
                      AppConfig().showSnackbar(context, "Already completed");
                      showBenefitsSheet(stageIndex).then((value) {
                        print("currentStage==> $currentStage");
                        setState(() {
                          if(currentStage < stages.length-1){
                            setState(() {
                              currentStage++;
                            });
                          }
                          else if(currentStage == stages.length-1){

                          }
                          print("currentStage after==> $currentStage");

                        });
                      });
                    }

                  break;
                  case 5:
                    if(!stageMap[stageIndex].stageCompleted){
                      if(dinner.any((element) => element.isSelected == true)){
                        dinnerSelected = items.indexWhere((element) => element.isSelected == true);
                        submitPPMeals(stageIndex, 'dinner', dinner[dinnerSelected].followId ?? '',widget.day,dinner[dinnerSelected].itemId ?? 0);
                      }
                      else{
                        AppConfig().showSnackbar(context, "Please select any one meal item");
                      }
                    }
                    else{
                      AppConfig().showSnackbar(context, "Already completed");
                      showBenefitsSheet(stageIndex).then((value) {
                        print("currentStage==> $currentStage");
                        setState(() {
                          if(currentStage < stages.length-1){
                            setState(() {
                              currentStage++;
                            });
                          }
                          else if(currentStage == stages.length-1){

                          }
                          print("currentStage after==> $currentStage");

                        });
                      });
                    }

                  break;
                  case 6:
                    if(!stageMap[stageIndex].stageCompleted){
                      if(postDinner.any((element) => element.isSelected == true)){
                        postDinnerSelected = items.indexWhere((element) => element.isSelected == true);
                        submitPPMeals(stageIndex, 'post_dinner', postDinner[postDinnerSelected].followId ?? '',widget.day,postDinner[postDinnerSelected].itemId ?? 0);
                      }
                      else{
                        AppConfig().showSnackbar(context, "Please select any one meal item");
                      }
                    }
                    else{
                      AppConfig().showSnackbar(context, "Already completed");
                      showBenefitsSheet(stageIndex).then((value) {
                        print("currentStage==> $currentStage");
                        setState(() {
                          if(currentStage < stages.length-1){
                            setState(() {
                              currentStage++;
                            });
                          }
                          else if(currentStage == stages.length-1){

                          }
                          print("currentStage after==> $currentStage");

                        });
                      });
                    }
                  break;
                }
                // showBenefitsSheet(stageIndex).then((value) {
                //   print("currentStage==> $currentStage");
                //   setState(() {
                //     if(currentStage < stages.length-1){
                //       setState(() {
                //         currentStage++;
                //       });
                //     }
                //     else if(currentStage == stages.length-1){
                //
                //     }
                //     print("currentStage after==> $currentStage");
                //
                //   });
                // });
              },
              child: Container(
                width: 40.w,
                height: 4.h,
                // padding:
                // EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: eUser().buttonColor,
                  borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                  // border: Border.all(
                  //     color: eUser().buttonBorderColor,
                  //     width: eUser().buttonBorderWidth
                  // ),
                ),
                child: (isSubmitted) ? buildThreeBounceIndicator() : Center(
                  child: Text(
                    (currentStage == stages.length-1) ? 'Submit' : 'Next',
                    style: TextStyle(
                      fontFamily: eUser().buttonTextFont,
                      color: eUser().buttonTextColor,
                      fontSize: eUser().buttonTextSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 6,
          )
        ],
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("something went wrong!"),
          TextButton(onPressed: (){
            switch(stageIndex){
              case 0 : getEarlyMorningApi(widget.day);
              break;
              case 1 : getBreakfastApi(widget.day);
              break;
              case 2 : getMidDayApi(widget.day);
              break;
              case 3 : getLunchApi(widget.day);
              break;
              case 4 : getEveningApi(widget.day);
              break;
              case 5 : getDinnerApi(widget.day);
              break;
              case 6 : getPostDinnerApi(widget.day);
              break;
            }
          }, child: Text('Retry'))
        ],
      ),
    );
  }

  int earlyMorningSelected = -1;
  int breakfastSelected = -1;
  int midDaySelected = -1;
  int lunchSelected = -1;
  int eveningSelected = -1;
  int dinnerSelected = -1;
  int postDinnerSelected = -1;

  showBottomHeadingView(String title, String subTitle, String suffixText){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (suffixText.isEmpty) ? Text(title,
          style: TextStyle(
            fontFamily: PPConstants().kBottomViewHeadingFont,
            fontSize: PPConstants().kBottomViewHeadingFontSize,
            color: PPConstants().kBottomViewHeadingText
          ),) :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
              style: TextStyle(
                  fontFamily: PPConstants().kBottomViewHeadingFont,
                  fontSize: PPConstants().kBottomViewHeadingFontSize,
                  color: PPConstants().kBottomViewHeadingText
              ),),
              Text(suffixText,
              style: TextStyle(
                  fontFamily: PPConstants().kBottomViewSuffixFont,
                  fontSize: PPConstants().kBottomViewSuffixFontSize,
                  color: PPConstants().kBottomViewSuffixText
              ),)
            ],
          ),
          (subTitle.isEmpty) ? SizedBox.shrink() : Text(subTitle,
              style: TextStyle(
                height: 1.5,
                  fontFamily: PPConstants().kBottomViewSubFont,
                  fontSize: PPConstants().kBottomViewSubFontSize,
                  color: PPConstants().kBottomViewSubText
              )
          )
        ],
      ),
    );
  }

  Widget showUIBasedOnStage(int currentStage){
    Widget? _widget;
    switch(currentStage){
      case 0: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[0].stageImage , stageMap[0].stageName),
        bottomWidget: bottomSendView(context, 0, earlyMorning),
        onBackIconTap: (){
          print(currentStage);
          setState(() {
            if (currentStage != 0) {
              currentStage--;
            }
            // else if(currentStage == 0){
            //   AppConfig().showSnackbar(context, "Please Submit");
            //   value =
            // }
            else{
              Navigator.pop(context);
            }
          });

        },
      );
      break;
      case 1: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[1].stageImage , stageMap[1].stageName),
        bottomWidget: bottomSendView(context, 1, breakfast),
        onBackIconTap: (){
          print("abc");
          print(currentStage);
          setState(() {
            if (currentStage != 0) {
              currentStage--;
            }
            // else if(currentStage == 0){
            //   AppConfig().showSnackbar(context, "Please Submit");
            //   value =
            // }
            else{
              Navigator.pop(context);
            }
          });

        },
      );
      break;
      case 2: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[2].stageImage , stageMap[2].stageName),
        bottomWidget: bottomSendView(context, 2, midDay),
        onBackIconTap: (){
          print("abc");
          print(currentStage);
          setState(() {
            if (currentStage != 0) {
              currentStage--;
            }
            // else if(currentStage == 0){
            //   AppConfig().showSnackbar(context, "Please Submit");
            //   value =
            // }
            else{
              Navigator.pop(context);
            }
          });

        },
      );
      break;
      case 3: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[3].stageImage , stageMap[3].stageName),
        bottomWidget: bottomSendView(context, 3, lunch),
        onBackIconTap: (){
          print("abc");
          print(currentStage);
          setState(() {
            if (currentStage != 0) {
              currentStage--;
            }
            // else if(currentStage == 0){
            //   AppConfig().showSnackbar(context, "Please Submit");
            //   value =
            // }
            else{
              Navigator.pop(context);
            }
          });

        },
      );
      break;
      case 4: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[4].stageImage , stageMap[4].stageName),
        bottomWidget: bottomSendView(context, 4, evening),
        onBackIconTap: (){
          print("abc");
          setState(() {
            if (currentStage != 0) {
              currentStage--;
            }
            // else if(currentStage == 0){
            //   AppConfig().showSnackbar(context, "Please Submit");
            //   value =
            // }
            else{
              Navigator.pop(context);
            }
            print(currentStage);
          });

        },
      );
      break;
      case 5: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[5].stageImage , stageMap[5].stageName),
        bottomWidget: bottomSendView(context, 5, dinner),
        onBackIconTap: (){
          print("abc");
          print(currentStage);
          setState(() {
            if (currentStage != 0) {
              currentStage--;
            }
            // else if(currentStage == 0){
            //   AppConfig().showSnackbar(context, "Please Submit");
            //   value =
            // }
            else{
              Navigator.pop(context);
            }
          });

        },
      );
      break;
      case 6: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[6].stageImage , stageMap[6].stageName),
        bottomWidget: bottomSendView(context, 6, postDinner),
        onBackIconTap: (){
          print("abc");
          print(currentStage);
          setState(() {
            if (currentStage != 0) {
              currentStage--;
            }
            // else if(currentStage == 0){
            //   AppConfig().showSnackbar(context, "Please Submit");
            //   value =
            // }
            else{
              Navigator.pop(context);
            }
          });

        },
      );
      break;
    }
    return _widget ?? SizedBox(child: Text(currentStage.toString()),);
  }

  String itemImage = '';
  bool isLoading = true;

  programItemsList(int stageIndex, int index, List<RoutineTask> items){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            // _scrollController.easyScrollToIndex(index: 10);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: GestureDetector(
              onTap: (){
                print(items[index].title);
                print(stageIndex);
                print(stageMap[0].stageCompleted);
                setState(() {
                  // selectedIndex = index;
                  switch(stageIndex){
                    case 0:
                      if(stageMap[0].stageCompleted){
                        AppConfig().showSnackbar(context, "Meal Already Submitted");
                      }
                      else{
                        earlyMorning.forEach((element) {
                          element.isSelected = false;
                        });
                        earlyMorningSelected = index;
                        earlyMorning[index].isSelected = true;
                      }
                      break;
                    case 1:
                      if(stageMap[1].stageCompleted){
                        AppConfig().showSnackbar(context, "Meal Already Submitted");
                      }
                      else{
                        breakfast.forEach((element) {
                          element.isSelected = false;
                        });
                        breakfastSelected = index;
                        breakfast[index].isSelected = true;
                      }
                      break;
                    case 2:
                      if(stageMap[2].stageCompleted){
                        AppConfig().showSnackbar(context, "Meal Already Submitted");
                      }
                      else{
                        midDay.forEach((element) {
                          element.isSelected = false;
                        });
                        midDaySelected = index;
                        midDay[index].isSelected = true;
                      }
                      break;
                    case 3:
                      if(stageMap[3].stageCompleted){

                      }
                      else{
                        lunch.forEach((element) {
                          element.isSelected = false;
                        });
                        lunchSelected = index;
                        lunch[index].isSelected = true;
                      }
                      break;
                    case 4:
                      if(stageMap[4].stageCompleted){

                      }
                      else{
                        evening.forEach((element) {
                          element.isSelected = false;
                        });
                        eveningSelected = index;
                        evening[index].isSelected = true;
                      }
                      break;
                    case 5:
                      if(stageMap[5].stageCompleted){

                      }
                      else{
                        dinner.forEach((element) {
                          element.isSelected = false;
                        });
                        dinnerSelected = index;
                        dinner[index].isSelected = true;
                      }
                      break;
                    case 6:
                      if(stageMap[6].stageCompleted){

                      }
                      else{
                        postDinner.forEach((element) {
                          element.isSelected = false;
                        });
                        postDinnerSelected = index;
                        postDinner[index].isSelected = true;
                      }
                      break;
                  }
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 55,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                    ),
                    child: items[index].itemUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(items[index].itemUrl ?? '',
                      fit: BoxFit.fill,
                    ),
                        ) :
                    Image.asset('assets/images/Mask Group 2171.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(items[index].title,
                      style: TextStyle(
                          fontSize: MealPlanConstants().mealNameFontSize,
                          fontFamily: MealPlanConstants().mealNameFont
                      ),
                    ),
                  ),
                  // IconButton(
                  //     onPressed: (){
                  //       openAlertBox(
                  //           title: 'Did you Follow this item ?',
                  //           titleNeeded: true,
                  //           context: context,
                  //           content: 'Please select any of the following to submit your status',
                  //           positiveButtonName: 'Followed',
                  //           positiveButton: (){
                  //             Navigator.pop(context);
                  //           },
                  //           negativeButtonName: 'UnFollowed',
                  //           negativeButton: (){
                  //             Navigator.pop(context);
                  //           }
                  //       );
                  //     },
                  //     icon: Icon(Icons.edit)),
                  Visibility(
                    visible: items[index].isSelected,
                    child: GestureDetector(
                      onTap: (){
                        print(items[index].title);
                        print(stageIndex);
                        print(stageMap[0].stageCompleted);
                        setState(() {
                          // selectedIndex = index;
                          switch(stageIndex){
                            case 0:
                              if(stageMap[0].stageCompleted){

                              }
                              else{
                                earlyMorning.forEach((element) {
                                  element.isSelected = false;
                                });
                                earlyMorningSelected = index;
                                earlyMorning[index].isSelected = true;
                              }
                              break;
                            case 1:
                              if(stageMap[1].stageCompleted){

                              }
                              else{
                                breakfast.forEach((element) {
                                  element.isSelected = false;
                                });
                                breakfastSelected = index;
                                breakfast[index].isSelected = true;
                              }
                              break;
                            case 2:
                              if(stageMap[2].stageCompleted){

                              }
                              else{
                                midDay.forEach((element) {
                                  element.isSelected = false;
                                });
                                midDaySelected = index;
                                midDay[index].isSelected = true;
                              }
                              break;
                            case 3:
                              if(stageMap[3].stageCompleted){

                              }
                              else{
                                lunch.forEach((element) {
                                  element.isSelected = false;
                                });
                                lunchSelected = index;
                                lunch[index].isSelected = true;
                              }
                              break;
                            case 4:
                              if(stageMap[4].stageCompleted){

                              }
                              else{
                                evening.forEach((element) {
                                  element.isSelected = false;
                                });
                                eveningSelected = index;
                                evening[index].isSelected = true;
                              }
                              break;
                            case 5:
                              if(stageMap[5].stageCompleted){

                              }
                              else{
                                dinner.forEach((element) {
                                  element.isSelected = false;
                                });
                                dinnerSelected = index;
                                dinner[index].isSelected = true;
                              }
                              break;
                            case 6:
                              if(stageMap[6].stageCompleted){

                              }
                              else{
                                postDinner.forEach((element) {
                                  element.isSelected = false;
                                });
                                postDinnerSelected = index;
                                postDinner[index].isSelected = true;
                              }
                              break;
                          }
                        });

                      },
                      child: Image.asset('assets/images/gmg/Symbol.png',
                        width: 15, height: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Divider()
      ],
    );
  }

  /// current stage = Early morning, mid day, breakfast........
  /// index is clicked item on each stage
  Future showBenefitsSheet(int currentStage) async{
    return await showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return StatefulBuilder(builder: (_, setState){
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: Container(
                padding: EdgeInsets.only(top: 3.h, left: 6.w, right: 6.w),
                decoration: const BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                height: 50.h,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stageMap[currentStage].stageName,
                      style: TextStyle(
                          fontFamily: PPConstants().kBottomSheetHeadingFont,
                          fontSize: PPConstants().kBottomSheetHeadingFontSize,
                          color: PPConstants().kBottomSheetHeadingText
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(getName(currentStage),
                        style: TextStyle(
                            fontFamily: PPConstants().kBottomSheetBenefitsFont,
                            fontSize: PPConstants().kBottomSheetBenefitsFontSize,
                            color: PPConstants().kBottomSheetBenefitsText
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: gHintTextColor,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Benifits',
                            style: TextStyle(
                                fontFamily: PPConstants().kBottomSheetHeadingFont,
                                fontSize: PPConstants().kBottomSheetHeadingFontSize,
                                color: PPConstants().kBottomSheetHeadingText
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(getBenefits(currentStage),
                            style: TextStyle(
                                fontFamily: PPConstants().kBottomSheetBenefitsFont,
                                fontSize: PPConstants().kBottomSheetBenefitsFontSize,
                                color: PPConstants().kBottomSheetBenefitsText
                            ),
                          ),
                          // Text('* Heals the gut epithelia',
                          //   style: TextStyle(
                          //       fontFamily: PPConstants().kBottomSheetBenefitsFont,
                          //       fontSize: PPConstants().kBottomSheetBenefitsFontSize,
                          //       color: PPConstants().kBottomSheetBenefitsText
                          //   ),
                          // ),
                          // Text('* Gut mucosal health',
                          //   style: TextStyle(
                          //       fontFamily: PPConstants().kBottomSheetBenefitsFont,
                          //       fontSize: PPConstants().kBottomSheetBenefitsFontSize,
                          //       color: PPConstants().kBottomSheetBenefitsText
                          //   ),
                          // ),
                          // Text('* Builds gut micro biome and immunity',
                          //   style: TextStyle(
                          //       fontFamily: PPConstants().kBottomSheetBenefitsFont,
                          //       fontSize: PPConstants().kBottomSheetBenefitsFontSize,
                          //       color: PPConstants().kBottomSheetBenefitsText
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: eUser().buttonColor,
                            borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                            // border: Border.all(
                            //     color: eUser().buttonBorderColor,
                            //     width: eUser().buttonBorderWidth
                            // ),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontFamily: eUser().buttonTextFont,
                              color: eUser().buttonTextColor,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  getEarlyMorningApi(String dayNumber) async{
    final res = await PostProgramService(repository: postProgramRepository)
        .getPPMealsOnStagesService(stages.first, dayNumber);
    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      print("get error ${model.message}");
    }
    else{
      final model = res as PPGetMealModel;
      print("getEarlyMorningApi");
      if(model.data!.doMeals !=null){
        model.data!.doMeals!.forEach((element) {
          print(element.isSelected == 1);
          print(element.isSelected == 0 ? false : true);
          if(element.isSelected == 1){
            stageMap[0].stageCompleted = true;
          }
          print("isSelect: ${element.isSelected}");
          earlyMorning.add(RoutineTask(title: element.name ?? '',
              itemUrl: (element.itemPhoto != null) ? Uri.parse(element.itemPhoto!).toString() : '',
              isSelected: element.isSelected== 0 ? false : true,
              benefits: element.benefits ?? '',
              followId: '1',
              itemId: element.itemId
          ));
          earlyMorning.forEach((element) {
            print('${element.isSelected}==> ${element.title}');
          });
        });
        if(model.data!.doNot != null) {
          model.data!.doNot!.forEach((element) {
          print(element.isSelected == 0 ? false : true);
          if(element.isSelected == 1) {
            stageMap[0].stageCompleted = true;
          }
          earlyMorning.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 0 ? false : true,
              benefits: element.benefits ?? '',
              followId: '2',
            itemId: element.itemId
          ));
        });
        }
        earlyMorningSelected = earlyMorning.indexWhere((element) => element.isSelected == true);
        print("eveningSelected==>$earlyMorningSelected");

        earlyMorning.forEach((element) {
          print("element.isSelected==> ${element.isSelected}");
        });
      }
    }
    setState(() {
      isLoading = false;
    });
    getBreakfastApi(dayNumber);
    getMidDayApi(dayNumber);
    getLunchApi(dayNumber);
    getEveningApi(dayNumber);
    getDinnerApi(dayNumber);
    getPostDinnerApi(dayNumber);
  }
  getBreakfastApi(String dayNumber) async{
    final res = await PostProgramService(repository: postProgramRepository)
        .getPPMealsOnStagesService(stages[1], dayNumber);
    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      print("get error ${model.message}");
    }
    else{
      final model = res as PPGetMealModel;
      print("getBreakfastApi");
      print(model.data!.toJson());
      if(model.data!.doMeals !=null){
        model.data!.doMeals!.forEach((element) {
          print(element.isSelected == 1);
          print(element.isSelected);
          if(element.isSelected == 1){
            stageMap[1].stageCompleted = true;
          }
          breakfast.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '1',
              itemId: element.itemId
          ));
        });
        if(model.data!.doNot != null) {
          model.data!.doNot!.forEach((element) {
          if(element.isSelected == 1) {
            stageMap[1].stageCompleted = true;
          }
          breakfast.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '2',
              itemId: element.itemId
          ));
        });
        }
        breakfastSelected = breakfast.indexWhere((element) => element.isSelected == true);

      }
    }
  }
  getMidDayApi(String dayNumber) async{
    final res = await PostProgramService(repository: postProgramRepository)
        .getPPMealsOnStagesService(stages[2], dayNumber);
    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      print("get error ${model.message}");
    }
    else{
      final model = res as PPGetMealModel;
      print("getMidDayApi");
      print(model.data!.toJson());
      if(model.data!.doMeals !=null){
        model.data!.doMeals!.forEach((element) {
          print(element.isSelected == 1);
          print(element.isSelected);
          if(element.isSelected == 1){
            stageMap[2].stageCompleted = true;
          }
          midDay.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '1',
                        itemId: element.itemId
          ));
        });
        if(model.data!.doNot != null) {
          model.data!.doNot!.forEach((element) {
          if(element.isSelected == 1) {
            stageMap[2].stageCompleted = true;
          }
          midDay.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '2',
                        itemId: element.itemId
          ));
        });
        }
        midDaySelected = midDay.indexWhere((element) => element.isSelected == true);
      }

    }
  }
  getLunchApi(String dayNumber) async{
    final res = await PostProgramService(repository: postProgramRepository)
        .getPPMealsOnStagesService(stages[3], dayNumber);
    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      print("get error ${model.message}");
    }
    else{
      final model = res as PPGetMealModel;
      print("getLunchApi");
      print(model.data!.toJson());
      if(model.data!.doMeals !=null){
        model.data!.doMeals!.forEach((element) {
          print(element.isSelected == 1);
          print(element.isSelected);
          if(element.isSelected == 1){
            stageMap[3].stageCompleted = true;

          }
          lunch.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '1',
              itemId: element.itemId
          ));
        });
        if(model.data!.doNot != null) {
          model.data!.doNot!.forEach((element) {
          if(element.isSelected == 1) {
            stageMap[3].stageCompleted = true;

          }
          lunch.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '2',
              itemId: element.itemId
          ));
        });
        }
        lunchSelected = lunch.indexWhere((element) => element.isSelected == true);
      }
    }
  }
  getEveningApi(String dayNumber) async{
    final res = await PostProgramService(repository: postProgramRepository)
        .getPPMealsOnStagesService(stages[4], dayNumber);
    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      print("get error ${model.message}");
    }
    else{
      final model = res as PPGetMealModel;
      print("getEveningApi");
      print(model.data!.toJson());
      if(model.data!.doMeals !=null){
        model.data!.doMeals!.forEach((element) {
          print(element.isSelected == 1);
          print(element.isSelected);
          if(element.isSelected == 1){
            stageMap[4].stageCompleted = true;
          }
          evening.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '1',
              itemId: element.itemId
          ));
        });
        if(model.data!.doNot != null) {
          model.data!.doNot!.forEach((element) {
          if(element.isSelected == 1) {
            stageMap[4].stageCompleted = true;
          }
          evening.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '2',
              itemId: element.itemId
          ));
        });
        }
        eveningSelected = evening.indexWhere((element) => element.isSelected == true);
      }
    }
  }
  getDinnerApi(String dayNumber) async{
    final res = await PostProgramService(repository: postProgramRepository)
        .getPPMealsOnStagesService(stages[5], dayNumber);
    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      print("get error ${model.message}");
    }
    else{
      final model = res as PPGetMealModel;
      print("getDinnerApi");
      print(model.data!.toJson());
      if(model.data!.doMeals !=null){
        model.data!.doMeals!.forEach((element) {
          print(element.isSelected == 1);
          print(element.isSelected);
          if(element.isSelected == 1){
            stageMap[5].stageCompleted = true;

          }
          dinner.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '1',
              itemId: element.itemId
          ));
        });
        if(model.data!.doNot != null) {
          model.data!.doNot!.forEach((element) {
          if(element.isSelected == 1) {
            stageMap[5].stageCompleted = true;
          }
          dinner.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '2',
              itemId: element.itemId
          ));
        });
        }
        dinnerSelected = dinner.indexWhere((element) => element.isSelected == true);
      }
    }
  }
  getPostDinnerApi(String dayNumber) async{
    final res = await PostProgramService(repository: postProgramRepository)
        .getPPMealsOnStagesService(stages[6], dayNumber);
    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      print("get error ${model.message}");
    }
    else{
      final model = res as PPGetMealModel;
      print("getPostDinnerApi");
      print(model.data!.toJson());
      if(model.data!.doMeals !=null){
        model.data!.doMeals!.forEach((element) {
          print(element.isSelected == 1);
          print(element.isSelected);
          if(element.isSelected == 1){
            stageMap[6].stageCompleted = true;
          }
          postDinner.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '1',
              itemId: element.itemId
          ));
        });
        if(model.data!.doNot != null) {
          model.data!.doNot!.forEach((element) {
          if(element.isSelected == 1) {
            stageMap[6].stageCompleted = true;
          }
          postDinner.add(RoutineTask(title: element.name ?? '',
              itemUrl: element.itemPhoto ?? '',
              isSelected: element.isSelected == 1 ? true : false,
              benefits: element.benefits ?? '', followId: '2',
              itemId: element.itemId
          ));
        });
        }
        postDinnerSelected = postDinner.indexWhere((element) => element.isSelected == true);
      }
    }
  }

  PostProgramRepository postProgramRepository =
  PostProgramRepository(apiClient: ApiClient(httpClient: http.Client()));

  String getName(int currentStage) {
    String name = '';
    switch(currentStage){
      case 0: name = earlyMorning[earlyMorningSelected].title;
      break;
      case 1: name = breakfast[breakfastSelected].title;
      break;
      case 2: name = midDay[midDaySelected].title;
      break;
      case 3: name = lunch[lunchSelected].title;
      break;
      case 4: name = evening[eveningSelected].title;
      break;
      case 5: name = dinner[dinnerSelected].title;
      break;
      case 6: name = postDinner[postDinnerSelected].title;
      break;
    }
    return name;
  }

  String getBenefits(int currentStage) {
    String benefits = '';
    switch(currentStage){
      case 0: benefits = earlyMorning[earlyMorningSelected].benefits ?? '';
      break;
      case 1: benefits = breakfast[breakfastSelected].benefits ?? '';
      break;
      case 2: benefits = midDay[midDaySelected].benefits ?? '';
      break;
      case 3: benefits = lunch[lunchSelected].benefits ?? '';
      break;
      case 4: benefits = evening[eveningSelected].benefits ?? '';
      break;
      case 5: benefits = dinner[dinnerSelected].benefits ?? '';
      break;
      case 6: benefits = postDinner[postDinnerSelected].benefits ?? '';
      break;
    }
    return benefits;
  }

  bool isSubmitted = false;
  submitPPMeals(int stageIndex, String stageType, String followId, String day, int itemId) async{
    print("day==> ${widget.day}");
    setState(() {
      isSubmitted = true;
    });
    final res = await PostProgramService(repository: postProgramRepository)
        .submitPPMealsService(stageType, followId, itemId, int.parse(day));
    if(res.runtimeType == ErrorModel){
      AppConfig().showSnackbar(context, "Submit Error..", isError: true);
      setState(() {
        isSubmitted = false;
      });
    }
    else{
      setState(() {
        isSubmitted = false;
      });
      showBenefitsSheet(stageIndex).then((value) {
        print("currentStage==> $currentStage");
        setState(() {
          if(currentStage < stages.length-1){
            setState(() {
              currentStage++;
            });
          }
          else if(currentStage == stages.length-1){

          }
          print("currentStage after==> $currentStage");

        });
      });
    }

  }

}


class RoutineTask{
  String title;
  String? benefits;
  String? itemUrl;
  bool isSelected;
  //do=> 1, do
  String? followId;
  int? itemId;
  RoutineTask({required this.title, this.isSelected = false, this.itemUrl, this.benefits, this.followId, this.itemId});
}

class StageTypes{
  String stageImage;
  String stageName;
  String stageSubText;
  bool stageCompleted;
  StageTypes({required this.stageImage, required this.stageName, required this.stageSubText, this.stageCompleted = false});
}