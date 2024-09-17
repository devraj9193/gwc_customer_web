import 'package:flutter/material.dart';
import 'package:gwc_customer_web/model/faq_model/faq_list_model.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'faq_answers_screen.dart';

class FaqDetailedList extends StatefulWidget {
  final List<FaqList>? faqList;
  const FaqDetailedList({Key? key, this.faqList}) : super(key: key);

  @override
  State<FaqDetailedList> createState() => _FaqDetailedListState();
}

class _FaqDetailedListState extends State<FaqDetailedList> {
  List<FaqList> questions = [];

  @override
  void initState() {
    super.initState();
    print("widget.faqList");
    print(widget.faqList);
    if (widget.faqList != null) {
      questions.addAll(widget.faqList!);
    }

    for (var element in questions) {
      print("${element.question}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return expansionQueries();
  }

  expansionQueries() {
    return SafeArea(
        child: Scaffold(
      backgroundColor: profileBackGroundColor,
      body: Column(
        children: [
          SizedBox(height: 1.h),
          buildAppBar(() {
            Navigator.pop(context);
          }),
          SizedBox(height: 3.h),
          Expanded(
            child: (questions.isNotEmpty)
                ? ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: questions.length,
                    itemBuilder: (_, index) {
                      print("checking");
                      print(questions[index].question!);
                      return buildList(
                        questions[index].question ?? '',(){
                        Navigator.of(context).push(
                          _createRoute(
                            FaqAnswerScreen(
                              faqList:questions[index],
                            ),
                          ),
                        );
                      }
                      );
                      //   ExpansionTile(
                      //   expandedAlignment: Alignment.topLeft,
                      //   title: Text(
                      //     questions[index].question ?? '',
                      //     style: TextStyle(
                      //       color: gTextColor,
                      //       fontSize: 14.dp,
                      //       fontFamily: kFontMedium,
                      //     ),
                      //   ),
                      //   // leading: Image(
                      //   //   image: AssetImage("assets/images/Group 2747.png"),
                      //   // ),
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 1.w, vertical: 1.h),
                      //       child: buildMenuItem(
                      //         text: Bidi.stripHtmlIfNeeded(
                      //             questions[index].answer!),
                      //       ),
                      //     )
                      //   ],
                      // );
                    })
                : const Center(
                    child: Image(
                      image: AssetImage("assets/images/no_data_found.png"),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
          ),
        ],
      ),
    ));
  }

  buildList(String question, func) {
    return Center(
      child: GestureDetector(
        onTap: func,
        child: Container(
          width: MediaQuery.of(context).size.shortestSide > 600
              ? 50.w
              : double.maxFinite,
          height: 15.h,
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
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
          child: Center(
            child: Text(
              question,
              style: TextStyle(
                color: gTextColor,
                fontSize: 18.dp,
                fontFamily: kFontMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    VoidCallback? onClicked,
  }) {
    // const color = kPrimaryColor;
    // const hoverColor = Colors.grey;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          height: 1.3,
          fontFamily: eUser().userTextFieldFont,
          color: eUser().userTextFieldColor,
          fontSize: eUser().userTextFieldFontSize,
        ),
      ),
    );
    // return ListTile(
    //   minLeadingWidth: 0,
    //   title: Text(
    //     text,
    //     style: TextStyle(
    //       height: 1.3,
    //       fontFamily: eUser().userTextFieldFont,
    //       color: eUser().userTextFieldColor,
    //       fontSize: eUser().userTextFieldFontSize,
    //     ),
    //   ),
    //   hoverColor: hoverColor,
    //   onTap: onClicked,
    // );
  }

  // goto(FaqList faq) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => FaqAnswerScreen(
  //             faqList: faq,
  //             // question: faq.questions,
  //             // icon: faq.path,
  //             // answer: faq.answers
  //           )));
  // }
}

Route _createRoute(screenName) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screenName,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return Align(
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: 0.0,
          child: child,
        ),
      );
    },
  );
}
