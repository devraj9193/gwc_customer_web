import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/dashboard_screen.dart';
import '../../../model/dashboard_model/report_upload_model/child_report_list_model.dart';
import '../../../model/dashboard_model/report_upload_model/report_list_model.dart';
import '../../../model/error_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/consultation_repository/get_report_repository.dart';
import '../../../services/consultation_service/report_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'get_user_reports.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MyReportsScreen extends StatefulWidget {
  final bool fromDashboard;
  const MyReportsScreen({
    Key? key,
    this.fromDashboard = false,
  }) : super(key: key);

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  final List myTabs = [
    {
      "text": 'User Uploaded',
      "images": "assets/images/user_reports_images.png",
    },
    {
      "text": 'Prescription',
      "images": "assets/images/prescription_images.png",
    },
    {
      "text": 'Medical Report',
      "images": "assets/images/MR_images.jpeg",
    },
    {
      "text": 'GMG',
      "images": "assets/images/gmg_images.png",
    },
    {
      "text": 'End Report',
      "images": "assets/images/end_report_images.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    getUserReportList();
  }

  bool showUploadProgress = false;
  List<ChildReportListModel> userReport = [];
  List<ChildReportListModel> prescriptionReport = [];
  List<ChildReportListModel> mrReport = [];
  List<ChildReportListModel> gmgReport = [];
  List<ChildReportListModel> endReport = [];

  getUserReportList() async {
    print("getUserReportList");
    showUploadProgress = true;
    final res = await ReportService(repository: repository)
        .getUploadedReportListListService();
    print(res.runtimeType);
    if (res.runtimeType == GetReportListModel) {
      GetReportListModel result = res;
      if (result.data != null) {
        setState(() {
          result.data?.forEach((e) {
            if (e.reportType == "mr_report") {
              mrReport.add(e);
            } else if (e.reportType == "prescription") {
              prescriptionReport.add(e);
            } else if (e.reportType == "gut_guide") {
              gmgReport.add(e);
            } else if (e.reportType == "program_end_report_user") {
              endReport.add(e);
            } else {
              userReport.add(e);
            }
          });
        });

        print("myTaps : ${myTabs[4]}");

        if (userReport.isEmpty) {
          print("userReport List : ${userReport.length}");
          myTabs.removeAt(0);
        }
        if (prescriptionReport.isEmpty) {
          print("Prescription List : ${prescriptionReport.length}");
          myTabs.removeAt(1);
        }
        if (mrReport.isEmpty) {
          print("mrReport List : ${mrReport.length}");
          myTabs.removeAt(2);
        }
        if (gmgReport.isEmpty) {
          print("gmgReport List : ${gmgReport.length}");
          // myTabs.removeAt(3);
        }
        if (endReport.isEmpty) {
          print("endReport List : ${endReport.length}");
          myTabs.removeLast();
        }
      }
      setState(() {
        showUploadProgress = false;
      });
    } else {
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        showUploadProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    child: buildAppBar(
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => DashboardScreen(
                                index: widget.fromDashboard ? 2 : 4),
                          ),
                        );
                      },
                    ),
                  ),
                  showUploadProgress
                      ? Center(
                    child: buildCircularIndicator(),
                  )
                      : Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Text(
                          "My Reports",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: kFontBold,
                            color: gBlackColor,
                            fontSize: 16.dp,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent:
                            MediaQuery.of(context).size.shortestSide > 600
                                ? 30.h
                                : 25.h,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            crossAxisCount:
                            MediaQuery.of(context).size.shortestSide > 600 ? 5 : 3,
                          ),
                          itemCount: myTabs.length,
                          itemBuilder: (context, index) {
                            return gridTile(myTabs[index]);
                          }),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  gridTile(dynamic items) {
    return InkWell(
      onTap: () async {
        if (items['text'] == "User Uploaded") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => GetUserReports(
                userReport: userReport,
              ),
            ),
          );
        } else if (items['text'] == "Prescription") {
          if (prescriptionReport.isNotEmpty) {
            if (await canLaunchUrl(
                Uri.parse(prescriptionReport.first.report ?? ''))) {
              launch(prescriptionReport.first.report ?? '');
            } else {
              throw "Could not launch ${prescriptionReport.first.report}";
            }
          } else {
            AppConfig().showSnackbar(context, 'No Data', isError: true);
          }
        } else if (items['text'] == "Medical Report") {
          if (mrReport.isNotEmpty) {
            if (await canLaunchUrl(Uri.parse(mrReport.first.report ?? ''))) {
              launch(mrReport.first.report ?? '');
            } else {
              throw "Could not launch ${mrReport.first.report}";
            }
          } else {
            AppConfig().showSnackbar(context, 'No Data', isError: true);
          }
        } else if (items['text'] == "GMG") {
          if (gmgReport.isNotEmpty) {
            if (await canLaunchUrl(Uri.parse(gmgReport.first.report ?? ''))) {
              launch(gmgReport.first.report ?? '');
            } else {
              throw "Could not launch ${gmgReport.first.report}";
            }
          } else {
            AppConfig().showSnackbar(context, 'No Data', isError: true);
          }
        } else if (items['text'] == "End Report") {
          if (endReport.isNotEmpty) {
            if (await canLaunchUrl(Uri.parse(endReport.first.report ?? ''))) {
              launch(endReport.first.report ?? '');
            } else {
              throw "Could not launch ${endReport.first.report}";
            }
          } else {
            AppConfig().showSnackbar(context, 'No Data', isError: true);
          }
        }
      },
      child: Container(
          decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: kLineColor,
                blurRadius: 2,
                offset: Offset(0.9, 1.5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.asset(
                  items['images'],
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.shortestSide > 600
                      ? 23.h
                      : 18.h,
                  width: double.maxFinite,
                ),
              ),
              SizedBox(height: 1.5.h),
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Text(
                  items['text'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: kFontMedium, fontSize: 14.dp),
                ),
              )
            ],
          )),
    );
  }

  final ReportRepository repository = ReportRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
