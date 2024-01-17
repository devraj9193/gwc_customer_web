import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import '../../../model/error_model.dart';
import '../../../model/faq_model/faq_list_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/profile_repository/settings_repo.dart';
import '../../../services/profile_screen_service/settings_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/unfocus_widget.dart';
import '../../../widgets/widgets.dart';
import 'faq_answers_screen.dart';
import 'faq_detailed_list_screen.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final searchController = TextEditingController();
  //FAQs
  //
  // GENERAL QUERY
  //
  // 1. Can I skip a day and restart?
  // No, this will drastically reduce the efficacy.
  //
  // 2. Can the program be followed by a family member?
  // No, each program is customized based on your gut & hence will not work for another person.
  //
  // 3. Will I get a refund if i can't continue?
  // Once your program has been created we will not be able to issue a refund.

  // YOGA PLAN QUERY
  //
  // 1. Can I skip yoga?
  // Not at all, Yoga does 30% of the work in your program & is vital.
  //
  // 2. When should I do yoga?
  // Please follow your yoga modules as prescribed in your Diet & Yoga plans
  //
  // 3. I am not fit enough to do the yoga modules.
  // Get in touch with us & we’ll have it changed for you.

  // 1. Can I have ice cream/supplements/curd/egg/apple cider vinegar?
  // No, None. This will drastically reduce the efficacy.
  //
  // 2. Can I add flavoring to the meals?
  // Yes but only the ones prescribed in your plan. Honey is something you can add.
  //
  // 3. I am out the whole day today & will be unable to follow my plan, can I have something from
  // outside?
  // Only fruits, boiled vegetables, fruit juices & tender coconut water. No milk, No sugar.

  List<GridTileItems> faqGridList = [
    // GridTileItems("Transaction", "assets/images/faq/transaction_faq.png"),
    // GridTileItems("Subscription", "assets/images/faq/subscription_faq.png"),
    GridTileItems(0, "Consultation", "assets/images/faq/consultation_faq.png"),
    GridTileItems(1, "Our products", "assets/images/faq/ourproducts_faq.png"),
    GridTileItems(2, "Program Based", "assets/images/faq/program_faq.png"),
    GridTileItems(3, "Meals/Recipe", "assets/images/faq/meals_faq.png"),
    GridTileItems(4, "Food\nPrescriptions", "assets/images/faq/food_faq.png"),
    GridTileItems(5, "Post Program", "assets/images/faq/postprogram_faq.png"),
    GridTileItems(
        6, "Medicines/\nSupplements", "assets/images/faq/medicines_faq.png"),
    GridTileItems(
        7, "Challenges and Adherence", "assets/images/faq/challenges_faq.png"),
    GridTileItems(8, "Program\nOutcomes", "assets/images/faq/outcomes_faq.png"),
    GridTileItems(9, "Move", "assets/images/faq/yoga.png"),
    GridTileItems(10, "Calm", "assets/images/faq/calm.png"),
  ];

  List<FaqList> fullFaq = [];
  List<FaqList> searchedFAQResults = [];

  Future? faqFuture;

  @override
  void initState() {
    super.initState();

    getFaqListData();
  }

  bool showLoading = true;
  getFaqListData() async {
    final res = await SettingsService(repository: repo).getFaqListService();

    if (res.runtimeType is ErrorModel) {
      ErrorModel model = res as ErrorModel;
      AppConfig().showSnackbar(context, AppConfig.oopsMessage, isError: true);
    } else {
      print("else");
      FaqListModel model = res as FaqListModel;
      fullFaq.addAll(model.faqList!);
      print("fullFaq: ${fullFaq}");
      faqGridList.forEach((element) {
        element.faqList = [];
      });
      // faqGridList[0].faqList = [];

      fullFaq.forEach((element) {
        print(element.faqType == FaqTypes.Consultation.name);
        if (element.faqType == FaqTypes.Consultation.name) {
          faqGridList[0].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Our_products.name) {
          faqGridList[1].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Program_Based.name) {
          faqGridList[2].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Meals_Recipe.name) {
          faqGridList[3].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Food_Prescription.name) {
          faqGridList[4].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Post_Program.name) {
          faqGridList[5].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Medicines_Supplements.name) {
          faqGridList[6].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Challenges_and_Adherence.name) {
          faqGridList[7].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Program_Outcomes.name) {
          faqGridList[8].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Yoga.name) {
          faqGridList[9].faqList!.add(FaqList.fromJson(element.toJson()));
        } else if (element.faqType == FaqTypes.Calm.name) {
          faqGridList[10].faqList!.add(FaqList.fromJson(element.toJson()));
        }
      });

      print("faqList: ${faqGridList[1].faqList}");
    }
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar(() {
                    Navigator.pop(context);
                  }),
                  //SizedBox(height: 1.h),
                  showLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.h),
                          child: buildCircularIndicator(),
                        )
                      : showGrids()
                  // buildExpansionTiles(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showGrids() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: Text(
              "How Can We Help You ?",
              style: TextStyle(
                  fontFamily: kFontBold,
                  color: gBlackColor,
                  fontSize: eUser().mainHeadingFontSize),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        buildSearchWidget(),
        SizedBox(height: 3.h),
        searchController.text.isNotEmpty ? buildSearchList() : buildGrids(),
      ],
    );
  }

  buildSearchWidget() {
    return Center(
      child: Container(
        width: 50.w,
        height: 6.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          // border: Border.all(color: gHintTextColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),),
                color: gsecondaryColor,
              ),
              child: Icon(
                Icons.search,
                color: gWhiteColor,
                size: 2.5.h,
              ),
            ),
            Expanded(
              child: Padding(padding: EdgeInsets.only(top: 1.h),
                child: TextFormField(

                  controller: searchController,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    // prefixIconConstraints: BoxConstraints.tight(Size.square(30)),
                    // prefixIcon: IntrinsicWidth(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(6),
                    //           bottomLeft: Radius.circular(6)
                    //       ),
                    //       color: gsecondaryColor,
                    //     ),
                    //     child: Icon(
                    //       Icons.search,
                    //       color: gWhiteColor,
                    //       size: 14.sp,
                    //     ),
                    //   ),
                    // ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          searchController.clear();
                          searchedFAQResults.clear();
                        });
                      },
                      child: Padding(
                        padding:  EdgeInsets.only(bottom: 1.h),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: gBlackColor,
                          size: 2.5.h,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 20),
                    hintText: "Search...",
                    // suffixIcon: searchController.text.isNotEmpty
                    //     ? GestureDetector(
                    //         child:
                    //             Icon(Icons.close_outlined, size: 2.h, color: gBlackColor),
                    //         onTap: () {
                    //           searchController.clearComposing();
                    //           FocusScope.of(context).requestFocus(FocusNode());
                    //         },
                    //       )
                    //     : null,
                    hintStyle: TextStyle(
                      fontFamily: kFontBook,
                      color: gBlackColor,
                      fontSize: 11.sp,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                      fontFamily: "GothamBook",
                      color: gBlackColor,
                      fontSize: 13.sp),
                  onChanged: (value) {
                    onSearchTextChanged(value);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
    return Center(
      child: Container(
        width: 50.w,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          // border: Border.all(color: gHintTextColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 2,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
        child: TextFormField(
          controller: searchController,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            prefixIconConstraints: BoxConstraints.tight(Size.square(30)),
            prefixIcon: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6)),
                  color: gsecondaryColor,
                ),
                child: Icon(
                  Icons.search,
                  color: gWhiteColor,
                  size: 14.sp,
                ),
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  searchController.clear();
                  searchedFAQResults.clear();
                });
              },
              child: Icon(
                Icons.cancel_outlined,
                color: gBlackColor,
                size: 14.sp,
              ),
            ),
            contentPadding: EdgeInsets.only(left: 20),
            hintText: "Search...",
            // suffixIcon: searchController.text.isNotEmpty
            //     ? GestureDetector(
            //         child:
            //             Icon(Icons.close_outlined, size: 2.h, color: gBlackColor),
            //         onTap: () {
            //           searchController.clearComposing();
            //           FocusScope.of(context).requestFocus(FocusNode());
            //         },
            //       )
            //     : null,
            hintStyle: TextStyle(
              fontFamily: kFontBook,
              color: gBlackColor,
              fontSize: 9.sp,
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
              fontFamily: "GothamBook", color: gBlackColor, fontSize: 11.sp),
          onChanged: (value) {
            onSearchTextChanged(value);
          },
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    searchedFAQResults.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }
    // faq?.forEach((userDetail) {
    //   if (userDetail.questions!
    //       .toLowerCase()
    //       .contains(text.trim().toLowerCase())) {
    //     searchFAQResults.add(userDetail);
    //   }
    // });

    if (fullFaq != null || fullFaq.isNotEmpty) {
      for (var details in fullFaq) {
        print(details.question);
        print(text.trim());
        if (details.question!
            .toLowerCase()
            .contains(text.trim().toLowerCase())) {
          if (searchedFAQResults.isNotEmpty) {
            if (!searchedFAQResults.contains(details)) {
              searchedFAQResults.add(details);
            }
          } else {
            searchedFAQResults.add(details);
          }
        }
      }
    }
    setState(() {});
  }

  buildSearchList() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: kLineColor,
              blurRadius: 2,
              offset: const Offset(0.9, 1.5),
            ),
          ],
        ),
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchedFAQResults.length,
              itemBuilder: ((context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        goto(searchedFAQResults[index]);
                      },
                      child: Text(
                        searchedFAQResults[index].question ?? "",
                        style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gBlackColor,
                            fontSize: 14.sp),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  buildGrids() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 30,
          crossAxisSpacing: 15,
          crossAxisCount: 4,
          // mainAxisExtent: 20.h,
          // childAspectRatio: MediaQuery.of(context).size.width /
          //     (MediaQuery.of(context).size.height / 1.4),
        ),
        itemCount: faqGridList.length,
        itemBuilder: (context, index) {
          return gridTile(faqGridList[index]);
        });
  }

  buildQuestionsOld(FAQ faq, int index) {
    return GestureDetector(
      onTap: () {
        // goto(faq);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.questions,
            style: TextStyle(
              color: gTextColor,
              fontFamily: kFontMedium,
              fontSize: 9.sp,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            height: 1,
            color: Colors.grey.withOpacity(0.4),
          ),
          SizedBox(height: 1.5.h)
        ],
      ),
    );
  }

  buildExpansionTiles() {
    return FutureBuilder(
        future: faqFuture,
        builder: (_, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.hasError);
            print(snapshot.hasData);
            if (snapshot.hasData) {
              print(snapshot.data.runtimeType);
              if (snapshot.data.runtimeType is ErrorModel) {
                ErrorModel model = snapshot.data as ErrorModel;
                return Center(
                  child: Text(model.message ?? ''),
                );
              } else {
                print("else");
                FaqListModel model = snapshot.data as FaqListModel;
                fullFaq.addAll(model.faqList!);
                return Column(
                  children: [
                    searchController.text.isNotEmpty
                        ? buildSearchList()
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                generalQueries(model),
                                mealPlanQueries(model),
                                yogaPlanQueries(model),
                                symptomQueries(model),
                              ],
                            ),
                          )
                  ],
                );
                model.faqList?.map((e) {
                  return buildQuestionsNew(e);
                }).toList();
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString() ?? ''),
              );
            }
          }
          return buildCircularIndicator();
        });
  }

  generalQueries(FaqListModel que) {
    return ExpansionTile(
      title: Text(
        "General Queries",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12.sp,
          fontFamily: "GothamMedium",
        ),
      ),
      // leading: Image(
      //   image: AssetImage("assets/images/Group 2747.png"),
      // ),
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: que.faqList?.length,
            itemBuilder: (_, index) {
              // print("Type: ${model.faqList![index].faqType}");
              if (que.faqList![index].faqType == "general") {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: buildMenuItem(
                    onClicked: () {
                      goto(que.faqList![index]);
                    },
                    text: "${que.faqList![index].question}",
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }

  mealPlanQueries(FaqListModel que) {
    return ExpansionTile(
      title: Text(
        "Meal Plan Queries",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12.sp,
          fontFamily: kFontMedium,
        ),
      ),
      // leading: Image(
      //   image: AssetImage("assets/images/Group 2747.png"),
      // ),
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: que.faqList?.length,
            itemBuilder: (_, index) {
              // print("Type: ${model.faqList![index].faqType}");
              if (que.faqList![index].faqType == "meal") {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: buildMenuItem(
                    onClicked: () {
                      goto(que.faqList![index]);
                    },
                    text: "${que.faqList![index].question}",
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }

  yogaPlanQueries(FaqListModel que) {
    return ExpansionTile(
      title: Text(
        "Yoga Plan Queries",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12.sp,
          fontFamily: "GothamMedium",
        ),
      ),
      // leading: Image(
      //   image: AssetImage("assets/images/Group 2747.png"),
      // ),
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: que.faqList?.length,
            itemBuilder: (_, index) {
              // print("Type: ${model.faqList![index].faqType}");
              if (que.faqList![index].faqType == "yoga") {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: buildMenuItem(
                    onClicked: () {
                      goto(que.faqList![index]);
                    },
                    text: "${que.faqList![index].question}",
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }

  symptomQueries(FaqListModel que) {
    return ExpansionTile(
      title: Text(
        "Symptom Queries",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12.sp,
          fontFamily: "GothamMedium",
        ),
      ),
      // leading: Image(
      //   image: AssetImage("assets/images/Group 2747.png"),
      // ),
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: que.faqList?.length,
            itemBuilder: (_, index) {
              // print("Type: ${model.faqList![index].faqType}");
              if (que.faqList![index].faqType == "symptom") {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: buildMenuItem(
                    onClicked: () {
                      goto(que.faqList![index]);
                    },
                    text: "${que.faqList![index].question}",
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }

  Widget buildMenuItem({
    required String text,
    VoidCallback? onClicked,
  }) {
    const color = kPrimaryColor;
    const hoverColor = Colors.grey;

    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontFamily: eUser().userTextFieldFont,
          color: eUser().userTextFieldColor,
          fontSize: eUser().userTextFieldFontSize,
        ),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  goto(FaqList faq) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => FaqAnswerScreen(
                  faqList: faq,
                  // question: faq.questions,
                  // icon: faq.path,
                  // answer: faq.answers
                )));
  }

  newDesignUI(BuildContext context) {
    return FutureBuilder(
        future: faqFuture,
        builder: (_, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.hasError);
            print(snapshot.hasData);
            if (snapshot.hasData) {
              print(snapshot.data.runtimeType);
              if (snapshot.data.runtimeType is ErrorModel) {
                ErrorModel model = snapshot.data as ErrorModel;
                return Center(
                  child: Text(model.message ?? ''),
                );
              } else {
                print("else");
                FaqListModel model = snapshot.data as FaqListModel;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.faqList?.length ?? 0,
                    itemBuilder: (_, index) {
                      return buildQuestionsNew(model.faqList![index]);
                    });
                model.faqList?.map((e) {
                  return buildQuestionsNew(e);
                }).toList();
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString() ?? ''),
              );
            }
          } else {
            return buildCircularIndicator();
          }
          return buildCircularIndicator();
        });
  }

  buildQuestionsNew(FaqList faq) {
    return GestureDetector(
      onTap: () {
        goto(faq);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.question ?? '',
            style: TextStyle(
              color: gTextColor,
              fontFamily: kFontMedium,
              fontSize: 9.sp,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            height: 1,
            color: Colors.grey.withOpacity(0.4),
          ),
          SizedBox(height: 1.5.h)
        ],
      ),
    );
  }

  SettingsRepository repo =
      SettingsRepository(apiClient: ApiClient(httpClient: http.Client()));

  goToScreen(screenName) {
    print(screenName);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screenName,
        // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
      ),
    );
  }

  gridTile(GridTileItems items) {
    return InkWell(
      onTap: () {
        goToScreen(FaqDetailedList(
          faqList: items.faqList,
        ));
        // switch(items.id){
        //   case 0:
        //     print(items.faqList);
        //     goToScreen(FaqDetailedList(faqList: items.faqList,));
        //     break;
        //   case 1:
        //     items.faqList!.forEach((element) {
        //       print("${element.question}");
        //     });
        //     goToScreen(FaqDetailedList(faqList: items.faqList,));
        //     break;
        //   case 2:
        //     goToScreen(FaqDetailedList(faqList: items.faqList,));
        //     break;
        //   case 3:
        //     goToScreen(FaqDetailedList(faqList: items.faqList,));
        //     break;
        //   case 4:
        //     goToScreen(FaqDetailedList(faqList: items.faqList,));
        //     break;
        //   case 5:
        //     goToScreen(FaqDetailedList(faqList: items.faqList,));
        //     break;
        //   case 5:
        //     goToScreen(FaqDetailedList(faqList: items.faqList,));
        //     break;
        //   case 5:
        //     goToScreen(FaqDetailedList(faqList: items.faqList,));
        //     break;
        // }
      },
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: kLineColor,
                blurRadius: 2,
                offset: const Offset(0.9, 1.5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Center(
                    child: Image.asset(
                  items.assetImage,
                  color: kLineColor,
                  fit: BoxFit.scaleDown,
                )),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    items.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: kFontMedium, fontSize: 14.sp),
                  ),
                ),
              )
            ],
          )),
    );
  }

}

class GridTileItems {
  int id;
  String name;
  String assetImage;
  List<FaqList>? faqList;
  GridTileItems(this.id, this.name, this.assetImage, {this.faqList});
}

class FAQ {
  String? heading;
  String questions;
  String path;
  String answers;

  FAQ(this.questions, this.path, this.answers, this.heading);
}

///food_prescription
///medicines  not added
enum FaqTypes {
  Consultation,
  Our_products,
  Program_Based,
  Meals_Recipe,
  Food_Prescription,
  Post_Program,
  Medicines_Supplements,
  Challenges_and_Adherence,
  Program_Outcomes,
  Yoga,
  Calm
}
