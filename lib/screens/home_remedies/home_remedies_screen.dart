/*
Api used:
var homeRemediesUrl = "${AppConfig().BASE_URL}/api/list/home_remedies";

if element.isGeneral == "0" than general
if element.isGeneral == "1" than program phase


 */

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/home_remedy_model/home_remedies_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/services/home_remedy_service/home_remedies_service.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import '../../repository/home_remedies_repository/home_remedies_repository.dart';
import 'new_know_more_screen.dart';

class HomeRemediesScreen extends StatefulWidget {
  const HomeRemediesScreen({Key? key}) : super(key: key);

  @override
  State<HomeRemediesScreen> createState() => _HomeRemediesScreenState();
}

class _HomeRemediesScreenState extends State<HomeRemediesScreen> {
  HomeRemediesService? homeRemediesService;

  Future? homeRemediesFuture;

  Future getDaySummary() async {
    homeRemediesFuture =
        HomeRemediesService(repository: repository).getHomeRemediesService();
  }

  @override
  void initState() {
    super.initState();
    getDaySummary();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: gWhiteColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                child: buildAppBar(() {
                  Navigator.pop(context);
                }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  "Home Remedies",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: kFontBold,
                    color: gBlackColor,
                    fontSize: 16.dp,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              TabBar(
                unselectedLabelColor: gBlackColor,
                labelColor: gBlackColor,
                dividerColor: Colors.transparent,
                unselectedLabelStyle: TextStyle(
                    fontFamily: kFontBook,
                    color: gHintTextColor,
                    fontSize: 12.dp),
                labelStyle: TextStyle(
                    fontFamily: kFontMedium,
                    color: gBlackColor,
                    fontSize: 15.dp),
                indicatorColor: newDashboardGreenButtonColor.withOpacity(0.5),
                labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                indicatorPadding:
                    EdgeInsets.only(left: -5.w, right: -5.w, top: -2.h),
                indicator: BoxDecoration(
                  color: newDashboardGreenButtonColor.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                tabs: const [
                  Text('General'),
                  Text("Program Phase Remedies"),
                ],
              ),
              Expanded(
                child: Container(
                  color: newDashboardGreenButtonColor.withOpacity(0.5),
                  margin: EdgeInsets.only(top: 0.h),
                  child: TabBarView(
                    children: [
                      buildGeneralProblems(),
                      buildProgramProblems(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildGeneralProblems() {
    return FutureBuilder(
        future: homeRemediesFuture,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.runtimeType == HomeRemediesModel) {
              HomeRemediesModel model = snapshot.data as HomeRemediesModel;
              List<HomeRemedy>? totalList = model.data.homeRemedies;
              List<HomeRemedy> problemList = [];
              for (var element in totalList) {
                if (element.isGeneral == "0") {
                  problemList.add(element);
                }
              }
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: 4.h, left: 3.w, right: 3.w, bottom: 2.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    crossAxisCount:
                        MediaQuery.of(context).size.shortestSide < 600 ? 3 : 5,
                    mainAxisExtent: 30.h,
                    // childAspectRatio: MediaQuery.of(context).size.width /
                    //     (MediaQuery.of(context).size.height / 1.4),
                  ),
                  // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                  itemCount: problemList.length,
                  itemBuilder: (context, index) {
                    // print("thumbnail : ${problemList[index].thumbnail}");
                    return problemList[index].isGeneral == "0"
                        ? GestureDetector(
                            onTap: () {
                              Get.to(
                                () => NewKnowMoreScreen(
                                  knowMore: problemList[index].knowMore,
                                  healAtHome: problemList[index].healAtHome,
                                  healAnywhere: problemList[index].healAnywhere,
                                  whenToReachUs:
                                      problemList[index].whenToReachUs,
                                  title: problemList[index].name.toString(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: gWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: gBlackColor.withOpacity(0.1),
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                    offset: const Offset(2,5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 22.h,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: gsecondaryColor.withOpacity(0.05),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),

                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: ImageNetwork(
                                        image: problemList[index].thumbnail,
                                        height: 23.h,
                                        width: 15.w,
                                        fitAndroidIos: BoxFit.contain,
                                        fitWeb: BoxFitWeb.contain,
                                        onLoading:
                                            const CircularProgressIndicator(
                                          color: Colors.indigoAccent,
                                        ),
                                        onError: Image.asset(
                                            "assets/images/placeholder.png"),
                                        onTap: () {
                                          Get.to(
                                            () => NewKnowMoreScreen(
                                              knowMore:
                                                  problemList[index].knowMore,
                                              healAtHome:
                                                  problemList[index].healAtHome,
                                              healAnywhere: problemList[index]
                                                  .healAnywhere,
                                              whenToReachUs: problemList[index]
                                                  .whenToReachUs,
                                              title: problemList[index]
                                                  .name
                                                  .toString(),
                                            ),
                                          );
                                          debugPrint("©gabriel_patrick_souza");
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1.5.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    child: Text(
                                      problemList[index].name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: kFontBold,
                                        color: gBlackColor,
                                        fontSize: 12.dp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // CachedNetworkImage(
                            //   height: 23.h,
                            //   width: 35.w,
                            //   imageUrl:
                            //       "${Uri.parse(problemList[index].thumbnail)}",
                            //   placeholder: (__, _) {
                            //     return Image.asset(
                            //         "assets/images/placeholder.png");
                            //   },
                            //   errorWidget: (_, __, ___) {
                            //     return Image.asset(
                            //         "assets/images/placeholder.png");
                            //   },
                            // ),
                          )
                        : const SizedBox();
                  });
            }
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: buildCircularIndicator(),
          );
        });
  }

  buildProgramProblems() {
    return FutureBuilder(
        future: homeRemediesFuture,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.runtimeType == HomeRemediesModel) {
              HomeRemediesModel model = snapshot.data as HomeRemediesModel;
              List<HomeRemedy>? totalList = model.data.homeRemedies;
              List<HomeRemedy> problemList = [];
              for (var element in totalList) {
                if (element.isGeneral == "1") {
                  problemList.add(element);
                }
              }
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: 4.h, left: 3.w, right: 3.w, bottom: 2.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    crossAxisCount:
                        MediaQuery.of(context).size.shortestSide < 600 ? 3 : 4,
                    mainAxisExtent: 30.h,
                    // childAspectRatio: MediaQuery.of(context).size.width /
                    //     (MediaQuery.of(context).size.height / 1.4),
                  ),
                  // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                  itemCount: problemList.length,
                  itemBuilder: (context, index) {
                    // print("thumbnail : ${problemList[index].thumbnail}");
                    return problemList[index].isGeneral == "1"
                        ? GestureDetector(
                            onTap: () {
                              Get.to(
                                () => NewKnowMoreScreen(
                                  knowMore: problemList[index].knowMore,
                                  healAtHome: problemList[index].healAtHome,
                                  healAnywhere: problemList[index].healAnywhere,
                                  whenToReachUs:
                                      problemList[index].whenToReachUs,
                                  title: problemList[index].name.toString(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: gWhiteColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 22.h,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        color:
                                            gsecondaryColor.withOpacity(0.05),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        )),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: ImageNetwork(
                                        image: problemList[index].thumbnail,
                                        height: 23.h,
                                        width: 15.w,
                                        fitAndroidIos: BoxFit.contain,
                                        fitWeb: BoxFitWeb.contain,
                                        onLoading:
                                            const CircularProgressIndicator(
                                          color: Colors.indigoAccent,
                                        ),
                                        onError: Image.asset(
                                            "assets/images/placeholder.png"),
                                        onTap: () {
                                          Get.to(
                                            () => NewKnowMoreScreen(
                                              knowMore:
                                                  problemList[index].knowMore,
                                              healAtHome:
                                                  problemList[index].healAtHome,
                                              healAnywhere: problemList[index]
                                                  .healAnywhere,
                                              whenToReachUs: problemList[index]
                                                  .whenToReachUs,
                                              title: problemList[index]
                                                  .name
                                                  .toString(),
                                            ),
                                          );
                                          debugPrint("©gabriel_patrick_souza");
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1.5.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    child: Text(
                                      problemList[index].name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: kFontBold,
                                        color: gBlackColor,
                                        fontSize: 12.dp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // CachedNetworkImage(
                            //   height: 23.h,
                            //   width: 35.w,
                            //   imageUrl:
                            //       "${Uri.parse(problemList[index].thumbnail)}",
                            //   placeholder: (__, _) {
                            //     return Image.asset(
                            //         "assets/images/placeholder.png");
                            //   },
                            //   errorWidget: (_, __, ___) {
                            //     return Image.asset(
                            //         "assets/images/placeholder.png");
                            //   },
                            // ),
                          )
                        : const SizedBox();
                  });
            }
          }
          return buildCircularIndicator();
        });
  }

  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    // ignore: prefer_function_declarations_over_variables
    final getColor = (Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return WidgetStateProperty.resolveWith(getColor);
  }

  final HomeRemediesRepository repository = HomeRemediesRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
