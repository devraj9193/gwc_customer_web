import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final String questionNo;
  final bool questionSub;
  final String percentage;
  const QuestionWidget(
      {Key? key,
      required this.question,
      required this.questionNo,
      this.questionSub = false,
      required this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h,),
        margin: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
        decoration: BoxDecoration(
          color: gWhiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Center(
          child: buildLabelTextFields(question,
              fontSize: questionFont, questionSub: questionSub),
        ),
      ),
    );
  }
}
