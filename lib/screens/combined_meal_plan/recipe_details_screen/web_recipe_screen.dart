import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import '../../../model/combined_meal_model/detox_nourish_model/detox_healing_common_model/child_meal_plan_details_model1.dart';
import '../../../model/combined_meal_model/meal_slot_model.dart';
import '../../new_profile_screens/web_screens/profile_web_screen.dart';

class WebRecipeScreen extends StatefulWidget {
  /// we r using only meal parameter to diaply all the meal recipe
  final MealSlot? meal;
  final ChildMealPlanDetailsModel1? mealPlanRecipe;
  final bool isFromProgram;
  const WebRecipeScreen({
    Key? key,
    this.meal,
    this.mealPlanRecipe,
    this.isFromProgram = false,
  }) : super(key: key);

  @override
  State<WebRecipeScreen> createState() => _WebRecipeScreenState();
}

class _WebRecipeScreenState extends State<WebRecipeScreen> {
  String selectedDetails = "Ingredients";

  List<UserModels> details = [
    UserModels(
      id: 1,
      title: "Ingredients",
    ),
    UserModels(
      id: 2,
      title: "How to make it",
    ),
    UserModels(
      id: 3,
      title: "Variations",
    ),
    UserModels(
      id: 4,
      title: "How to Store",
    ),
    UserModels(
      id: 5,
      title: "FAQ",
    ),
  ];

  @override
  void initState() {
    super.initState();

    meals = widget.meal;
    print("Recipe Details : ${widget.mealPlanRecipe?.itemImage}");
    mealPlanRecipes = widget.mealPlanRecipe;

    print("itemImage");
    print(mealPlanRecipes?.itemImage);
  }

  List colors = [
    newDashboardGreenButtonColor.withOpacity(0.3),
    kNumberCircleRed.withOpacity(0.3),
    kNumberCirclePurple.withOpacity(0.3),
  ];

  MealSlot? meals;

  ChildMealPlanDetailsModel1? mealPlanRecipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: profileBackGroundColor,
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
    print("Thumbnail : $itemPhoto");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: double.maxFinite,
            margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
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
                        itemName ?? '',
                        style: TextStyle(
                          fontSize: 15.dp,
                          fontFamily: kFontMedium,
                          color: gBlackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: NetworkImage(
                            itemPhoto ?? '',
                          ),
                          fit: BoxFit.fill,
                          height: 20.h,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    margin:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Cooking Time ",
                              style: TextStyle(
                                color: gHintTextColor,
                                height: 2,
                                fontFamily: kFontBook,
                                fontSize: 14.dp,
                              ),
                            ),
                            Icon(
                              Icons.timer_outlined,
                              color: gHintTextColor,
                              size: 2.5.h,
                            ),
                          ],
                        ),
                        Text(
                          itemCookingTime ?? '',
                          style: TextStyle(
                            fontSize: 15.dp,
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: details.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool isSelected = selectedDetails == details[index].title;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDetails = details[index].title;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.w, vertical: 1.5.h),
                          margin: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 2.w),
                          decoration: BoxDecoration(
                              color: isSelected ? gsecondaryColor : gWhiteColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            details[index].title,
                            style: TextStyle(
                              color: selectedDetails == details[index].title
                                  ? gWhiteColor
                                  : kTextColor,
                              fontFamily: selectedDetails == details[index].title
                                  ? kFontMedium
                                  : kFontBook,
                              fontSize: 14.dp,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            height: double.maxFinite,
            margin: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 2.w),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
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
                Text(
                  selectedDetails,
                  style: TextStyle(
                    fontSize: 15.dp,
                    fontFamily: kFontMedium,
                    color: gBlackColor,
                    height: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                selectedDetails == 'Ingredients'
                    ? buildIngredient(ingredient)
                    : selectedDetails == 'How to make it'
                        ? buildHowToMakeIt(howToPrepare ?? '')
                        : selectedDetails == 'Variations'
                            ? buildVariations(variation)
                            : selectedDetails == 'How to Store'
                                ? buildHowToStore(howToStore ?? '')
                                : selectedDetails == 'FAQ'
                                    ? buildFAQ(faq)
                                    : const SizedBox(),
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
