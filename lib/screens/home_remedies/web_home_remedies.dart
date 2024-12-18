import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gwc_customer_web/model/home_remedy_model/home_remedies_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/services/home_remedy_service/home_remedies_service.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/error_model.dart';
import '../../repository/home_remedies_repository/home_remedies_repository.dart';
import '../combined_meal_plan/video_player/yoga_video_screen.dart';
import 'new_know_more_screen.dart';

class WebHomeRemedies extends StatefulWidget {
  const WebHomeRemedies({Key? key}) : super(key: key);

  @override
  State<WebHomeRemedies> createState() => _WebHomeRemediesState();
}

class _WebHomeRemediesState extends State<WebHomeRemedies>
    with SingleTickerProviderStateMixin {
  HomeRemediesService? homeRemediesService;
  TabController? _tabController;

  List<HomeRemedy> allList = [];
  List<HomeRemedy> generalList = [];
  List<HomeRemedy> phaseList = [];

  HomeRemedy? selectedRemedies;

  @override
  void initState() {
    super.initState();
    getRemediesList();
    loadAsset('placeholder.png');
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  bool isLoading = false;

  getRemediesList() async {
    setState(() {
      isLoading = true;
    });
    final result = await HomeRemediesService(repository: repository)
        .getHomeRemediesService();
    print("result: $result");

    if (result.runtimeType == HomeRemediesModel) {
      print("Ticket List");
      HomeRemediesModel model = result as HomeRemediesModel;

      allList = model.data.homeRemedies;

      for (var e in model.data.homeRemedies) {
        if (e.isGeneral == "0") {
          generalList.add(e);
          setState(() {
            selectedRemedies = generalList.first;
          });
        } else {
          phaseList.add(e);
        }
      }
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

  ByteData? placeHolderImage;

  void loadAsset(String name) async {
    var data = await rootBundle.load('assets/images/$name');
    setState(() => placeHolderImage = data);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Icon searchIcon = Icon(
    Icons.search,
    color: gBlackColor,
    size: 2.5.h,
  );

  bool searchItem = false;
  Widget searchBarTitle = const Text('');

  Widget searchBarTitle1 = const Text('');

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    searchBarTitle = searchItem ? buildSearchWidget(allList) : const SizedBox();

    return MediaQuery.of(context).size.shortestSide < 600 ? mobileHomeScreen() : Scaffold(
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
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 2.h, horizontal: 1.5.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 2.h),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildAppBar(() {
                            Navigator.pop(context);
                          },
                              showLogo: false,
                              showChild: true,
                              customAction: true,
                              child: Text(
                                "Home Remedies",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: kFontBold,
                                  color: gBlackColor,
                                  fontSize: 14.dp,
                                ),
                              ),
                              actions: [
                                searchBarTitle,
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (searchIcon.icon == Icons.search) {
                                        searchIcon = Icon(
                                          Icons.close,
                                          color: gBlackColor,
                                          size: 2.5.h,
                                        );
                                        searchItem = true;
                                      } else {
                                        searchIcon = Icon(
                                          Icons.search,
                                          color: gBlackColor,
                                          size: 2.5.h,
                                        );
                                        searchItem = false;
                                        searchController.clear();
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: gWhiteColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(2, 3),
                                        ),
                                      ],
                                    ),
                                    child: searchIcon,
                                  ),
                                ),
                              ],
                          ),
                          SizedBox(height: 4.h),
                          if (searchController.text.isEmpty) Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TabBar(
                                        unselectedLabelColor: gBlackColor,
                                        labelColor: gBlackColor,
                                        controller: _tabController,
                                        dividerColor: Colors.transparent,
                                        // isScrollable: true,
                                        // tabAlignment: TabAlignment.start,
                                        unselectedLabelStyle: TextStyle(
                                            fontFamily: kFontBook,
                                            color: gHintTextColor,
                                            fontSize: 11.dp),
                                        labelStyle: TextStyle(
                                            fontFamily: kFontMedium,
                                            color: gBlackColor,
                                            fontSize: 13.dp),
                                        indicatorColor:
                                            newDashboardGreenButtonColor
                                                .withOpacity(0.5),
                                        labelPadding: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        indicatorPadding: EdgeInsets.only(
                                            left: -2.w,
                                            right: -2.w,
                                            top: -1.h,
                                            bottom: -1.h),
                                        indicator: BoxDecoration(
                                          color: newDashboardGreenButtonColor
                                              .withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        tabs: const [
                                          Text('General'),
                                          Text("Program Phase Remedies"),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: gWhiteColor,
                                          margin: EdgeInsets.only(top: 02.h),
                                          child: TabBarView(
                                            controller: _tabController,
                                            children: [
                                              buildGeneralProblems(generalList),
                                              buildGeneralProblems(phaseList),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ) else Expanded(
                                  child: SingleChildScrollView(
                                    child: buildGeneralProblems(searchResults),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
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
                      child: DefaultTabController(
                        length: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 2.h),
                              TabBar(
                                // padding: EdgeInsets.symmetric(horizontal: 3.w),
                                labelColor: gBlackColor,
                                unselectedLabelColor: gHintTextColor,
                                isScrollable: true,
                                indicatorColor: gsecondaryColor,
                                labelPadding: EdgeInsets.only(
                                    right: 8.w, top: 1.h, bottom: 1.h),
                                // indicatorPadding: EdgeInsets.only(right: 5.w),
                                unselectedLabelStyle: TextStyle(
                                    fontFamily: kFontBook,
                                    color: gHintTextColor,
                                    fontSize: 12.dp),
                                labelStyle: TextStyle(
                                    fontFamily: kFontMedium,
                                    color: gBlackColor,
                                    fontSize: 15.dp),
                                tabs: const [
                                  Text('Know More'),
                                  Text("Heal At Home"),
                                  // Text('Heal Anywhere'),
                                  Text("When To Reach Us?"),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 2.h),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    color: gsecondaryColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    selectedRemedies?.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: eUser().mainHeadingFont,
                                        color: eUser().buttonTextColor,
                                        fontSize: eUser().mainHeadingFontSize),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    buildZoomImage(
                                      // 'https://gutandhealth.com/storage/uploads/users/yoga_videos/Acidity calm.mp4',
                                      selectedRemedies?.knowMore ?? '',
                                    ),
                                    buildZoomImage(
                                        selectedRemedies?.healAtHome ?? ''),
                                    // buildHealAnywhereDetails(),
                                    buildZoomImage(
                                        selectedRemedies?.whenToReachUs ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildSearchWidget(
    List<HomeRemedy> allList,
  ) {
    return StatefulBuilder(builder: (_, setstate) {
      return Container(
        height: 6.h,
        width: MediaQuery.of(context).size.shortestSide < 600 ? 30.w : 15.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          border: Border.all(color: gGreyColor.withOpacity(0.3), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: gGreyColor.withOpacity(0.3),
              blurRadius: 2,
            ),
          ],
        ),
        //padding: EdgeInsets.symmetric(horizontal: 2.w),
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: Center(
          child: TextFormField(
            // textAlignVertical: TextAlignVertical.center,
            controller: searchController,
            autofocus: true,
            cursorColor: gBlackColor,
            cursorHeight: 2.h,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: gBlackColor,
                size: 2.5.h,
              ),
              hintText: "Search...",
              suffixIcon: searchController.text.isNotEmpty
                  ? GestureDetector(
                      child: Icon(Icons.close_outlined,
                          size: 2.h, color: gBlackColor),
                      onTap: () {
                        searchController.clear();
                        setstate(() {});
                      },
                    )
                  : null,
              hintStyle: TextStyle(
                  fontSize: 12.dp,
                  color: gHintTextColor,
                  fontFamily: kFontBook),
              border: InputBorder.none,
            ),
            style: TextStyle(
                fontSize: 14.dp, color: gTextColor, fontFamily: kFontMedium),
            onChanged: (value) {
              onSearchTextChanged(value, allList);
            },
          ),
        ),
      );
    });
  }

  List<HomeRemedy> searchResults = [];

  onSearchTextChanged(String text, List<HomeRemedy> webList) async {
    searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    print("searchResults pending : $webList");

    for (var userDetail in webList) {
      if (userDetail.name.toLowerCase().contains(text.toLowerCase())) {
        print("searchResults : $userDetail");
        searchResults.add(userDetail);
      }
    }
    print("searchResults : $searchResults");
    setState(() {});
  }

  buildGeneralProblems(List<HomeRemedy> lst) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 4.h, left: 3.w, right: 3.w, bottom: 2.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 25,
        crossAxisSpacing: 25,
        crossAxisCount: 3,
        mainAxisExtent: 20.h,
      ),
      itemCount: lst.length,
      itemBuilder: (context, index) {
        return showRemedies(lst[index]);
      },
    );
  }

  showRemedies(HomeRemedy details) {
    bool isSelected = selectedRemedies == details;

    print("Thumbnail : ${details.thumbnail}");

    return GestureDetector(
      onTap: MediaQuery.of(context).size.shortestSide < 600 ? () {
        Get.to(
              () => NewKnowMoreScreen(
            knowMore: details.knowMore,
            healAtHome: details.healAtHome,
            healAnywhere: details.healAnywhere,
            whenToReachUs:
            details.whenToReachUs,
            title: details.name.toString(),
          ),
        );
      } : () {
        setState(() {
          selectedRemedies = details;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? gsecondaryColor : gWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: gBlackColor.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 13.h,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: gsecondaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Image(
                  image: NetworkImage(details.thumbnail),
                ),
                // ImageNetwork(
                //   image: details.thumbnail,
                //   height: 15.h,
                //   width: 12.w,
                //   fitAndroidIos: BoxFit.contain,
                //   fitWeb: BoxFitWeb.contain,
                //   onLoading: const CircularProgressIndicator(
                //     color: Colors.indigoAccent,
                //   ),
                //   onError: Image.asset("assets/images/placeholder.png"),
                //   onTap: () {
                //     setState(() {
                //       selectedRemedies = details;
                //     });
                //   },
                // ),
              ),
            ),
            SizedBox(height: 1.5.h),
            Text(
              details.name.toString(),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kFontBold,
                color: isSelected ? gWhiteColor : gBlackColor,
                fontSize: 12.dp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildZoomImage(String knowMore) {
    final file = knowMore.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      return Padding(
        padding: EdgeInsets.only(bottom: 2.h, top: 2.h),
        child: YogaVideoPlayer(
          videoUrl: knowMore,
          heading: '',
          isRemedies: true,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 2.h, top: 2.h),
        child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: Image(
            image: NetworkImage(knowMore),
          ),
        ),
      );
    }
  }

  /// mobile screen size
  mobileHomeScreen(){
    searchBarTitle = searchItem ? buildSearchWidget(allList) : const SizedBox();

    return Scaffold(
      backgroundColor: gWhiteColor,
      body: SafeArea(
        child: (isLoading)
            ? Center(
          child: buildCircularIndicator(),
        )
            : Padding(
          padding: EdgeInsets.only(left: 3.w,right: 3.w,top: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              },
                showLogo: false,
                showChild: true,
                customAction: true,
                child: Text(
                  "Home Remedies",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: kFontBold,
                    color: gBlackColor,
                    fontSize: 14.dp,
                  ),
                ),
                actions: [
                  searchBarTitle,
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (searchIcon.icon == Icons.search) {
                          searchIcon = Icon(
                            Icons.close,
                            color: gBlackColor,
                            size: 2.5.h,
                          );
                          searchItem = true;
                        } else {
                          searchIcon = Icon(
                            Icons.search,
                            color: gBlackColor,
                            size: 2.5.h,
                          );
                          searchItem = false;
                          searchController.clear();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: searchIcon,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              if (searchController.text.isEmpty) Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      unselectedLabelColor: gBlackColor,
                      labelColor: gBlackColor,
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      // isScrollable: true,
                      // tabAlignment: TabAlignment.start,
                      unselectedLabelStyle: TextStyle(
                          fontFamily: kFontBook,
                          color: gHintTextColor,
                          fontSize: 11.dp),
                      labelStyle: TextStyle(
                          fontFamily: kFontMedium,
                          color: gBlackColor,
                          fontSize: 13.dp),
                      indicatorColor:
                      newDashboardGreenButtonColor
                          .withOpacity(0.5),
                      labelPadding: EdgeInsets.symmetric(
                          horizontal: 1.w),
                      indicatorPadding: EdgeInsets.only(
                          left: -2.w,
                          right: -2.w,
                          top: -1.h,
                          bottom: -1.h),
                      indicator: BoxDecoration(
                        color: newDashboardGreenButtonColor
                            .withOpacity(0.5),
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                      tabs: const [
                        Text('General'),
                        Text("Program Phase Remedies"),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: gWhiteColor,
                        margin: EdgeInsets.only(top: 02.h),
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            buildGeneralProblems(generalList),
                            buildGeneralProblems(phaseList),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ) else Expanded(
                child: SingleChildScrollView(
                  child: buildGeneralProblems(searchResults),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  final HomeRemediesRepository repository = HomeRemediesRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
