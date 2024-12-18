/*
Api used:
getshopping list--
var shoppingListApiUrl = "${AppConfig().BASE_URL}/api/getData/get_shopping_list";


 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';
import '../../model/ship_track_model/shopping_model/child_get_shopping_model.dart';
import '../../model/ship_track_model/shopping_model/get_shopping_model.dart';
import '../../repository/api_service.dart';
import '../../repository/shipping_repository/ship_track_repo.dart';
import '../../services/shipping_service/ship_track_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import 'package:http/http.dart' as http;

import '../../widgets/widgets.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool showShoppingLoading = false;
  Map<String, List<ChildGetShoppingModel>> shoppingList = {};
  int shoppingTapLength = 0;
  String tabText = "";

  @override
  void initState() {
    super.initState();
    getShoppingList();
  }

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

      _tabController = TabController(length: shoppingTapLength, vsync: this);
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
    _tabController?.dispose();
    super.dispose();
  }

  bool isFetchError = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(
                  () {
                    Navigator.pop(context);
                  },
                  showHelpIcon: false,
                  helpOnTap: () {
                    // if(planNotePdfLink != null || planNotePdfLink!.isNotEmpty){
                    //   Navigator.push(context, MaterialPageRoute(builder: (ctx)=>
                    //       MealPdf(pdfLink: planNotePdfLink! ,
                    //         heading: "Note",
                    //       )));
                    // }
                    // else{
                    //   AppConfig().showSnackbar(context, "Note Link Not available", isError: true);
                    // }
                  }),
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
              Expanded(child:
              (showShoppingLoading)
                  ? buildCircularIndicator()
                  : (shoppingList.isNotEmpty)
                      ? Column(
                          children: [
                            SizedBox(height: 1.h),
                            SizedBox(
                              height: 30,
                              child: Row(
                                children: [
                                  Text(
                                    "Used For : ",
                                    style: TextStyle(
                                      fontFamily: kFontMedium,
                                      color: gTextColor,
                                      fontSize: 12.dp,
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBar(
                                      isScrollable: true,
                                      tabAlignment: TabAlignment.start,
                                      controller: _tabController,
                                      dividerColor: Colors.transparent,
                                      unselectedLabelStyle: TextStyle(
                                          fontFamily: kFontBook,
                                          color: gHintTextColor,
                                          fontSize: 13.dp),
                                      labelStyle: TextStyle(
                                          fontFamily: kFontMedium,
                                          color: gWhiteColor,
                                          fontSize: 15.dp),
                                      labelPadding: EdgeInsets.only(left: 3.w),
                                      indicatorPadding:
                                      EdgeInsets.symmetric(horizontal: -2.w),
                                      indicator: const BoxDecoration(
                                        color: newDashboardGreenButtonColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        ),
                                      ),
                                      onTap: (index) {
                                        print("ontap: $index");
                                        // _buildList(index);
                                      },
                                      tabs: shoppingList.keys.map((e) {
                                        return Tab(
                                          child: Text(e),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  ...shoppingList.values.map((e) {
                                    return shoppingUi(e);
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : noData(),),
            ],
          ),
        ),
      ),
    );
  }

  shoppingUi(List<ChildGetShoppingModel> shoppingItem) {
    if (shoppingItem.isNotEmpty) {
      return buildShippingList(shoppingItem);
      // return tableView();
    } else {
      return noData();
    }
  }

  buildShippingList(List<ChildGetShoppingModel> shoppingItem) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, top: 3.h,right: 5.w),
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            crossAxisCount:
                MediaQuery.of(context).size.shortestSide < 600 ? 2 : 4,
            mainAxisExtent: 25.h,
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
                // margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: gWhiteColor,
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
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: ImageNetwork(
                          image: shoppingItem[index].thumbnail.toString(),
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
                            debugPrint("©gabriel_patrick_souza");
                          },
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Expanded(
                        child: Text(
                          "${shoppingItem[index].name}",
                          style: TextStyle(
                            fontFamily: kFontMedium,
                            color: gTextColor,
                            fontSize: 12.dp,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                    ],
                  ),
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

  final ShipTrackRepository repository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

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
}
