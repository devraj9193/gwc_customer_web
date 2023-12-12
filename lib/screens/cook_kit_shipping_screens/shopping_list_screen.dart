/*
Api used:
getshopping list--
var shoppingListApiUrl = "${AppConfig().BASE_URL}/api/getData/get_shopping_list";


 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
    }
    else{
      setState(() {
        showShoppingLoading = false;
        isFetchError = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShoppingList();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  bool isFetchError = false;

  @override
  Widget build(BuildContext context) {
    return (showShoppingLoading)
        ? buildCircularIndicator()
        : (shoppingList.isNotEmpty)
        ? Column(
            children: [
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: SizedBox(
                  height: 30,
                  child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.black,
                    labelColor: gWhiteColor,
                    controller: _tabController,
                    unselectedLabelStyle: TextStyle(
                        fontFamily: kFontBook,
                        color: gHintTextColor,
                        fontSize: 9.sp),
                    labelStyle: TextStyle(
                        fontFamily: kFontMedium,
                        color: gBlackColor,
                        fontSize: 11.sp),
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
          ) : noData();
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
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: ListView(
        children: [
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: SingleChildScrollView(
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount: 2,
                      mainAxisExtent: 22.h,
                      // childAspectRatio: MediaQuery.of(context).size.width /
                      //     (MediaQuery.of(context).size.height / 1.4),
                    ),
                    // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                    itemCount: shoppingItem.length,
                    itemBuilder: (context, index) {
                      print("image : ${shoppingItem[index]
                          .thumbnail}");
                      return Container(
                        decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(3, 8),
                            ),
                          ],
                          // border: Border(
                          //   right: BorderSide(
                          //     color: kLineColor.withOpacity(0.5),
                          //   ),
                          //   bottom: BorderSide(
                          //     color: kLineColor.withOpacity(0.5),
                          //   ),
                          // ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    (shoppingItem[index]
                                                .thumbnail!=
                                            null)
                                        ? SizedBox(
                                            height: 15.h,
                                            width: 30.w,
                                            child: Image(
                                              image: NetworkImage(
                                                  "${Uri.parse("${shoppingItem[index].thumbnail}")}"),
                                            ),
                                          )
                                        :
                                    SizedBox(
                                  height: 15.h,
                                  width: 30.w,
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/images/meal_placeholder.png"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "${shoppingItem[index].name}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: "GothamMedium",
                                color: gTextColor,
                              ),
                            ),
                            // SizedBox(height: 0.5.h),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 5.w),
                            //   child: RichText(
                            //     textAlign: TextAlign.center,
                            //     text: TextSpan(children: [
                            //       TextSpan(
                            //         text: "Used for : ",
                            //         style: TextStyle(
                            //           fontFamily: kFontBook,
                            //           color: gHintTextColor,
                            //           fontSize: 8.sp,
                            //         ),
                            //       ),
                            //       TextSpan(
                            //         text:
                            //             "${shoppingList[index].ingredients?.childIngredientCategory?.name}",
                            //         style: TextStyle(
                            //           fontFamily: "GothamMedium",
                            //           color: gHintTextColor,
                            //           fontSize: 8.sp,
                            //         ),
                            //       ),
                            //     ]),
                            //   ),
                            // ),
                            // Center(
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         "Used for : ",
                            //         style: TextStyle(
                            //             fontFamily: "GothamMedium",
                            //             color: gTextColor,
                            //             fontSize: 8.sp),
                            //       ),
                            //       Text(
                            //         "${shoppingList[index].ingredients?.childIngredientCategory?.name}" ??
                            //             "2 minutes ago",
                            //         style: TextStyle(
                            //             height: 1.3,
                            //             fontFamily: kFontBook,
                            //             color: eUser().mainHeadingColor,
                            //             fontSize: bottomSheetSubHeadingSFontSize),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final ShipTrackRepository repository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  noData() {
    Future.delayed(Duration.zero).whenComplete(() {
      if(isFetchError){
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
