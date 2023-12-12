import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gwc_customer_web/model/faq_model/faq_list_model.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

import 'faq_screen.dart';
import 'package:intl/intl.dart';
class FaqDetailedList extends StatefulWidget {
  List<FaqList>? faqList;
  FaqDetailedList({Key? key, this.faqList}) : super(key: key);

  @override
  State<FaqDetailedList> createState() => _FaqDetailedListState();
}

class _FaqDetailedListState extends State<FaqDetailedList> {

  List<FaqList> questions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("widget.faqList");
    print(widget.faqList);
    if(widget.faqList != null){
      questions.addAll(widget.faqList!);
    }

    questions.forEach((element) {
      print("${element.question}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return expansionQueries();
  }

  expansionQueries(){
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 1.h),
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 3.h),
              Expanded(child: (questions.isNotEmpty)
                  ? ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: questions.length,
                  itemBuilder: (_, index) {
                    print("checking");
                    print(questions[index].question!);
                    return ExpansionTile(
                      title: Text(
                        questions[index].question ?? '',
                        style: TextStyle(
                          color: gTextColor,
                          fontSize: 12.sp,
                          fontFamily: kFontMedium,
                        ),
                      ),
                      // leading: Image(
                      //   image: AssetImage("assets/images/Group 2747.png"),
                      // ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: buildMenuItem(
                            text: Bidi.stripHtmlIfNeeded(questions[index].answer!),
                          ),
                        )
                      ],
                    );
                  })
                  : Center(
                child: Image(
                  image: AssetImage("assets/images/no_data_found.png"),
                  fit: BoxFit.scaleDown,
                ),
              )
              )
            ],
          ),
        )
    );
  }

  Widget buildMenuItem({
    required String text,
    VoidCallback? onClicked,
  }) {
    const color = kPrimaryColor;
    const hoverColor = Colors.grey;

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
