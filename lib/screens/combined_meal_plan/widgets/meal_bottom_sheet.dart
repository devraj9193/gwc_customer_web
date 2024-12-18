import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../widgets/constants.dart';

class MealBottomSheet extends StatefulWidget {
  final String? notes;
  const MealBottomSheet({Key? key, this.notes}) : super(key: key);

  @override
  State<MealBottomSheet> createState() => _MealBottomSheetState();
}

class _MealBottomSheetState extends State<MealBottomSheet> {
  bool showSecond = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: AnimatedCrossFade(
            firstChild: Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height / 3,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // _showSecond = !_showSecond;
                        });
                      },
                      child: Container(
                        height: 1.h,
                        width: 20.w,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: kBottomSheetHeadGreen.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Center(
                    child: Text(
                      "Important Note",
                      style: TextStyle(
                          fontSize: bottomSheetHeadingFontSize,
                          fontFamily: bottomSheetHeadingFontFamily,
                          height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: HtmlWidget(
                      widget.notes ?? '',
                    ),
                  ),
                ],
              ),
            ),
            // secondChild: Container(
            //     constraints: BoxConstraints.expand(
            //       height: MediaQuery.of(context).size.height / 3,
            //     ),
            //     padding: const EdgeInsets.all(20),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Center(
            //           child: HtmlWidget(
            //             widget.notes ?? '',
            //           ),
            //         ),
            //       ],
            //     )),
            crossFadeState: showSecond
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400), secondChild: const SizedBox(),
          ),
          duration: const Duration(milliseconds: 400),
        ),
      ),
    );
  }
}
