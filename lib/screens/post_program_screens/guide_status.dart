import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/post_program_model/breakfast/child_breakfast.dart';
import 'package:gwc_customer_web/model/post_program_model/breakfast/protocol_breakfast_get.dart';
import 'package:gwc_customer_web/repository/post_program_repo/post_program_repository.dart';
import 'package:gwc_customer_web/services/post_program_service/post_program_service.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/post_program_model/post_program_base_model.dart';
import '../../repository/api_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class GuideStatus extends StatefulWidget {
  final String title;
  final int? dayNumber;
  final bool isSelected;
  const GuideStatus(
      {Key? key,
      required this.title,
      required this.dayNumber,
      this.isSelected = false})
      : super(key: key);

  @override
  State<GuideStatus> createState() => _GuideStatusState();
}

class _GuideStatusState extends State<GuideStatus> {
  Future? mealPlanFuture;
  String selectedValue = "";

  List dayReaction = [
    {
      "reaction": "assets/lottie/sad_face.json",
      "day": "Day 1",
    },
    {
      "reaction": "assets/lottie/sad_look.json",
      "day": "Day 2",
    },
    {
      "reaction": "assets/lottie/happy_face.json",
      "day": "Day 3",
    },
    {
      "reaction": "assets/lottie/sad_face.json",
      "day": "Day 4",
    },
    {
      "reaction": "assets/lottie/sad_look.json",
      "day": "Day 5",
    },
    {
      "reaction": "assets/lottie/happy_face.json",
      "day": "Day 6",
    },
  ];

  List types = ['Do', "Don't Do", 'none'];

  String? selectedDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails(widget.dayNumber.toString());
    selectedDay = widget.dayNumber.toString();
  }

  getDetails(String day) async {
    // mealPlanFuture = PostProgramService(repository: postProgramRepository).getBreakfastService(day, selectedType: widget.title.toLowerCase());
  }

  final PostProgramRepository postProgramRepository = PostProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              top: 1.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                SizedBox(height: 1.h),
                Text(
                  widget.title,
                  style: TextStyle(
                      fontFamily: "GothamBold",
                      color: gPrimaryColor,
                      fontSize: 11.sp),
                ),
                showTiles()
              ],
            ),
          ),
        ),
      ),
    );
  }

  showTiles() {
    return FutureBuilder(
        future: mealPlanFuture,
        builder: (_, snapshot) {
          print(snapshot.connectionState);
          if(snapshot.connectionState == ConnectionState.waiting){
            return buildCircularIndicator();
          }
          else if(snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasData) {
              print(snapshot.data);
              if (snapshot.data.runtimeType == ErrorModel) {
                ErrorModel model = snapshot.data as ErrorModel;
                return Center(
                  child: Column(
                    children: [
                      Text(model.message ?? ''),
                      TextButton(onPressed: (){
                        getDetails(widget.dayNumber.toString());
                        setState(() { });
                      },
                          child: Text('Retry')
                      )
                    ],
                  ),
                );
              }
              else {
                GetProtocolBreakfastModel model = snapshot.data as GetProtocolBreakfastModel;
                addSelectedValue(model.data);
                return Column(
                  children: [
                    widget.isSelected
                        ? buildList(model.history!)
                        : Lottie.asset('assets/lottie/emoji_waiting.json'),
                    Container(
                      width: double.maxFinite,
                      height: 1,
                      color: gHintTextColor.withOpacity(0.3),
                    ),
                    SizedBox(height: 1.5.h),
                    buildTile('assets/lottie/loading_tick.json', types[0],
                        mainText: model.data?.dataDo?.the0?.name ?? ''),
                    buildTile('assets/lottie/loading_wrong.json', types[1],
                        mainText: model.data?.doNot?.the0?.name ?? ''),
                    buildTile('assets/lottie/loading_wrong.json', types[2],
                        mainText: ''),
                  ],
                );
              }
            }
          }
          return buildCircularIndicator();
        });
  }

  buildTile(String lottie, String title, {String? mainText}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      // margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 3.h,
                child: Lottie.asset(lottie),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    color: gBlackColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: widget.isSelected,
                child: Radio(
                  value: title,
                  activeColor: kPrimaryColor,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      submitValue(title);
                      selectedValue = value as String;
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            height: 1,
            color: gHintTextColor.withOpacity(0.3),
          ),
          SizedBox(height: 1.h),
          Text(
            mainText ??
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
            style: TextStyle(
              height: 1.5,
              fontSize: 8.sp,
              color: gBlackColor,
              fontFamily: "GothamBook",
            ),
          )
        ],
      ),
    );
  }

  buildList(List<History> history) {
    return SizedBox(
      height: 30.h,
      child: ListView.builder(
        itemCount: history.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Center(
            child: GestureDetector(
              onTap: (){
                setState(() {
                  selectedDay = history[index].day;
                });
                print("day :${history[index].day}");
                getDetails(history[index].day!);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(history[index].lottieReaction ?? '', height: (selectedDay == history[index].day) ? 11.h : 10.h),
                    SizedBox(height: 2.h),
                    Text(
                      'Day ${history[index].day}' ?? '',
                      style: TextStyle(
                          fontFamily: "GothamMedium",
                          color: gBlackColor,
                          fontSize: 10.sp),
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

  submitValue(String type) async {
    // mealType: breakfast, lunch, dinner
    // selectedType:
    // do -- 1
    // do-not -- 2
    // none-- 3

    String mealType = widget.title.trim().toLowerCase();
    int selectedType = (type == types[0])
        ? 1
        : (type == types[1])
            ? 2
            : 3;
    print(mealType);
    final res = await PostProgramService(repository: postProgramRepository)
        .submitPostProgramMealTrackingService(
            mealType, selectedType, widget.dayNumber);

    if (res.runtimeType == ErrorModel) {
      ErrorModel model = res as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    } else {
      PostProgramBaseModel model = res as PostProgramBaseModel;
      AppConfig().showSnackbar(context, model.message ?? '');
      Navigator.pop(context, type);
    }
  }

  void addSelectedValue(Data? data) {
    if (data!.dataDo!.isSelected == 1) {
      selectedValue = types[0];
    } else if (data!.doNot!.isSelected == 1) {
      selectedValue = types[1];
    } else if (data!.none!.isSelected == 1) {
      selectedValue = types[2];
    }
  }
}
