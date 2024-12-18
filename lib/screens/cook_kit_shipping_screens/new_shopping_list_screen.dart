import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:http/http.dart' as http;
import '../../model/ship_track_model/shopping_model/child_get_shopping_model.dart';
import '../../model/ship_track_model/shopping_model/get_shopping_model.dart';
import '../../repository/api_service.dart';
import '../../repository/shipping_repository/ship_track_repo.dart';
import '../../services/shipping_service/ship_track_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/widgets.dart';

class NewShoppingListScreen extends StatefulWidget {
  const NewShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<NewShoppingListScreen> createState() => _NewShoppingListScreenState();
}

class _NewShoppingListScreenState extends State<NewShoppingListScreen>
    with SingleTickerProviderStateMixin {
  // TabController? _tabController;

  Map<String, List<ChildGetShoppingModel>> shoppingList = {};
  int shoppingTapLength = 0;

  @override
  void initState() {
    super.initState();
    getShoppingList();
  }

  bool showShoppingLoading = false;
  bool isFetchError = false;

  getShoppingList() async {
    setState(() {
      showShoppingLoading = true;
    });

    final result = await ShipTrackService(repository: repository)
        .getShoppingDetailsListService();

    print(result.runtimeType);
    if (result.runtimeType == GetShoppingListModel) {
      print("Shopping List");
      GetShoppingListModel model = result as GetShoppingListModel;
      shoppingList = model.ingredients!;
      shoppingTapLength = shoppingList.entries.length;

      selectedCategory = shoppingList.keys.first;

      // _tabController = TabController(length: shoppingTapLength, vsync: this);
      setState(() {
        showShoppingLoading = false;
      });
    } else {
      setState(() {
        showShoppingLoading = false;
        isFetchError = true;
      });
    }
  }

  @override
  void dispose() {
    // _tabController?.dispose();
    super.dispose();
  }

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
      body: SafeArea(
        child: MediaQuery.of(context).size.shortestSide > 600
            ? buildWebView()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAppBar(
                      () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Text(
                        "Shopping",
                        style: TextStyle(
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                            fontSize: 15.dp),
                      ),
                    ),
                    Expanded(
                      child: (showShoppingLoading)
                          ? buildCircularIndicator()
                          : (shoppingList.isNotEmpty)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Used For : ",
                                      style: TextStyle(
                                        fontFamily: kFontMedium,
                                        color: gTextColor,
                                        fontSize: 12.dp,
                                      ),
                                    ),
                                    buildItemList(),
                                    Expanded(
                                      child: selectedCategory != null
                                          ? shoppingUi(
                                              shoppingList[selectedCategory]!)
                                          : const Center(
                                              child: Text(
                                                  'Select a category to see items'),
                                            ),
                                    ),
                                    // Expanded(
                                    //   child: TabBarView(
                                    //     controller: _tabController,
                                    //     children: [
                                    //       ...shoppingList.values.map((e) {
                                    //         return shoppingUi(e);
                                    //       }).toList(),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                )
                              : noData(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  buildItemList() {
    return SizedBox(
      height: 10.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shoppingList.keys.length,
        itemBuilder: (context, index) {
          String category = shoppingList.keys.elementAt(index);
          return GestureDetector(
            onTap: () {
              setState(() {
                // Update the selected category on tap
                selectedCategory = category;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                // color: selectedCategory == category
                //     ? gsecondaryColor : gWhiteColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: selectedCategory == category
                      ? [
                          gsecondaryColor.withOpacity(0.3),
                          gsecondaryColor.withOpacity(0.5),
                        ]
                      : [
                          gWhiteColor,
                          gWhiteColor,
                        ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: gGreyColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: selectedCategory == category
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    //   SizedBox(
    //   height: 10.h,
    //   child: TabBar(
    //     isScrollable: true,
    //     tabAlignment: TabAlignment.start,
    //     controller: _tabController,
    //     dividerColor: Colors.transparent,
    //     unselectedLabelStyle: TextStyle(
    //         fontFamily: kFontBook, color: gHintTextColor, fontSize: 13.dp),
    //     labelStyle: TextStyle(
    //         fontFamily: kFontMedium, color: gWhiteColor, fontSize: 15.dp),
    //     labelPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
    //     indicatorPadding: EdgeInsets.symmetric(horizontal: -4.w, vertical: 1.h),
    //     indicator: BoxDecoration(
    //       color: gsecondaryColor,
    //       borderRadius: BorderRadius.circular(10),
    //       boxShadow: [
    //         BoxShadow(
    //           color: gGreyColor.withOpacity(0.3),
    //           blurRadius: 6,
    //           offset: const Offset(2, 4),
    //         ),
    //       ],
    //     ),
    //     onTap: (index) {
    //       print("ontap: $index");
    //       // _buildList(index);
    //     },
    //     tabs: shoppingList.keys.map((e) {
    //       return Tab(
    //         child: Text(e),
    //       );
    //     }).toList(),
    //   ),
    // );
  }

  shoppingUi(List<ChildGetShoppingModel> shoppingItem) {
    if (shoppingItem.isNotEmpty) {
      return buildShippingList(shoppingItem);
      // return tableView();
    } else {
      return noData();
    }
  }

  // final carouselController = CarouselController();
  // int _current = 0;

  // buildItems(List<ChildGetShoppingModel> shoppingItem) {
  //   return Column(
  //     children: [
  //       Container(
  //         height: 40.h,
  //         margin: EdgeInsets.symmetric(vertical: 4.h),
  //         width: double.maxFinite,
  //         child: CarouselSlider(
  //           carouselController: carouselController,
  //           options: CarouselOptions(
  //               viewportFraction: .4,
  //               aspectRatio: 1.8,
  //               enableInfiniteScroll: false,
  //               enlargeCenterPage: true,
  //               disableCenter: true,
  //               scrollDirection: Axis.vertical,
  //               autoPlay: false,
  //               pageSnapping: false,
  //               onPageChanged: (index, reason) {
  //                 setState(() {
  //                   _current = index;
  //                 });
  //               }),
  //           items: shoppingItem
  //               .map(
  //                 (e) => InkWell(
  //                   onTap: () {},
  //                   child: Container(
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
  //                     margin: EdgeInsets.symmetric(vertical: 2.h),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(15),
  //                       color: gWhiteColor,
  //                       // border: Border.all(
  //                       //     color: eUser().buttonBorderColor,
  //                       //     width: eUser().buttonBorderWidth
  //                       // ),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.3),
  //                           blurRadius: 10,
  //                           offset: const Offset(4, 5),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Center(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             height: 20.h,
  //                             padding: const EdgeInsets.all(5),
  //                             decoration: const BoxDecoration(
  //                               color: profileBackGroundColor,
  //                               shape: BoxShape.circle,
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.black12,
  //                                   blurRadius: 10,
  //                                   spreadRadius: 2,
  //                                 ),
  //                               ],
  //                             ),
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 image: DecorationImage(
  //                                   image: NetworkImage(
  //                                     e.thumbnail.toString(),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           // Padding(
  //                           //   padding: EdgeInsets.symmetric(vertical: 1.h),
  //                           //   child: ImageNetwork(
  //                           //     image: shoppingItem[index].thumbnail.toString(),
  //                           //     height: 100,
  //                           //     width: 100,
  //                           //     duration: 1500,
  //                           //     curve: Curves.easeIn,
  //                           //     onPointer: true,
  //                           //     debugPrint: false,
  //                           //     fullScreen: false,
  //                           //     fitAndroidIos: BoxFit.cover,
  //                           //     fitWeb: BoxFitWeb.contain,
  //                           //     borderRadius: BorderRadius.circular(10),
  //                           //     onLoading: const CircularProgressIndicator(
  //                           //       color: Colors.indigoAccent,
  //                           //     ),
  //                           //     onError: const Icon(
  //                           //       Icons.error,
  //                           //       color: Colors.red,
  //                           //     ),
  //                           //     onTap: () {
  //                           //       debugPrint("©gabriel_patrick_souza");
  //                           //     },
  //                           //   ),
  //                           // ),
  //                           SizedBox(height: 3.h),
  //                           Text(
  //                             "${e.name}",
  //                             style: TextStyle(
  //                               fontFamily: kFontMedium,
  //                               color: gTextColor,
  //                               fontSize: 12.dp,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //               .toList(),
  //         ),
  //       ),
  //       // SizedBox(height: 2.h),
  //       // Row(
  //       //   mainAxisAlignment: MainAxisAlignment.center,
  //       //   children: shoppingItem.map((url) {
  //       //     int index = shoppingItem.indexOf(url);
  //       //     return Container(
  //       //       width: 8.0,
  //       //       height: 8.0,
  //       //       margin:
  //       //           const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
  //       //       decoration: BoxDecoration(
  //       //         shape: BoxShape.circle,
  //       //         color: _current == index
  //       //             ? gsecondaryColor
  //       //             : kNumberCircleRed.withOpacity(0.3),
  //       //       ),
  //       //     );
  //       //   }).toList(),
  //       // ),
  //     ],
  //   );
  // }

  buildShippingList(List<ChildGetShoppingModel> shoppingItem) {
    return Padding(
      padding: EdgeInsets.only(left: 0.w, top: 5.h, right: 0.w),
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 20,
            crossAxisSpacing: 0,
            crossAxisCount:
                MediaQuery.of(context).size.shortestSide > 600 ? 3 : 2,
            mainAxisExtent: 35.h,
            // childAspectRatio: MediaQuery.of(context).size.width /
            //     (MediaQuery.of(context).size.height / 1.4),
          ),
          // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemCount: shoppingItem.length,
          itemBuilder: (context, index) {
            print("image : ${shoppingItem[index].thumbnail}");
            return InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: gWhiteColor,
                  // border: Border.all(
                  //     color: eUser().buttonBorderColor,
                  //     width: eUser().buttonBorderWidth
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(4, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 20.h,
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: profileBackGroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              shoppingItem[index].thumbnail.toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 1.h),
                    //   child: ImageNetwork(
                    //     image: shoppingItem[index].thumbnail.toString(),
                    //     height: 100,
                    //     width: 100,
                    //     duration: 1500,
                    //     curve: Curves.easeIn,
                    //     onPointer: true,
                    //     debugPrint: false,
                    //     fullScreen: false,
                    //     fitAndroidIos: BoxFit.cover,
                    //     fitWeb: BoxFitWeb.contain,
                    //     borderRadius: BorderRadius.circular(10),
                    //     onLoading: const CircularProgressIndicator(
                    //       color: Colors.indigoAccent,
                    //     ),
                    //     onError: const Icon(
                    //       Icons.error,
                    //       color: Colors.red,
                    //     ),
                    //     onTap: () {
                    //       debugPrint("©gabriel_patrick_souza");
                    //     },
                    //   ),
                    // ),
                    SizedBox(height: 2.h),
                    Text(
                      "${shoppingItem[index].name}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gTextColor,
                        fontSize: 12.dp,
                      ),
                    ),
                  ],
                ),
              ),
            );
            //   Container(
            //   padding: EdgeInsets.symmetric(vertical: 2.h),
            //   decoration: BoxDecoration(
            //     color: gWhiteColor,
            //     borderRadius: BorderRadius.circular(10),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.3),
            //         blurRadius: 5,
            //         offset: const Offset(3, 8),
            //       ),
            //     ],
            //   ),
            //   child: Column(mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Container(color: gsecondaryColor,
            //         child: ImageNetwork(
            //           image: shoppingItem[index].thumbnail.toString(),
            //           height: 15.h,
            //           width: 30.w,
            //           fitAndroidIos: BoxFit.contain,
            //           fitWeb: BoxFitWeb.contain,
            //           onLoading: const CircularProgressIndicator(
            //             color: Colors.indigoAccent,
            //           ),
            //           onError: Image.asset(
            //               "assets/images/placeholder.png"),
            //           onTap: () {
            //             debugPrint("©gabriel_patrick_souza");
            //           },
            //         ),
            //       ),
            //       SizedBox(height: 1.5.h),
            //       Text(
            //         "${shoppingItem[index].name}",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 13.dp,
            //           fontFamily: "GothamMedium",
            //           color: gTextColor,
            //         ),
            //       ),
            //       // SizedBox(height: 0.5.h),
            //       // Padding(
            //       //   padding: EdgeInsets.only(left: 5.w),
            //       //   child: RichText(
            //       //     textAlign: TextAlign.center,
            //       //     text: TextSpan(children: [
            //       //       TextSpan(
            //       //         text: "Used for : ",
            //       //         style: TextStyle(
            //       //           fontFamily: kFontBook,
            //       //           color: gHintTextColor,
            //       //           fontSize: 8.sp,
            //       //         ),
            //       //       ),
            //       //       TextSpan(
            //       //         text:
            //       //             "${shoppingList[index].ingredients?.childIngredientCategory?.name}",
            //       //         style: TextStyle(
            //       //           fontFamily: "GothamMedium",
            //       //           color: gHintTextColor,
            //       //           fontSize: 8.sp,
            //       //         ),
            //       //       ),
            //       //     ]),
            //       //   ),
            //       // ),
            //       // Center(
            //       //   child: Row(
            //       //     children: [
            //       //       Text(
            //       //         "Used for : ",
            //       //         style: TextStyle(
            //       //             fontFamily: "GothamMedium",
            //       //             color: gTextColor,
            //       //             fontSize: 8.sp),
            //       //       ),
            //       //       Text(
            //       //         "${shoppingList[index].ingredients?.childIngredientCategory?.name}" ??
            //       //             "2 minutes ago",
            //       //         style: TextStyle(
            //       //             height: 1.3,
            //       //             fontFamily: kFontBook,
            //       //             color: eUser().mainHeadingColor,
            //       //             fontSize: bottomSheetSubHeadingSFontSize),
            //       //       ),
            //       //     ],
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // );
          }),
    );
  }

  noData() {
    Future.delayed(Duration.zero).whenComplete(() {
      if (isFetchError) {
        AppConfig().showSnackbar(context, AppConfig.oopsMessage, isError: true);
      }
    });
    return const Center(
      child: Image(
        image: AssetImage("assets/images/no_data_found.png"),
        fit: BoxFit.scaleDown,
      ),
    );
  }

  final ShipTrackRepository repository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  buildWebView() {
    return (showShoppingLoading)
        ? buildCircularIndicator()
        : (shoppingList.isNotEmpty)
            ? Row(
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
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: gWhiteColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_new_sharp,
                                    color: gBlackColor,
                                    size: 2.h,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                "Shopping",
                                style: TextStyle(
                                    fontFamily: kFontMedium,
                                    color: gBlackColor,
                                    fontSize: 15.dp),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 1.w),
                            child: Text(
                              "Used For : ",
                              style: TextStyle(
                                fontFamily: kFontMedium,
                                color: gTextColor,
                                fontSize: 12.dp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                // padding: EdgeInsets.only(top: 4.h, left: 3.w, right: 3.w, bottom: 2.h),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 30,
                                  crossAxisCount: 3,
                                  mainAxisExtent: 8.h,
                                ),
                                itemCount: shoppingList.keys.length,
                                itemBuilder: (context, index) {
                                  String category =
                                      shoppingList.keys.elementAt(index);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Update the selected category on tap
                                        selectedCategory = category;
                                      });
                                    },
                                    child: Container(
                                      // padding: EdgeInsets.symmetric(
                                      //     horizontal: 1.w, vertical: 1.h),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                        // color: selectedCategory == category
                                        //     ? gsecondaryColor : gWhiteColor,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: selectedCategory == category
                                              ? [
                                                  gsecondaryColor
                                                      .withOpacity(0.3),
                                                  gsecondaryColor
                                                      .withOpacity(0.5),
                                                ]
                                              : [
                                                  gWhiteColor,
                                                  gWhiteColor,
                                                ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: gGreyColor.withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          category,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: selectedCategory == category
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
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
                      child: SingleChildScrollView(
                        child: selectedCategory != null
                            ? shoppingUi(shoppingList[selectedCategory]!)
                            : const Center(
                                child: Text('Select a category to see items'),
                              ),
                      ),
                    ),
                  ),
                ],
              )
            : noData();
  }
}
