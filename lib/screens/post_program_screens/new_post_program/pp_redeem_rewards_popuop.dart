import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/rewards_model/reward_point_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/rewards_repository/reward_repository.dart';
import 'package:gwc_customer_web/services/rewards_service/reward_service.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PPRewardsPopup extends StatefulWidget {
  const PPRewardsPopup({Key? key}) : super(key: key);

  @override
  State<PPRewardsPopup> createState() => _PPRewardsPopupState();
}

class _PPRewardsPopupState extends State<PPRewardsPopup> {
  List rewardList = [
    {
      'name':'FREE CONSULTATION',
      "subtitle":'Begin your gut healing journey with 500 reward points'
    },
    {
      'name':'50% OFF ON PROGRAM',
      "subtitle":'800 reward points await to be claimed; grab your opportunity now!'
    },
    {
      'name':'50% OFF ON MEMBERSHIP',
      "subtitle":'Stay connected with us, maybe forever, with your 1000 reward points'
    },
    {
      'name':'50%  OFF ON Maintenance KIT',
      "subtitle":'Get a discount on your gut maintenance kit with 1500 reward points.'
    }
  ];
  String rupeeSymbol = '\u{20B9}';
  Future? rewardFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rewardFuture = RewardService(repository: repo).getRewardService();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
                topRight: Radius.circular(12)
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2, color: Colors.grey.withOpacity(0.5))
            ],
          ),
          height: 75.h,
          width: 90.w,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: gsecondaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                  ],
                ),
                padding:
                EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(flex: 1,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset('assets/images/reward_coin.png',
                          fit: BoxFit.scaleDown,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Expanded(flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TOTAL REWARD'),
                            Text('500')
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Card(
                  // child: customListTile('12', 'anlnana;kd', '12 Nov 2022'),
                  elevation: 0,
                  child: ListView.separated(
                    shrinkWrap: true,
                    // itemCount: rewardList.length,
                    itemCount: rewardList.length,
                    itemBuilder: (_, index){
                      return customListTile(
                        rewardList[index]['name'],
                        rewardList[index]['subtitle'],
                        'Redeem'
                      );
                    },
                    separatorBuilder: (_, index){
                      if(rewardList != null && rewardList!.isNotEmpty){
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            color: kDividerColor,
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  customListTile(String name, String subTitle, String trailingText){
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 45,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE0FFAE)
            ),
            // child: Icon(Icons.card_giftcard)
            child: Image.asset("assets/images/points.png",
              fit: BoxFit.scaleDown,
            ),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name,
                    style: TextStyle(
                        fontFamily: kFontMedium,
                        fontSize: 11.sp,
                        color: gTextColor
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Expanded(
                    child: Text(subTitle,
                      style: TextStyle(
                          fontFamily: kFontMedium,
                          fontSize: 10.sp,
                          color: gTextColor
                      ),
                    ),
                  )
                ],
              )
          ),
          Text(trailingText,
            style: TextStyle(
                fontFamily: kFontMedium,
                fontSize: 8.sp,
                color: gTextColor,
                decoration: TextDecoration.underline
            ),
          ),
        ],
      ),
    );
    return ListTile(
      leading: Container(
        width: 20,
        height: 20,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0FFAE)
        ),
        // child: Icon(Icons.card_giftcard)
        child: Image.asset("assets/images/points.png",
          fit: BoxFit.scaleDown,
        ),
      ),
      isThreeLine: true,
      // minVerticalPadding: 0,
      // dense: true,
      minLeadingWidth: 30,
      title: Text(name,
        style: TextStyle(
            fontFamily: kFontMedium,
            fontSize: 11.sp,
            color: gTextColor
        ),
      ),
      subtitle: Wrap(
        children: [
          Text(subTitle,
            style: TextStyle(
                fontFamily: kFontMedium,
                fontSize: 10.sp,
                color: gTextColor
            ),
          )
        ],
      ),
      trailing: Text(subTitle,
        style: TextStyle(
            fontFamily: kFontMedium,
            fontSize: 8.sp,
            color: gTextColor,
          decoration: TextDecoration.underline
        ),
      ),
    );
  }
  RewardRepository repo = RewardRepository(
      apiClient: ApiClient(
          httpClient: http.Client()
      )
  );

  faqTile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Frequently asked questions",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: "GothamBold",
                  color: gTextColor,
                  fontSize: 12.sp),
            ),
            SizedBox(
              width: 2.w,
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Color(0xFFCFCFCF),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(8, 10),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text('What is the Refer and Earn program?',
                  style: TextStyle(
                      fontSize: 10.5.sp,
                      fontFamily: kFontMedium
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down_sharp,
                color: gMainColor,)
            ],
          ),
        )
      ],
    );
  }

}
