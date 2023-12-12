/*
this screen will be called from combinedmealplan screen when stage becomes 0/3

we r passing the url from that screen

this screen will need to show the pdf using pdf viewer
used syncfusion pdf viewer;

 */

import 'package:flutter/material.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../widgets/constants.dart';

class DosDontsProgramScreen extends StatelessWidget {
  final String pdfLink;
  DosDontsProgramScreen({Key? key, required this.pdfLink}) : super(key: key);

  List<DoDonotClass> dosList = [];
  @override
  Widget build(BuildContext context) {
    print(dodonotList);
    dodonotList.forEach((e) {
      print(e);
      dosList.add(DoDonotClass.fromMap(e));
    });
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            topView(context),
            Expanded(child: customizedBottomView())
          ],
        ),
      ),
    );
  }

  topView(BuildContext context) {
    return Container(
      height: 25.h,
      color: gBackgroundColor,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 80.w,
              height: 22.h,
              child: Center(
                  child: Image.asset("assets/images/do_dont_program.png")),
            ),
          ),
          Positioned(
              child: Padding(
                  padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
                  child: buildAppBar(
                    () {
                      Navigator.pop(context);
                    },
                  )))
        ],
      ),
    );
  }

  pdfBottomView(){

  }

  customizedBottomView() {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(1, 1),
            ),
          ]),
      child: SfPdfViewer.network(
          pdfLink
      ),
    );
  }

  headingView(String heading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            heading,
            style: TextStyle(fontSize: headingFont, fontFamily: kFontBold),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 1,
            width: 60,
            color: kLineColor,
          )
        ],
      ),
    );
  }

  List dos = [
    "Eating Warm / Freshly prepared foods",
    "Stick to the schedule. Try to progressively adopt the recommended food schedules.",
    "Soft diet as recommended (like soft cooked rice / kichidi)",
    "Eat short frequent meals for better digestion",
    "Increase the frequency of fruits and vegetables intake",
    "Easily digestible carbs like rice, seived whole wheat",
    "Easily digestible proteins like moong dal / masoor dal",
    "Vegetables grown above the ground and can include carrots, turnips, radish; green leafy veggies",
    "Fresh herbs and spices",
    "Fresh fruits",
    "Cow's milk/ curd set with cow's milk / buttermilk",
    "Desi ghee, rice bran oil, sesame / mustard oil",
    "Pink or rock salt",
  ];

  List donots = [
    "Eat short frequent meals for better digestion",
    "Increase the frequency of fruits and vegetables intake",
    "Easily digestible carbs like rice, seived whole wheat",
    "Easily digestible proteins like moong dal / masoor dal",
  ];

  List dodonotList = [
    {
      "name": "Foods and Habits",
      "Do's": [
        "Eating Warm / Freshly prepared foods",
        "Stick to the schedule. Try to progressively adopt the recommended food schedules.",
        "Soft diet as recommended (like soft cooked rice / kichidi)",
        "Eat short frequent meals for better digestion",
        "Increase the frequency of fruits and vegetables intake",
        "Easily digestible carbs like rice, seived whole wheat",
        "Easily digestible proteins like moong dal / masoor dal",
        "Vegetables grown above the ground and can include carrots, turnips, radish; green leafy veggies",
        "Fresh herbs and spices",
        "Fresh fruits",
        "Cow's milk/ curd set with cow's milk / buttermilk",
        "Desi ghee, rice bran oil, sesame / mustard oil",
        "Pink or rock salt"
      ],
      "Dont's": [
        "Refrigerated, reheated foods",
        "Late night foods",
        "Fried foods, maida items, bakery food, junk, spicy foods, refined sugar products, flour",
        "Large and heavy meals",
        "Non-vegetarian and heavy protein foods like soya, protein supplements,rajma, soya, channa",
        "Heavy carbs like Millets, quinoa, rolled oats, upma, seviya, poha",
        "Alcohol, smoking and other intoxicants",
        "Root vegetables (ones that grow underground) like Potato and Sweet Potato.",
        "Chilly",
        "Dry fruits; Nuts and oil seeds",
        "Buffalo'smilk / curd set with buffalo's milk / milk products like cheese, paneer",
        "Peanut oil",
        "Supplements; Warm water + Honey in empty stomach; Apple cider vinegar; prebiotic supplements; probiotic supplements",
        "Medications - antacids; laxatives; PPIs",
        "Other Detox therapies; Other Detox plans; Mono diets - keto diet / paleo diet etc;",
        "White salt and white sugar",
        "Soft drinks and cold drinks",
        "Caffeinated beverages like tea and coffee"
      ]
    },
    {
      "name": "LIfestyle and behaviours",
      "Do's": [
        "Early to bed / early to rise",
        "Instead of resting after eating breakfast, lunch, and dinner, go for a stroll.",
        "Stay active and engage in exercises like swimming, cycling, dancing or any sport."
      ],
      "Dont's": [
        "Staying awake Late night",
        "Certain energy practices like Chakra practices; Mantra chants etc.",
        "Don't lie down immediately after a meal."
      ]
    }
  ];

  customView(DoDonotClass e) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        headingView(e.name ?? ''),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  "Do's",
                  style:
                      TextStyle(fontFamily: kFontMedium, fontSize: headingFont),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kLineColor),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: e.doList?.length ?? 0,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.doList![index],
                          style: TextStyle(
                              fontSize: subHeadingFont, fontFamily: kFontBook),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  "Dont's",
                  style:
                      TextStyle(fontFamily: kFontMedium, fontSize: headingFont),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kLineColor),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: e.donotList?.length ?? 0,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          e.donotList?[index] ?? '',
                          style: TextStyle(
                              fontSize: subHeadingFont, fontFamily: kFontBook),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DoDonotClass {
  String? name;
  List<String> doList = [];
  List<String> donotList = [];

  DoDonotClass(
      {required this.name, required this.doList, required this.donotList});

  DoDonotClass.fromMap(Map<String, dynamic> map) {
    name = map['name'] ?? '';
    doList.addAll(map["Do's"]);
    donotList.addAll(map["Dont's"]);
  }
}
