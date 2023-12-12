/*
Api used:
var rewardPointsUrl = "${AppConfig().BASE_URL}/api/getDataList/get_user_reward_points";

Onclick of Refer Now on Tap we r showing refer & earn screen
added ui design api integration not implemented

 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/rewards_model/reward_point_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/rewards_repository/reward_repository.dart';
import 'package:gwc_customer_web/screens/profile_screens/reward/refer_and_earn_screen.dart';
import 'package:gwc_customer_web/services/rewards_service/reward_service.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  List rewardList = [
    {
      'amount': 250,
      'name':'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "time":'09 Nov 22'
    },
    {
      'amount': 10,
      'name':'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "time":'09 Nov 22'
    },
    {
      'amount': 100,
      'name':'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "time":'09 Nov 22'
    },
    {
      'amount': 400,
      'name':'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "time":'09 Nov 22'
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: 100.h,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 25.h,
                  color: gsecondaryColor,
                  padding:
                  EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex:1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildAppBar(() {
                              Navigator.pop(context);
                            }),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "Refer your friends",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: kFontBook,
                                  color: gWhiteColor,
                                  fontSize: 12.sp),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              "Earn $rupeeSymbol 150 Each",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: kFontMedium,
                                  color: gWhiteColor,
                                  fontSize: 11.sp),
                            ),
                            GestureDetector(
                                onTap: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_)=> ReferAndEarnScreen()
                                      )
                                  );
                                },
                                child: Text(
                                  "Refer Now",
                                  style: TextStyle(
                                      fontFamily: kFontBold,
                                      color: gWhiteColor,
                                      fontSize: 12.sp
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
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
                      SizedBox(
                        height: 1.5.h,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FutureBuilder(
                    future: rewardFuture,
                    builder: (_, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return buildCircularIndicator();
                      }
                      else if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasData){
                          if(snapshot.data is RewardPointModel){
                            final model = snapshot.data as RewardPointModel;
                            return Container(
                              color: Color(0xFFFAFAFA),
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    fit: StackFit.expand,
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        top: 5.h,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                (model.rewardList == null || model.rewardList!.isEmpty)
                                                    ? SizedBox(
                                                  height: 50.h,
                                                  child: Center(
                                                    child: Text('There is No Rewards',
                                                      style: TextStyle(
                                                        fontFamily: kFontBook
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    :Card(
                                                  elevation: 5,
                                                  child: ListView.separated(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: model.rewardList?.length ?? 0,
                                                    itemBuilder: (_, index){
                                                      return customListTile(
                                                        model.rewardList?[index].rewardPoints?.point ?? '',
                                                          model.rewardList?[index].rewardPoints?.name ?? '',
                                                          model.rewardList?[index].createdAt ?? '',
                                                      );
                                                    },
                                                    separatorBuilder: (_, index){
                                                      if(model.rewardList != null && model.rewardList!.isNotEmpty){
                                                        if(index != model.rewardList!.length-1){
                                                          return Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                                            child: Divider(
                                                              color: kDividerColor,
                                                            ),
                                                          );
                                                        }
                                                      }
                                                      return SizedBox.shrink();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                //faqTile(context)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 10.w,
                                        right: 10.w,
                                        top: -10.w,
                                        child: GestureDetector(
                                          onTap:(){
                                            // Navigator.push(context, MaterialPageRoute(builder: (_)=> LevelsScreen()));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.w, vertical: 1.h),
                                            decoration: BoxDecoration(
                                              color: gWhiteColor,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  blurRadius: 20,
                                                  offset: const Offset(8, 10),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Image(
                                                  image: const AssetImage(
                                                      "assets/images/reward_coin.png"),
                                                  height: 8.h,
                                                ),
                                                SizedBox(width: 5.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "TOTAL REWARD",
                                                        style: TextStyle(
                                                            fontFamily: kFontBook,
                                                            color: gTextColor,
                                                            letterSpacing: 0.4,
                                                            fontSize: 11.sp),
                                                      ),
                                                      Text(
                                                        "${model.totalReward} Pts",
                                                        style: TextStyle(
                                                            fontFamily: kFontBold,
                                                            color: gTextColor,
                                                            height: 1.5,
                                                            fontSize: 11.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: false,
                                                  child: Icon(
                                                    Icons.arrow_forward_ios_sharp,
                                                    color: gMainColor,
                                                    size: 2.h,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          }
                          else{
                            final model = snapshot.data as ErrorModel;
                            return Center(
                              child: Text(model.message.toString()),
                            );
                          }
                        }
                        else if(snapshot.hasError){
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                      }
                      return buildCircularIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  customListTile(String rupee, String name, String time){
    return ListTile(
      leading: Container(
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
      minVerticalPadding: 0,
      dense: true,
      minLeadingWidth: 30,
      title: Text('$rupee Pt',
        style: TextStyle(
          fontFamily: kFontMedium,
          fontSize: 11.sp,
            color: gTextColor
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
            style: TextStyle(
                fontFamily: kFontMedium,
                fontSize: 10.sp,
              color: gTextColor
            ),
          ),
          Text(DateFormat('yyyy/MM/dd, hh:mm a').format(DateTime.parse(time).toLocal()).toString(),
            style: TextStyle(
                fontFamily: kFontBook,
                fontSize: 9.sp,
                color: gTextColor
            ),
          )
        ],
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
                  fontFamily: kFontBold,
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
