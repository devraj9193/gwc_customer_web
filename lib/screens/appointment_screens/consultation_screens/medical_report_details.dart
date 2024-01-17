/*
not using this ui
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MedicalReportDetails extends StatefulWidget {
  final String pdfLink;
  const MedicalReportDetails({Key? key, required this.pdfLink})
      : super(key: key);

  @override
  State<MedicalReportDetails> createState() => _MedicalReportDetailsState();
}

class _MedicalReportDetailsState extends State<MedicalReportDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewPdf();
  }

  viewPdf() async {
    if (await canLaunchUrl(Uri.parse(widget.pdfLink ?? ''))) {
      launch(widget.pdfLink ?? '');
      Navigator.pop(context);
    } else{
      // can't launch url, there is some error
      throw "Could not launch ${widget.pdfLink}";}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                    child: buildAppBar(() {}, isBackEnable: false),
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Colors.grey.withOpacity(0.5))
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          // shrinkWrap: true,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 1.5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // SizedBox(width: 26.w),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'Medical Report',
                                      style: TextStyle(
                                          fontFamily: "GothamRoundedBold_21016",
                                          color: gTextColor,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                                // SizedBox(width: 26.w),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: gMainColor, width: 1),
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      color: gMainColor,
                                      size: 1.6.h,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 5.w),
                              height: 1,
                              color: gMainColor,
                            ),
                            // SizedBox(height: 1.h),
                            Expanded(
                              child: SfPdfViewer.network(widget.pdfLink),
                            ),
                            // Text(
                            //   'Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.It has survived not only five centuries,but also the leap into electronic typesetting,remaining essentially unchanged.It was popularised in the 1960s with the release of Letraset sheets containing Lorem lpsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem lpsum. long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem lpsum is that it has amore_or_less normal distribution of letters, as opposed to using \'Content here,content here\',making it look like readable english. Many desktop publishing packages and web page editors now use Lorem lpsum as their default model text,and asearch for \'lorem lpsum\' will uncover many web sites still in their infancy.Various versions have evolved over the years,sometimes by accident, sometimes on purpose(injected humour and the like).',
                            //   style: TextStyle(
                            //       height: 1.5,
                            //       fontFamily: "GothamMedium",
                            //       color: gTextColor,
                            //       fontSize: 10.sp),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
