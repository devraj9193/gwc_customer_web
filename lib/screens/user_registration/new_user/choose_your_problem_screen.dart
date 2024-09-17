/*
Api Url used ->
 * var getProblemListUrl = "${AppConfig().BASE_URL}/api/list/problem_list";
 * var submitProblemListUrl = "${AppConfig().BASE_URL}/api/form/submit_problems";

 */

import 'dart:collection';
import 'dart:developer';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/error_model.dart';
import '../../../model/new_user_model/choose_your_problem/child_choose_problem.dart';
import '../../../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../../../model/new_user_model/choose_your_problem/submit_problem_response.dart';
import '../../../repository/api_service.dart';
import '../../../repository/new_user_repository/choose_problem_repository.dart';
import '../../../services/new_user_service/choose_problem_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'about_the_program.dart';
import 'choose_problems_data.dart';
import 'package:gwc_customer_web/widgets/dart_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChooseYourProblemScreen extends StatefulWidget {
  const ChooseYourProblemScreen({Key? key}) : super(key: key);

  @override
  State<ChooseYourProblemScreen> createState() =>
      _ChooseYourProblemScreenState();
}

class _ChooseYourProblemScreenState extends State<ChooseYourProblemScreen> {

  List selectedProblems = [];
  final otherController = TextEditingController();
  Future? myFuture;

  bool isLoading = false;

  String? deviceId;
  ChooseProblemService? _chooseProblemService;

