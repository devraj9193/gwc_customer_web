/*
we r showing Mr report from the link using syncfusion pdf viewer

we need the report link from the dashboard screen

once we open we need to call this api when isMrread is false
var mrReadUrl = "/api/getData/is_mr_report_read";

 */

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../repository/api_service.dart';
import '../../../repository/dashboard_repo/gut_repository/dashboard_repository.dart';
import '../../../services/dashboard_service/gut_service/dashboard_data_service.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'medical_report_details.dart';
import 'package:http/http.dart' as http;

class MedicalReportScreen extends StatefulWidget {
  /// this is used to show the mr card on top when newly uploaded
  final String isMrRead;

  final String pdfLink;
  MedicalReportScreen({Key? key, required this.pdfLink, this.isMrRead = "1"})
      : super(key: key);

  @override
  State<MedicalReportScreen> createState() => _MedicalReportScreenState();
}

class _MedicalReportScreenState extends State<MedicalReportScreen> {
  late GutDataService _gutDataService;

  submitIsMrRead() async {
    _gutDataService = GutDataService(repository: repository);
    await _gutDataService.submitIsMrReadService();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewPdf();
  }

  viewPdf() async {
    if (!await launchUrl(Uri.parse(widget.pdfLink.toString()))) {
      Navigator.pop(context);
      throw Exception('Could not launch ${widget.pdfLink.toString()}');

    } else {
      // can't launch url, there is some error
      throw "Could not launch ${widget.pdfLink.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMrRead == "0") {
      submitIsMrRead();
    }

    print(widget.pdfLink);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
          child: Column(
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  "MEDICAL REPORT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontMedium,
                      color: gTextColor,
                      fontSize: 12.dp),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SfPdfViewer.network(this.widget.pdfLink),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final GutDataRepository repository = GutDataRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
