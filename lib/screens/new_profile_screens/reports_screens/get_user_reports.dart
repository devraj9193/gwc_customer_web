import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../model/dashboard_model/report_upload_model/child_report_list_model.dart';
import '../../../model/error_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/consultation_repository/get_report_repository.dart';
import '../../../services/consultation_service/report_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/show_photo_viewer.dart';
import '../../../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'my_reports_screen.dart';

class GetUserReports extends StatefulWidget {
  final List<ChildReportListModel> userReport;
  const GetUserReports({
    Key? key,
    required this.userReport,
  }) : super(key: key);

  @override
  State<GetUserReports> createState() => _GetUserReportsState();
}

class _GetUserReportsState extends State<GetUserReports> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: buildAppBar(
            () {
              Navigator.pop(context);
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                chooseFileUsingFilePicker();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                decoration: BoxDecoration(
                  color: gSitBackBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.upload_file,
                      color: gBlackColor,
                      size: 2.5.h,
                    ),
                    // SizedBox(width: 1.w),
                    Text(
                      "Upload",
                      style: TextStyle(
                          color: gBlackColor,
                          fontFamily: kFontMedium,
                          fontSize: 8.dp),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 3.w),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: SizedBox(
            width: MediaQuery.of(context).size.shortestSide > 600
                ? 40.w
                : double.maxFinite,
            child: buildUserUploaded(),
          ),
        ),
      ),
    );
  }

  buildUserUploaded() {
    return SingleChildScrollView(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.userReport.length,
        itemBuilder: ((context, index) {
          ChildReportListModel ind = widget.userReport[index];
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  ind.report.toString().split("/").last.split(',').length,
              itemBuilder: (_, i) {
                List<String> reportNameList =
                    ind.report.toString().split("/").last.split(',');
                return GestureDetector(
                  onTap: () async {
                    var origin = Uri.parse(ind.report.toString()).origin;
                    var path = Uri.parse(ind.report.toString()).path;
                    var dir =
                        path.substring(0, path.lastIndexOf('/')) + "/";
                    print("dir: $dir");
                    print(
                        "origin: ${Uri.parse(ind.report.toString()).origin}");
                    print(
                        "path: ${Uri.parse(ind.report.toString()).path}");

                    final url = origin + dir + reportNameList[i];
                    if (url.isNotEmpty) {
                      print("URL : $url");
                      if (url.toLowerCase().contains(".jpg") ||
                          url.toLowerCase().contains(".png") ||
                          url.toLowerCase().contains(".jpeg")) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => CustomPhotoViewer(url: url),
                          ),
                        );
                      } else {
                        if (await canLaunchUrl(Uri.parse(url ?? ''))) {
                          launch(url ?? '');
                        } else {
                          throw "Could not launch $url";
                        }
                        print("URL : $url");
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 2.w),
                    padding: EdgeInsets.symmetric(
                        vertical: 2.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image(
                          height: 4.h,
                          image: const AssetImage(
                              "assets/images/Group 2722.png"),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reportNameList[i],
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                style: TextStyle(
                                    height: 1.2,
                                    fontFamily: kFontMedium,
                                    color: gBlackColor,
                                    fontSize: 9.dp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: gsecondaryColor,
                          size: 2.h,
                        ),
                      ],
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }

  List<PlatformFile> medicalRecords = [];

  void chooseFileUsingFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      onFileLoading: (FilePickerStatus status) => print(status),
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result == null) return;

    medicalRecords = result.files;

    showUploadFilesList();

    print("medical Records : $medicalRecords");

    setState(() {});
  }

  bool showSubmitProgress = false;

  var submitProgressState;

  showUploadFilesList() {
    return showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            submitProgressState = setState;
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(width: 26.w),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Upload Files',
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
                          child: Icon(
                            Icons.clear,
                            color: gBlackColor,
                            size: 2.5.h,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    SizedBox(height: 1.h),
                    if (medicalRecords.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            itemCount: medicalRecords.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              final file = medicalRecords[index];
                              return buildPopUpRecordList(file, setState,
                                  index: index);
                            },
                          ),
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      child: Center(
                        child: ButtonWidget(
                          onPressed: () async {
                            submitUserRequestedUploadReport();
                          },
                          text: 'Submit',
                          isLoading: showSubmitProgress,
                          buttonWidth: 20.w,
                        ),
                        // IntrinsicWidth(
                        //   child: GestureDetector(
                        //     onTap: () async {
                        //       submitUserRequestedUploadReport();
                        //     },
                        //     child: Container(
                        //       margin: EdgeInsets.only(top: 3.h),
                        //       padding: EdgeInsets.symmetric(
                        //           vertical: 1.5.h, horizontal: 10.w),
                        //       decoration: BoxDecoration(
                        //         color: eUser().buttonColor,
                        //         borderRadius: BorderRadius.circular(8),
                        //         // border:
                        //         //     Border.all(color: gMainColor, width: 1),
                        //       ),
                        //       child: (showSubmitProgress)
                        //           ? buildThreeBounceIndicator(
                        //               color: gWhiteColor)
                        //           : Center(
                        //               child: Text(
                        //                 'Submit',
                        //                 style: TextStyle(
                        //                   fontFamily: kFontBold,
                        //                   color: gWhiteColor,
                        //                   fontSize: 11.dp,
                        //                 ),
                        //               ),
                        //             ),
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  buildPopUpRecordList(PlatformFile filename, Function setstate, {int? index}) {
    return ListTile(
      shape: const Border(bottom: BorderSide()),
      // leading: SizedBox(
      //     width: 50, height: 50, child: Image.file(File(filename.path!))),
      title: Text(
        filename.name,
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: kFontBold,
          fontSize: 11.dp,
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          medicalRecords.removeAt(index!);
          // item.removeAt(index);
          // _finalFiles.removeAt(index);
          setstate(() {});
        },
        child: const Icon(
          Icons.delete_outline_outlined,
          color: gMainColor,
        ),
      ),
    );
  }

  submitUserRequestedUploadReport() async {
    submitProgressState(() {
      showSubmitProgress = true;
    });

    widget.userReport.clear();

    final res = await ReportService(repository: repository)
        .submitUserReportUploadService(medicalRecords);
    print("submitDoctorRequestedReport res: $res");
    if (res.runtimeType == ErrorModel) {
      submitProgressState(() {
        showSubmitProgress = false;
      });
      final result = res as ErrorModel;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    } else {
      submitProgressState(() {
        showSubmitProgress = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const MyReportsScreen(),
        ),
      );
      setState(() {});
    }
    submitProgressState(() {
      showSubmitProgress = false;
    });
  }

  final ReportRepository repository = ReportRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
