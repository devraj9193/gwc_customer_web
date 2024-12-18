/*
  we r using only meal parameter to diaply all the meal recipe

other 2 params not using now

 */
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:image_network/image_network.dart';
import '../../../model/combined_meal_model/detox_nourish_model/detox_healing_common_model/child_meal_plan_details_model1.dart';
import '../../../model/combined_meal_model/meal_slot_model.dart';
import '../../../widgets/widgets.dart';
import '../../combined_meal_plan/recipe_details_screen/web_recipe_screen.dart';

class MealPlanRecipeDetails extends StatefulWidget {
  /// we r using only meal parameter to diaply all the meal recipe
  final MealSlot? meal;
  final ChildMealPlanDetailsModel1? mealPlanRecipe;
  final bool isFromProgram;
  const MealPlanRecipeDetails({
    Key? key,
    this.meal,
    this.mealPlanRecipe,
    this.isFromProgram = false,
  }) : super(key: key);

  @override
  State<MealPlanRecipeDetails> createState() => _MealPlanRecipeDetailsState();
}

class _MealPlanRecipeDetailsState extends State<MealPlanRecipeDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  MealSlot? meals;
  ChildMealPlanDetailsModel1? mealPlanRecipes;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
    meals = widget.meal;
    print("Recipe Details : ${widget.mealPlanRecipe?.itemImage}");
    mealPlanRecipes = widget.mealPlanRecipe;

    print("itemImage");
    print(mealPlanRecipes?.itemImage);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List colors = [
    newDashboardGreenButtonColor.withOpacity(0.3),
    kNumberCircleRed.withOpacity(0.3),
    kNumberCirclePurple.withOpacity(0.3),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MediaQuery.of(context).size.shortestSide > 600
          ? WebRecipeScreen(
              meal: widget.meal,
              mealPlanRecipe: widget.mealPlanRecipe,
              isFromProgram: widget.isFromProgram,
            )
          : Scaffold(
              backgroundColor: gWhiteColor,
              body: widget.isFromProgram
                  ? buildScreen(
                      itemPhoto: mealPlanRecipes?.itemImage ?? '',
                      itemName: mealPlanRecipes?.name ?? '',
                      itemCookingTime:
                          "${mealPlanRecipes?.cookingTime == 'null' ? '' : mealPlanRecipes?.cookingTime}",
                      ingredient: mealPlanRecipes!.ingredient,
                      howToPrepare: mealPlanRecipes?.howToPrepare,
                      variation: mealPlanRecipes?.variation,
                      howToStore: mealPlanRecipes?.howToStore,
                      faq: mealPlanRecipes?.faq,
                    )
                  : buildScreen(
                      itemPhoto: meals?.itemPhoto ?? '',
                      itemName: meals?.name ?? '',
                      itemCookingTime:
                          "${meals?.cookingTime == 'null' ? '' : meals?.cookingTime}",
                      ingredient: meals!.ingredient,
                      howToPrepare: meals?.howToPrepare,
                      variation: meals?.variation,
                      howToStore: meals?.howToStore,
                      faq: meals?.faq,
                    ),
              // widget.isFromProgram
              //     ? Column(
              //         children: [
              //           SizedBox(
              //             height: 50.h,
              //             width: double.maxFinite,
              //             child: Stack(
              //               fit: StackFit.expand,
              //               children: [
              //                 // Positioned(
              //                 //   top: 0,
              //                 //   left: 0,
              //                 //   right: 0,
              //                 //   child: Container(
              //                 //     height: 33.h,
              //                 //     width: 100.w,
              //                 //     decoration: BoxDecoration(
              //                 //       image: (mealPlanRecipes?.itemImage != null &&
              //                 //           mealPlanRecipes?.itemImage != "")
              //                 //           ? DecorationImage(
              //                 //           image: CachedNetworkImageProvider(
              //                 //             mealPlanRecipes?.itemImage ?? '',
              //                 //           ),
              //                 //           fit: BoxFit.cover)
              //                 //           : const DecorationImage(
              //                 //           image: AssetImage(
              //                 //             "assets/images/meal_placeholder.png",
              //                 //           ),
              //                 //           fit: BoxFit.fill),
              //                 //       borderRadius: const BorderRadius.only(
              //                 //         bottomLeft: Radius.circular(20),
              //                 //         bottomRight: Radius.circular(20),
              //                 //       ),
              //                 //     ),
              //                 //     child: Stack(
              //                 //       children: [
              //                 //         Positioned(
              //                 //           top: 0.h,
              //                 //           left: 0.w,
              //                 //           child: buildAppBar(
              //                 //                 () {
              //                 //               Navigator.pop(context);
              //                 //             },
              //                 //           ),
              //                 //         ),
              //                 //         // Positioned(
              //                 //         //   right: 5.w,
              //                 //         //   bottom: 5.h,
              //                 //         //   child: GestureDetector(
              //                 //         //     onTap: () {},
              //                 //         //     child: Icon(
              //                 //         //       Icons.smart_display,
              //                 //         //       color: gWhiteColor,
              //                 //         //       size: 4.h,
              //                 //         //     ),
              //                 //         //   ),
              //                 //         // ),
              //                 //       ],
              //                 //     ),
              //                 //   ),
              //                 // ),
              //                 Positioned(
              //                   top: 0,
              //                   left: 0,
              //                   right: 0,
              //                   child: ClipRRect(
              //                     borderRadius: const BorderRadius.only(
              //                       bottomLeft: Radius.circular(20),
              //                       bottomRight: Radius.circular(20),
              //                     ),
              //                     child: ImageNetwork(
              //                       image: mealPlanRecipes?.itemImage ?? '',
              //                       height: 30.h,
              //                       // height: MediaQuery.of(context).size.shortestSide < 600 ? 33.h : 50.h,
              //                       width: 100.w,
              //                       duration: 1500,
              //                       // curve: Curves.,
              //                       onPointer: true,
              //                       debugPrint: false,
              //                       fullScreen: false,
              //                       fitAndroidIos: BoxFit.cover,
              //                       fitWeb: BoxFitWeb.contain,
              //                       // borderRadius: BorderRadius.circular(70),
              //                       onLoading: const CircularProgressIndicator(
              //                         color: Colors.indigoAccent,
              //                       ),
              //                       onError: const Image(
              //                         image: AssetImage(
              //                           "assets/images/meal_placeholder.png",
              //                         ),
              //                       ),
              //                       onTap: () {
              //                         debugPrint("©gabriel_patrick_souza");
              //                       },
              //                     ),
              //                   ),
              //                   // Container(
              //                   //   height: 33.h,
              //                   //   decoration: BoxDecoration(
              //                   //     image: (meals?.itemPhoto != null)
              //                   //         ? DecorationImage(
              //                   //             image: CachedNetworkImageProvider(
              //                   //               meals?.itemPhoto ?? '',
              //                   //             ),
              //                   //             fit: BoxFit.fill)
              //                   //         : const DecorationImage(
              //                   //             image: AssetImage(
              //                   //               "assets/images/meal_placeholder.png",
              //                   //             ),
              //                   //             fit: BoxFit.fill),
              //                   //     borderRadius: const BorderRadius.only(
              //                   //       bottomLeft: Radius.circular(20),
              //                   //       bottomRight: Radius.circular(20),
              //                   //     ),
              //                   //   ),
              //                   //   child: Stack(
              //                   //     children: [
              //                   //       Positioned(
              //                   //         top: 0.h,
              //                   //         left: 0.w,
              //                   //         child: buildAppBar(
              //                   //           () {
              //                   //             Navigator.pop(context);
              //                   //           },
              //                   //         ),
              //                   //       ),
              //                   //       // Positioned(
              //                   //       //   right: 5.w,
              //                   //       //   bottom: 5.h,
              //                   //       //   child: GestureDetector(
              //                   //       //     onTap: () {},
              //                   //       //     child: Icon(
              //                   //       //       Icons.smart_display,
              //                   //       //       color: gWhiteColor,
              //                   //       //       size: 4.h,
              //                   //       //     ),
              //                   //       //   ),
              //                   //       // ),
              //                   //     ],
              //                   //   ),
              //                   // ),
              //                 ),
              //                 Positioned(
              //                   top: 25.h,
              //                   left: 5.w,
              //                   right: 5.w,
              //                   child: Container(
              //                     padding: EdgeInsets.symmetric(
              //                         horizontal: 3.w, vertical: 1.5.h),
              //                     // margin: EdgeInsets.symmetric(horizontal: 15.w),
              //                     decoration: BoxDecoration(
              //                       color: gWhiteColor,
              //                       boxShadow: [
              //                         BoxShadow(
              //                           color: kLineColor.withOpacity(0.5),
              //                           offset: const Offset(2, 5),
              //                           blurRadius: 5,
              //                         )
              //                       ],
              //                       borderRadius: BorderRadius.circular(10),
              //                     ),
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       crossAxisAlignment: CrossAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           mealPlanRecipes?.name ?? '',
              //                           style: TextStyle(
              //                             color: gBlackColor,
              //                             fontFamily: kFontBold,
              //                             fontSize: 15.dp,
              //                           ),
              //                         ),
              //                         SizedBox(height: 1.5.h),
              //                         Row(
              //                           mainAxisAlignment: MainAxisAlignment.center,
              //                           crossAxisAlignment: CrossAxisAlignment.center,
              //                           children: [
              //                             Text(
              //                               "Cooking Time ",
              //                               style: TextStyle(
              //                                 color: gHintTextColor,
              //                                 height: 1.3,
              //                                 fontFamily: kFontBook,
              //                                 fontSize: 14.dp,
              //                               ),
              //                             ),
              //                             Icon(
              //                               Icons.timer_outlined,
              //                               color: gHintTextColor,
              //                               size: 2.h,
              //                             ),
              //                             SizedBox(width: 1.w),
              //                             Text(
              //                               " - ${mealPlanRecipes?.cookingTime == 'null' ? '' : mealPlanRecipes?.cookingTime}",
              //                               style: TextStyle(
              //                                 color: gHintTextColor,
              //                                 height: 1.3,
              //                                 fontFamily: kFontMedium,
              //                                 fontSize: 14.dp,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 format == "mp4"
              //                     ? Positioned(
              //                         top: 3.h,
              //                         right: 3.w,
              //                         child: GestureDetector(
              //                           onTap: () {
              //                             print("/// Recipe Details ///");
              //                             Get.to(
              //                               () => MealPlanPortraitVideo(
              //                                 videoUrl:
              //                                     mealPlanRecipes?.recipeVideoUrl ??
              //                                         '',
              //                                 heading: mealPlanRecipes
              //                                                 ?.mealTypeName ==
              //                                             "null" ||
              //                                         mealPlanRecipes?.mealTypeName ==
              //                                             ""
              //                                     ? mealPlanRecipes?.name ?? ''
              //                                     : mealPlanRecipes?.mealTypeName ??
              //                                         '',
              //                               ),
              //                             );
              //                           },
              //                           child: Container(
              //                             padding: EdgeInsets.symmetric(
              //                                 horizontal: 3.w, vertical: 1.5.h),
              //                             decoration: BoxDecoration(
              //                               color: gWhiteColor,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   color: kLineColor.withOpacity(0.5),
              //                                   offset: const Offset(2, 5),
              //                                   blurRadius: 5,
              //                                 )
              //                               ],
              //                               borderRadius: BorderRadius.circular(10),
              //                             ),
              //                             child: Row(
              //                               children: [
              //                                 Icon(
              //                                   Icons.play_arrow,
              //                                   size: 2.5.h,
              //                                   color: gPrimaryColor,
              //                                 ),
              //                                 SizedBox(width: 1.5.w),
              //                                 Text(
              //                                   "Recipe",
              //                                   style: TextStyle(
              //                                     color: gBlackColor,
              //                                     fontFamily: kFontBold,
              //                                     fontSize: 9.dp,
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                         ),
              //                       )
              //                     : const SizedBox(),
              //                 Positioned(
              //                   top: 1.5.h,
              //                   left: 3.w,
              //                   child: buildAppBar(() {
              //                     Navigator.pop(context);
              //                   }),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Expanded(
              //             child: Padding(
              //               padding: EdgeInsets.symmetric(horizontal: 5.w),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     "Ingredients",
              //                     style: TextStyle(
              //                       color: gBlackColor,
              //                       fontFamily: kFontBold,
              //                       fontSize: 11.dp,
              //                     ),
              //                   ),
              //                   SizedBox(height: 1.h),
              //                   buildIngredients(mealPlanRecipes!.ingredient),
              //                   TabBar(
              //                       controller: _tabController,
              //                       labelColor: eUser().userFieldLabelColor,
              //                       unselectedLabelColor: eUser().userTextFieldColor,
              //                       // padding: EdgeInsets.symmetric(horizontal: 3.w),
              //                       isScrollable: true,
              //                       indicatorColor: gsecondaryColor,
              //                       labelStyle: TextStyle(
              //                           fontFamily: kFontMedium,
              //                           color: gPrimaryColor,
              //                           fontSize: 15.dp),
              //                       unselectedLabelStyle: TextStyle(
              //                           fontFamily: kFontBook,
              //                           color: gHintTextColor,
              //                           fontSize: 13.dp),
              //                       labelPadding: EdgeInsets.only(
              //                           right: 10.w,
              //                           left: 2.w,
              //                           top: 1.h,
              //                           bottom: 1.h),
              //                       // indicatorPadding: EdgeInsets.only(right: 7.w),
              //                       tabs: const [
              //                         Text('How to make it'),
              //                         Text('Variations'),
              //                         Text('How to Store'),
              //                         Text('FAQ'),
              //                       ]),
              //                   Expanded(
              //                     child: TabBarView(
              //                       controller: _tabController,
              //                       children: [
              //                         buildHowToMakeIt(
              //                             "${mealPlanRecipes?.howToPrepare}"),
              //                         buildVariations(mealPlanRecipes?.variation),
              //                         buildHowToStore(
              //                             "${mealPlanRecipes?.howToStore}"),
              //                         buildFAQ(mealPlanRecipes?.faq),
              //                       ],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       )
              //     : Column(
              //         children: [
              //           Container(
              //             height: 35.h,
              //             // width: double.maxFinite,
              //             // decoration: const BoxDecoration(
              //             //   color: profileBackGroundColor,
              //             //   borderRadius: BorderRadius.only(
              //             //     bottomLeft: Radius.circular(20),
              //             //     bottomRight: Radius.circular(20),
              //             //   ),
              //             // ),
              //             child: Stack(
              //               fit: StackFit.expand,
              //               children: [
              //                 Positioned(
              //                   top: 0, // 30% from the top
              //                   left: 0,
              //                   right: 0,
              //                   child: Container(
              //                     height: screenHeight * 0.35, // Remaining 70% height
              //                     decoration: BoxDecoration(
              //                       color: gsecondaryColor.withOpacity(0.3),
              //                       borderRadius: const BorderRadius.only(
              //                         bottomLeft: Radius.circular(20),
              //                         bottomRight: Radius.circular(20),
              //                       ),
              //                       image: const DecorationImage(
              //                         image: AssetImage(
              //                             'assets/images/meal_placeholder.png'), // Your background image path
              //                         fit: BoxFit.cover,
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //                 Container(
              //                   height: 5.h,
              //                   width: double.maxFinite,
              //                   decoration: BoxDecoration(
              //                     color: gsecondaryColor.withOpacity(0.3),
              //                     borderRadius: const BorderRadius.only(
              //                       bottomLeft: Radius.circular(20),
              //                       bottomRight: Radius.circular(20),
              //                     ),
              //                     image: DecorationImage(
              //                       image: NetworkImage(
              //                         meals?.itemPhoto ?? '',
              //                       ),
              //                     ),
              //                   ),
              //                   // child: ImageNetwork(
              //                   //   image: meals?.itemPhoto ?? '',
              //                   //   height: 5.h,
              //                   //   // height: MediaQuery.of(context).size.shortestSide < 600 ? 33.h : 50.h,
              //                   //   width: double.maxFinite,
              //                   //   duration: 1500,
              //                   //   // curve: Curves.,
              //                   //   onPointer: true,
              //                   //   debugPrint: false,
              //                   //   fullScreen: false,
              //                   //   fitAndroidIos: BoxFit.cover,
              //                   //   fitWeb: BoxFitWeb.fill,
              //                   //   // borderRadius: BorderRadius.circular(70),
              //                   //   onLoading: const CircularProgressIndicator(
              //                   //     color: Colors.indigoAccent,
              //                   //   ),
              //                   //   onError: const Image(
              //                   //     image: AssetImage(
              //                   //       "assets/images/meal_placeholder.png",
              //                   //     ),
              //                   //   ),
              //                   //   onTap: () {
              //                   //     debugPrint("©gabriel_patrick_souza");
              //                   //   },
              //                   // ),
              //                 ),
              //                 Positioned(
              //                   top: 25.h,
              //                   left: 20.w,
              //                   right: 20.w,
              //                   child: Container(
              //                     padding: EdgeInsets.symmetric(
              //                         horizontal: 3.w, vertical: 1.h),
              //                     decoration: BoxDecoration(
              //                       color: gWhiteColor,
              //                       boxShadow: [
              //                         BoxShadow(
              //                           color: kLineColor.withOpacity(0.5),
              //                           offset: const Offset(2, 5),
              //                           blurRadius: 5,
              //                         )
              //                       ],
              //                       borderRadius: BorderRadius.circular(10),
              //                     ),
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       crossAxisAlignment: CrossAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           meals?.name ?? '',
              //                           style: TextStyle(
              //                             color: gBlackColor,
              //                             fontFamily: kFontBold,
              //                             fontSize: 15.dp,
              //                           ),
              //                         ),
              //                         SizedBox(height: 1.5.h),
              //                         Row(
              //                           mainAxisAlignment: MainAxisAlignment.center,
              //                           crossAxisAlignment: CrossAxisAlignment.center,
              //                           children: [
              //                             Text(
              //                               "Cooking Time ",
              //                               style: TextStyle(
              //                                 color: gHintTextColor,
              //                                 height: 1.3,
              //                                 fontFamily: kFontBook,
              //                                 fontSize: 14.dp,
              //                               ),
              //                             ),
              //                             Icon(
              //                               Icons.timer_outlined,
              //                               color: gHintTextColor,
              //                               size: 2.5.h,
              //                             ),
              //                             SizedBox(width: 0.5.w),
              //                             Text(
              //                               " -  ${meals?.cookingTime ?? ''}",
              //                               style: TextStyle(
              //                                 color: gHintTextColor,
              //                                 height: 1.3,
              //                                 fontFamily: kFontBook,
              //                                 fontSize: 14.dp,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 format == "mp4"
              //                     ? Positioned(
              //                         top: 3.h,
              //                         right: 3.w,
              //                         child: GestureDetector(
              //                           onTap: () {
              //                             print("/// Recipe Details ///");
              //                             Get.to(
              //                               () => MealPlanPortraitVideo(
              //                                 videoUrl: meals?.recipeVideoUrl ?? '',
              //                                 heading:
              //                                     meals?.mealTypeName == "null" ||
              //                                             meals?.mealTypeName == ""
              //                                         ? meals?.name ?? ''
              //                                         : meals?.mealTypeName ?? '',
              //                               ),
              //                             );
              //                           },
              //                           child: Container(
              //                             padding: EdgeInsets.symmetric(
              //                                 horizontal: 3.w, vertical: 1.5.h),
              //                             decoration: BoxDecoration(
              //                               color: gWhiteColor,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   color: kLineColor.withOpacity(0.5),
              //                                   offset: const Offset(2, 5),
              //                                   blurRadius: 5,
              //                                 )
              //                               ],
              //                               borderRadius: BorderRadius.circular(10),
              //                             ),
              //                             child: Row(
              //                               children: [
              //                                 Icon(
              //                                   Icons.play_arrow,
              //                                   size: 2.5.h,
              //                                   color: gPrimaryColor,
              //                                 ),
              //                                 SizedBox(width: 1.5.w),
              //                                 Text(
              //                                   "Recipe",
              //                                   style: TextStyle(
              //                                     color: gBlackColor,
              //                                     fontFamily: kFontBold,
              //                                     fontSize: 9.dp,
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                         ),
              //                       )
              //                     : const SizedBox(),
              //                 Positioned(
              //                   top: 1.5.h,
              //                   left: 3.w,
              //                   child: buildAppBar(() {
              //                     Navigator.pop(context);
              //                   }),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           Expanded(
              //             child: Padding(
              //               padding: EdgeInsets.symmetric(horizontal: 5.w),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     "Ingredients",
              //                     style: TextStyle(
              //                       color: gBlackColor,
              //                       fontFamily: kFontBold,
              //                       fontSize: 15.dp,
              //                     ),
              //                   ),
              //                   SizedBox(height: 1.h),
              //                   buildIngredient(meals?.ingredient),
              //                   TabBar(
              //                       controller: _tabController,
              //                       labelColor: eUser().userFieldLabelColor,
              //                       tabAlignment: TabAlignment.start,
              //                       unselectedLabelColor: eUser().userTextFieldColor,
              //                       // padding: EdgeInsets.symmetric(horizontal: 3.w),
              //                       isScrollable: true,
              //                       indicatorColor: gsecondaryColor,
              //                       labelStyle: TextStyle(
              //                           fontFamily: kFontMedium,
              //                           color: gPrimaryColor,
              //                           fontSize: 15.dp),
              //                       unselectedLabelStyle: TextStyle(
              //                           fontFamily: kFontBook,
              //                           color: gHintTextColor,
              //                           fontSize: 13.dp),
              //                       labelPadding: EdgeInsets.only(
              //                           right: 10.w,
              //                           left: 2.w,
              //                           top: 1.h,
              //                           bottom: 1.h),
              //                       // indicatorPadding: EdgeInsets.only(right: 7.w),
              //                       tabs: const [
              //                         Text('How to make it'),
              //                         Text('Variations'),
              //                         Text('How to Store'),
              //                         Text('FAQ'),
              //                       ]),
              //                   Expanded(
              //                     child: TabBarView(
              //                       controller: _tabController,
              //                       children: [
              //                         buildHowToMakeIt("${meals?.howToPrepare}"),
              //                         buildVariations(meals?.variation),
              //                         buildHowToStore("${meals?.howToStore}"),
              //                         buildFAQ(meals?.faq),
              //                       ],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
            ),
    );
  }

  buildScreen({
    String? itemPhoto,
    String? itemName,
    String? itemCookingTime,
    List<Ingredient>? ingredient,
    String? howToPrepare,
    List<Variation>? variation,
    String? howToStore,
    List<Faq>? faq,
  }) {
    double screenHeight = MediaQuery.of(context).size.height;

    print("Thumbnail : $itemPhoto");
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: screenHeight * 0.35,
            decoration: BoxDecoration(
              color: gsecondaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: ImageNetwork(
                image: itemPhoto ?? '',
                height: 200,
                width: 180,
                // height: screenHeight * 0.35,
                // width: double.maxFinite,
                duration: 1500,
                onPointer: true,
                debugPrint: false,
                fullScreen: false,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                fitAndroidIos: BoxFit.cover,
                fitWeb: BoxFitWeb.contain,
                onLoading: const CircularProgressIndicator(
                  color: Colors.indigoAccent,
                ),
                onError: const Image(
                  image: AssetImage(
                    "assets/images/meal_placeholder.png",
                  ),
                  fit: BoxFit.contain,
                ),
                onTap: () {
                  debugPrint("©gabriel_patrick_souza");
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 1.5.h,
          left: 1.5.w,
          child: buildAppBar(() {
            Navigator.pop(context);
          }),
        ),
        Positioned(
          top: 30.h,
          left: 0.w,
          right: 0.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: IntrinsicWidth(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: kLineColor.withOpacity(0.5),
                            offset: const Offset(2, 5),
                            blurRadius: 5,
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            itemName ?? '',
                            style: TextStyle(
                              color: gBlackColor,
                              fontFamily: kFontBold,
                              fontSize: 15.dp,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Cooking Time ",
                                style: TextStyle(
                                  color: gHintTextColor,
                                  height: 1.3,
                                  fontFamily: kFontBook,
                                  fontSize: 14.dp,
                                ),
                              ),
                              Icon(
                                Icons.timer_outlined,
                                color: gHintTextColor,
                                size: 2.5.h,
                              ),
                              SizedBox(width: 0.5.w),
                              Text(
                                " -  ${itemCookingTime ?? ''}",
                                style: TextStyle(
                                  color: gHintTextColor,
                                  height: 1.3,
                                  fontFamily: kFontBook,
                                  fontSize: 14.dp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                TabBar(
                  controller: _tabController,
                  labelColor: eUser().userFieldLabelColor,
                  unselectedLabelColor: eUser().userTextFieldColor,
                  tabAlignment: TabAlignment.start,
                  // padding: EdgeInsets.symmetric(horizontal: 3.w),
                  isScrollable: true,
                  indicatorColor: gsecondaryColor,
                  labelStyle: TextStyle(
                      fontFamily: kFontMedium,
                      color: gPrimaryColor,
                      fontSize: 15.dp),
                  unselectedLabelStyle: TextStyle(
                      fontFamily: kFontBook,
                      color: gHintTextColor,
                      fontSize: 13.dp),
                  labelPadding: EdgeInsets.only(
                      right: 10.w, left: 2.w, top: 1.h, bottom: 1.h),
                  // indicatorPadding: EdgeInsets.only(right: 7.w),
                  tabs: const [
                    Text('Ingredients'),
                    Text('How to make it'),
                    Text('Variations'),
                    Text('How to Store'),
                    Text('FAQ'),
                  ],
                ),
                SizedBox(
                  height: 50.h,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      buildIngredient(ingredient),
                      buildHowToMakeIt(howToPrepare ?? ''),
                      buildVariations(variation),
                      buildHowToStore(howToStore ?? ''),
                      buildFAQ(faq),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildIngredient(List<Ingredient>? ingredient) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.shortestSide > 600
              ? 5
              : 3, // Two rows
          childAspectRatio: 2, // Adjust height/width ratio
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 15.h,
        ),
        physics: const ScrollPhysics(), // Disable internal scrolling
        shrinkWrap: true, // Let parent handle size
        itemCount: ingredient?.length, // Number of items in the list
        itemBuilder: (context, index) {
          return Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color: ((colors.toList()..shuffle()).first),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ingredient?[index].ingredientName ?? '',
                  //   ingredientColor[index].title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gBlackColor,
                    fontFamily: kFontBold,
                    fontSize: 10.dp,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${ingredient?[index].qty} ${ingredient?[index].unit}',
                  // ingredientColor[index].subTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gHintTextColor,
                    // height: 1,
                    fontFamily: kFontBook,
                    fontSize: 10.dp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  profileTile(String title, String subTitle, {bool isMultiline = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: title.isNotEmpty,
            child: title == "Nil" || title == "null"
                ? const Text("")
                : Text(
                    title,
                    style: TextStyle(
                      color: gBlackColor,
                      fontFamily: kFontBold,
                      fontSize: 15.dp,
                    ),
                  ),
          ),
          SizedBox(height: 1.h),
          title == "Nil" || title == "null"
              ? const Text("")
              : (!isMultiline)
                  ? Text(
                      subTitle,
                      style: TextStyle(
                        color: gHintTextColor,
                        height: 1.3,
                        fontFamily: kFontBook,
                        fontSize: 13.dp,
                      ),
                    )
                  : Text(
                      subTitle.replaceAll('*', '\n'),
                      style: TextStyle(
                        color: gHintTextColor,
                        height: 1.3,
                        fontFamily: kFontBook,
                        fontSize: 13.dp,
                      ),
                    ),
        ],
      ),
    );
  }

  buildIngredients(List<Ingredient>? ingredient) {
    return SizedBox(
      height: 12.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: ingredient?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.h),
            child: Container(
              height: 8.h,
              width:
                  MediaQuery.of(context).size.shortestSide < 600 ? 100.w : 30.w,
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.h),
              decoration: BoxDecoration(
                color: ((colors.toList()..shuffle()).first),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      ingredient?[index].ingredientName ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gBlackColor,
                        fontFamily: kFontMedium,
                        fontSize: 13.dp,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${ingredient?[index].qty} ${ingredient?[index].unit}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gHintTextColor,
                        fontFamily: kFontBook,
                        fontSize: 11.dp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  buildHowToMakeIt(String howToPrepare) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: kLineColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          SizedBox(height: 2.h),
          howToPrepare != "null"
              ? profileTile("Instruction", howToPrepare)
              : const SizedBox(),

          // profileTile("Instruction:",
          //     '1. In a pot, bring the water to a boil.\n2. Add barley mix and salt to the pot and stir to continue.\n3. Reduce the heat to low, cover the pot with a lid, and simmer for 5 to 10 minutes, or until the porridge is well cooked.\n4. Once cooked, remove the pot from the heat.\n5. Serve the barley porridge hot and enjoy!'),
          //
        ],
      ),
    );
  }

  buildVariations(List<Variation>? variation) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: kLineColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          SizedBox(height: 2.h),
          if (variation != null)
            ...variation
                .map(
                  (e) => profileTile(
                      e.variationTitle ?? '', e.variationDescription ?? ''),
                )
                .toList()
        ],
      ),
    );
  }

  buildHowToStore(String howToStore) {
    return SingleChildScrollView(
      child: howToStore != "null"
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  color: kLineColor.withOpacity(0.3),
                  width: double.maxFinite,
                ),
                SizedBox(height: 2.h),

                if (!howToStore.contains("*"))
                  profileTile("", howToStore)
                else
                  ...howToStore.split('*').map((e) {
                    print(e);
                    return profileTile(e.split(":").first, e.split(":").last);
                  }).toList(),

                // profileTile("How to store and carry?",
                //     "1. Use a glass container: If you need to carry the porridge with you, consider using a glass container instead of plastic. Glass is non-toxic and won't leach any harmful chemicals into the food, which can potentially disrupt gut health."),
                //
              ],
            )
          : const SizedBox(),
    );
  }

  buildFAQ(List<Faq>? faq) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: kLineColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          SizedBox(height: 2.h),
          if (faq != null)
            ...faq
                .map(
                  (e) => profileTile(e.faqQuestion ?? '', e.faqAnswer ?? ''),
                )
                .toList()
        ],
      ),
    );
  }
}

class NewStageLevels {
  Color color;
  String title;
  String subTitle;

  NewStageLevels(this.color, this.title, this.subTitle);
}