  SharedPreferences? _prefs;

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }


  @override
  void initState() {
    super.initState();

    // _chooseProblemService = Provider.of<ChooseProblemService>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _chooseProblemService = ChooseProblemService(repository: repository);
      myFuture = getProblemList();
      getDeviceId();
    });

    otherController.addListener(() {
      setState(() { });
    });
  }

  @override
  void dispose() {
    super.dispose();
    otherController.removeListener(() {
      setState(() { });

    });
    otherController.dispose();
  }

  getDeviceId() async{
    _prefs = await SharedPreferences.getInstance();
    if(_prefs!.getString(AppConfig().deviceId) == null || _prefs!.getString(AppConfig().deviceId) != ""){
      await AppConfig().getDeviceId().then((id) {
        print("deviceId: $id");
        if(id != null){
          _prefs!.setString(AppConfig().deviceId, id);
        }
        setState(() {
          deviceId = id;
        });
      });
    }
    else{
      deviceId = _prefs!.getString(AppConfig().deviceId);
    }
  }


  getProblemList() async{
    return await _chooseProblemService!.getProblems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: gBackgroundColor,
        body: Padding(
          padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Choose Your Gut Issue",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: eUser().mainHeadingFont,
                    fontSize: eUser().mainHeadingFontSize,
                    color: eUser().mainHeadingColor
                ),
              ),
              SizedBox(
                height: 2.5.h,
              ),
              Expanded(child: SingleChildScrollView(child: buildChooseProblem(),),),
            ],
          ),
        ),
      ),
    );
  }

  buildChooseProblem() {
    return FutureBuilder(
        future: myFuture,
        builder: (_, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.runtimeType == ChooseProblemModel){
              ChooseProblemModel model = snapshot.data as ChooseProblemModel;
              List<ChildChooseProblemModel>? problemList = model.data;
              return Column(
                children: [
                  GridView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.shortestSide < 600 ? 3 : 5,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 25.h,
                        // childAspectRatio: MediaQuery.of(context).size.width /
                        //     (MediaQuery.of(context).size.height / 1.4),
                      ),
                      // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                      itemCount: problemList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print("Problem: ${problemList?[index].name}");
                            buildChooseProblemOnClick(problemList![index]);
                          },
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              // border: Border.all(
                              //     color: eUser().buttonBorderColor,
                              //     width: eUser().buttonBorderWidth
                              // ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 5,
                                  offset: const Offset(2, 5),
                                ),
                              ],
                              image: DecorationImage(
                                  image: AssetImage("assets/images/Group 4855.png"),
                                  fit: BoxFit.fill,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // SizedBox(height: 1.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 1.h),
                                        child: ImageNetwork(
                                          image:  problemList?[index].image ?? '',
                                          height: 100,
                                          width: 100,
                                          duration: 1500,
                                          curve: Curves.easeIn,
                                          onPointer: true,
                                          debugPrint: false,
                                          fullScreen: false,
                                          fitAndroidIos: BoxFit.cover,
                                          fitWeb: BoxFitWeb.contain,
                                          borderRadius: BorderRadius.circular(10),
                                          onLoading: const CircularProgressIndicator(
                                            color: Colors.indigoAccent,
                                          ),
                                          onError: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            print("Problem: ${problemList?[index].name}");
                                            buildChooseProblemOnClick(problemList![index]);
                                            debugPrint("©gabriel_patrick_souza");
                                          },
                                        ),
                                        // CachedNetworkImage(
                                        //   imageUrl: problemList?[index].image ?? '',
                                        //   height: 15.h,
                                        //   errorWidget: (ctx, _, __){
                                        //     return Image.asset("assets/images/placeholder.png",
                                        //       height: 15.h,
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                      // Image(
                                      //   height: 40,
                                      //   width: 40,
                                      //   image: CachedNetworkImageProvider(problemList?[index].image ?? ''),
                                      // ),
                                      SizedBox(height: 1.5.h),
                                      Expanded(
                                        child: Text(
                                          // 'Constipation Constipationdsd',
                                          problemList?[index].name.toString() ?? '',
                                          style: TextStyle(
                                            fontFamily: kFontBold,
                                            color: gTextColor,
                                            fontSize: (problemList![index].name.toString().length > 10) ? 8.sp : 9.sp,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Visibility(
                                    visible: selectedProblems.contains(problemList?[index].id),
                                    child:  Align(
                                      alignment: Alignment.topLeft,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: gMainColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: 5.h),
                  Container(
                    height: 15.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(2, 10),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: otherController,
                      cursorColor: gPrimaryColor,
                      style: TextStyle(
                          fontFamily: eUser().userTextFieldFont,
                          fontSize: eUser().userTextFieldFontSize,
                          color: eUser().userTextFieldColor
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        // suffixIcon: otherController.text.isEmpty
                        //     ? SizedBox.shrink()
                        //     : InkWell(
                        //   onTap: () {
                        //     otherController.clear();
                        //   },
                        //   child: const Icon(
                        //     Icons.close,
                        //     color: gTextColor,
                        //   ),
                        // ),
                        hintMaxLines: 2,
                        hintText: "Additional comments",
                        // hintText: "Pick one or more from the list above, or write to us about the underlying issue that brought you here.",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: eUser().userTextFieldHintFont,
                          color: eUser().userTextFieldHintColor,
                          fontSize: eUser().userTextFieldHintFontSize,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Center(
                    child: IntrinsicWidth(
                      child: GestureDetector(
                        onTap: selectedProblems.isEmpty && otherController.text.isEmpty ? (){
                          print(otherController.text.isEmpty);
                          AppConfig().showSnackbar(context, "Please Select/Mention your Problem",isError: true);
                        } : () {
                          submitProblems();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 5.w),
                          decoration: BoxDecoration(
                            color: selectedProblems.isEmpty ? eUser().buttonColor : eUser().buttonColor,
                            borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                            border: Border.all(
                                color: eUser().buttonBorderColor,
                                width: eUser().buttonBorderWidth
                            ),
                          ),
                          child: (isLoading) ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                              : Center(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontFamily: eUser().buttonTextFont,
                                color: selectedProblems.isEmpty ? eUser().buttonTextColor : eUser().buttonTextColor,
                                fontSize: eUser().buttonTextSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              );
            }
            else{
              return const SizedBox(
                width: double.infinity,
                child: Text("Problems Not Found"),
              );
            }
          }
          else if(snapshot.hasError){
            print("snap error: ${snapshot.error}");
            if(snapshot.error.toString().contains("SocketException")){
              return const SizedBox(
                width: double.infinity,
                child: Text("Problems Not Found"),
              );
            }

          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: buildCircularIndicator(),);
        }
    );
  }

  buildChooseProblemOnClick(ChildChooseProblemModel healthCheckBox){
    if(selectedProblems.contains(healthCheckBox.id)){
      setState(() {
        selectedProblems.remove(healthCheckBox.id);
      });
    }
    else{
      setState(() {
        selectedProblems.add(healthCheckBox.id);
      });
    }
  }


  final ChooseProblemRepository repository = ChooseProblemRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void submitProblems() async {
    setState(() {
      isLoading = true;
    });
    final res = await _chooseProblemService!.postProblems(deviceId!, problemList: selectedProblems.isEmpty ? null : selectedProblems, otherProblem: otherController.text);
    print(res);
    print(res.runtimeType);
    setState(() {
      isLoading = false;
    });
    if(res.runtimeType == SubmitProblemResponse){
      SubmitProblemResponse _submitResponse = res;
      print(_submitResponse);
      if(_submitResponse.status == "200"){
        print(_submitResponse.message);
        // AppConfig().showSnackbar(context, _submitResponse.message!);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AboutTheProgram(),
          ),
        );
      }
      else {
        print(_submitResponse.message);
        AppConfig().showSnackbar(context, _submitResponse.message!, isError: true);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) =>
        //     const GivenDetailsScreen(),
        //   ),
        // );
      }
    }
    else if(res.runtimeType == ErrorModel){
      ErrorModel response = res;
      AppConfig().showSnackbar(context, response.message!, isError: true);
    }

    // if(res){
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) =>
    //       const GivenDetailsScreen(),
    //     ),
    //   );
    // }
  }

}

