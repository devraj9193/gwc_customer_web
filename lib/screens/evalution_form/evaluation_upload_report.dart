/*
this is to upload the reports if they have any

here they can skip
ot if they have any report they can add
while submit 2 options are there
all uploaded/ not all uploaded

while uploading we will pass last 2 screen data from here
so we r taking evaluationModelFormat1, evaluationModelFormat2 these 2 params

Api used: POST
var submitEvaluationFormUrl = "${AppConfig().BASE_URL}/api/submitForm/evaluation_form";

 */

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../../model/dashboard_model/report_upload_model/report_upload_model.dart';
import '../../model/error_model.dart';
import '../../model/evaluation_from_models/evaluation_model_format1.dart';
import '../../model/evaluation_from_models/evaluation_model_format2.dart';
import '../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import '../../model/new_user_model/about_program_model/about_program_model.dart';
import '../../repository/api_service.dart';
import '../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../repository/new_user_repository/about_program_repository.dart';
import '../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../services/new_user_service/about_program_service.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/video/normal_video.dart';
import '../../widgets/widgets.dart';
import '../dashboard_screen.dart';

class EvaluationUploadReport extends StatefulWidget {
  final EvaluationModelFormat1? evaluationModelFormat1;
  final EvaluationModelFormat2? evaluationModelFormat2;
  final bool showData;
  final ChildGetEvaluationDataModel? childGetEvaluationDataModel;

  const EvaluationUploadReport({
    Key? key,
    this.evaluationModelFormat1,
    this.evaluationModelFormat2,
    this.childGetEvaluationDataModel,
    this.showData = false,
  }) : super(key: key);

  @override
  State<EvaluationUploadReport> createState() => _EvaluationUploadReportState();
}

class _EvaluationUploadReportState extends State<EvaluationUploadReport> {
  dynamic padding = EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w);
  final _prefs = AppConfig().preferences;
  List<PlatformFile> medicalRecords = [];
  List<File> _finalFiles = [];
  List item = [];

  List showMedicalReport = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideoUrl();
    print(widget.showData);
    if (widget.showData) {
      storeDetails();
    }
  }

  void storeDetails() {
    print(
        "model.medicalReport.runtimeType: ${widget.childGetEvaluationDataModel?.medicalReport!.split(',')}");
    List list =
        jsonDecode(widget.childGetEvaluationDataModel?.medicalReport ?? '');
    print("report list: $list ${list.length}");

    showMedicalReport.clear();
    if (list.isNotEmpty) {
      list.forEach((element) {
        print(element);
        showMedicalReport.add(element.toString());
      });
    }
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }

  getVideoUrl() async {
    final res = await AboutProgramService(repository: repository)
        .serverAboutProgramService();

    if (res.runtimeType == ErrorModel) {
      final msg = res as ErrorModel;
      Future.delayed(Duration.zero).whenComplete(() {
        AppConfig().showSnackbar(context, msg.message ?? '', isError: true);
      });
    } else {
      final result = res as AboutProgramModel;
      if (result.uploadReportVideo != null &&
          result.uploadReportVideo!.isNotEmpty) {
        // addUrlToVideoPlayer(result.uploadReportVideo ?? '');
        addUrlToVideoPlayerChewie(result.uploadReportVideo ?? '');
      } else {
        Future.delayed(Duration.zero).whenComplete(() {
          AppConfig()
              .showSnackbar(context, AppConfig.oopsMessage, isError: true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: const AssetImage("assets/images/eval_bg.png"),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.lighten)),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: showUI(context),
        ),
      ),
    );
  }

  showUI(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(
                () {
                  Navigator.pop(context, true);
                },
                isBackEnable: true,
              ),
              SizedBox(
                width: 3.w,
              ),
              // FittedBox(
              //   child: Text(
              //     "Gut Wellness Club \nEvaluation Form",
              //     textAlign: TextAlign.start,
              //     style: TextStyle(
              //         fontFamily: "PoppinsMedium",
              //         color: Colors.white,
              //         fontSize: 12.sp),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Expanded(
          child: Container(
              width: double.maxFinite,
              padding:
                  EdgeInsets.only(left: 3.w, top: 3.h, right: 3.w, bottom: 0.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: widget.showData ? showFiles() : buildUI(context)),
        ),
      ],
    );
  }

  showFiles() {
    print(showMedicalReport.runtimeType);
    showMedicalReport.forEach((e) {
      print("e==> $e ${e.runtimeType}");
    });
    final widgetList = showMedicalReport
        .map<Widget>((element) => buildUploadedRecordList(element))
        .toList();
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: widgetList,
          ),
          IntrinsicWidth(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const DashboardScreen(
                      index: 2,
                    ),
                  ),
                );
              },
              child: Container(
                width: 40.w,
                height: 5.h,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: eUser().buttonColor,
                  borderRadius:
                      BorderRadius.circular(eUser().buttonBorderRadius),
                  // border: Border.all(
                  //     color: eUser().buttonBorderColor,
                  //     width: eUser().buttonBorderWidth
                  // ),
                ),
                child: (showUploadProgress)
                    ? buildThreeBounceIndicator()
                    : Center(
                        child: Text(
                          'Go To Home',
                          style: TextStyle(
                            fontFamily: eUser().buttonTextFont,
                            color: eUser().buttonTextColor,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildUploadedRecordList(String filename, {int? index}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: getColor(Colors.white, const Color(0xffCBFE86)),
          backgroundColor: getColor(Colors.white, const Color(0xffCBFE86)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                filename.split("/").last,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontSize: 11.sp,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: gMainColor,
            ),
          ],
        ),
      ),
    );
  }

  buildUI(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Upload your reports here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: eUser().mainHeadingFont,
                      color: eUser().mainHeadingColor,
                      fontSize: eUser().mainHeadingFontSize),
                ),
                SizedBox(
                  height: 1.h,
                ),
                buildVideoPlayer(),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    "Your prior medical reports help us analyse the root cause & contributing factor. Do upload all possible reports",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.5,
                        fontFamily: kFontBold,
                        color: gTextColor,
                        fontSize: 10.sp),
                  ),
                ),
                // upload button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: GestureDetector(
                    onTap: () async {
                      chooseFileUsingFilePicker();
                      // showChooserSheet();
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: gMainColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(2, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: const AssetImage(
                                  "assets/images/Group 3323.png"),
                              height: 2.5.h,
                            ),
                            Text(
                              "   Choose file",
                              style: TextStyle(
                                  fontFamily: "GothamMedium",
                                  color: Colors.black,
                                  fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // //------Show file name when file is selected
                // if (objFile != null) Text("File name : ${objFile?.name}"),
                // //------Show file size when file is selected
                // if (objFile != null) Text("File size : ${objFile?.size} bytes"),

                SizedBox(
                  height: 0.5.h,
                ),
                if (_finalFiles.isNotEmpty)
                  ListView.builder(
                    itemCount: _finalFiles.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final file = _finalFiles[index];
                      return buildFile(file, index);
                    },
                  ),
                // SizedBox(
                //   height: 5.h,
                // ),
                //submit button
                Visibility(
                  visible: medicalRecords.isEmpty,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          "Don't have any reports?",
                          style: TextStyle(
                            fontFamily: kFontBook,
                            color: gHintTextColor,
                          ),
                        ),
                      ),
                      MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 0.8),
                        child: Center(
                          child: GestureDetector(
                              onTap: () {
                                // if(_videoPlayerController != null){
                                //   _videoPlayerController!.stop();
                                // }
                                if (videoPlayerController != null) {
                                  videoPlayerController!.pause();
                                }
                                if (_chewieController != null) {
                                  _chewieController!.pause();
                                }

                                Map finalMap = {
                                  "part": "3",
                                };
                                // finalMap.addAll(widget.evaluationModelFormat1!
                                //     .toMap()
                                //     .cast());
                                // finalMap.addAll(widget.evaluationModelFormat2!
                                //     .toMap()
                                //     .cast());

                                callApi(finalMap, null);

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (ctx) => PersonalDetailsScreen2(
                                //             evaluationModelFormat1: widget.evaluationModelFormat1,
                                //             medicalReportList: null
                                //         )
                                //     ));
                              },
                              child: Container(
                                width: 30.w,
                                height: 4.h,
                                margin: EdgeInsets.symmetric(vertical: 2.h),
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: eUser().buttonColor,
                                  borderRadius: BorderRadius.circular(
                                      eUser().buttonBorderRadius),
                                  // border: Border.all(
                                  //     color: eUser().buttonBorderColor,
                                  //     width: eUser().buttonBorderWidth
                                  // ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontFamily: eUser().buttonTextFont,
                                      color: eUser().buttonTextColor,
                                      fontSize: eUser().buttonTextSize,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
           visible: medicalRecords.isNotEmpty,
          child: Padding(
            padding: padding,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  // final res = await _videoPlayerController?.isPlaying();
                  // if(res != null && res == true){
                  //
                  // }
                   if (medicalRecords.isNotEmpty) {
                    showUploadReportPopup();

                    // if(videoPlayerController != null){
                    //   videoPlayerController!.stop();
                    // }
                    if (_chewieController != null) {
                      _chewieController!.videoPlayerController.pause();
                    }
                  }
                },
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: eUser().buttonColor,
                    borderRadius:
                        BorderRadius.circular(eUser().buttonBorderRadius),
                    // border: Border.all(
                    //     color: eUser().buttonBorderColor,
                    //     width: eUser().buttonBorderWidth
                    // ),
                  ),
                  child: (showUploadProgress)
                      ? buildThreeBounceIndicator()
                      : Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontFamily: eUser().buttonTextFont,
                              color: eUser().buttonTextColor,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  PlatformFile? objFile;
  List<PlatformFile>? _paths;

  void chooseFileUsingFilePicker() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
      ))
          ?.files;

          var path2 =_paths?.single.bytes;

          var path3 = _paths?.single.name;

          if (!item.contains(path3)) {
            item.add(path3);
            File file = File(path3 ?? "");
            setState(() {
              objFile = _paths?.single;
              medicalRecords.add(objFile!);
              _finalFiles.add(file);
              print("medical reports : $medicalRecords");
              print("_finalFiles : $_finalFiles");
            });
          } else {
            // Scaffold.of(globalkey2.currentContext??context)
            AppConfig().showSnackbar(context, "File Already Exist", isError: true);
          }

    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  // void pickFromFile() async {
  //   final result = await FilePicker.platform
  //       .pickFiles(withReadStream: true, allowMultiple: false);
  //
  //   if (result == null) return;
  //   if (result.files.first.extension!.contains("pdf") ||
  //       result.files.first.extension!.contains("png") ||
  //       result.files.first.extension!.contains("jpg") ||
  //       result.files.first.extension!.contains("jpeg")) {
  //     var path2 = result.files.single.path;
  //
  //     if (!item.contains(path2)) {
  //       item.add(path2);
  //       File file = File(path2 ?? "");
  //       setState(() {
  //         medicalRecords.add(result.files.first);
  //         _finalFiles.add(file);
  //       });
  //     } else {
  //       // Scaffold.of(globalkey2.currentContext??context)
  //       AppConfig().showSnackbar(context, "File Already Exist", isError: true);
  //     }
  //   } else {
  //     AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
  //         isError: true);
  //   }
  //   setState(() {});
  // }

  showChooserSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      child: Text(
                        'Choose Profile Pic',
                        style: TextStyle(
                          color: gTextColor,
                          fontFamily: kFontMedium,
                          fontSize: 12.sp,
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: gHintTextColor,
                          width: 3.0,
                        ),
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              getImageFromCamera();
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_enhance_outlined,
                                  color: gMainColor,
                                ),
                                Text(
                                  'Camera',
                                  style: TextStyle(
                                    color: gTextColor,
                                    fontFamily: kFontMedium,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          width: 5,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border(
                            right: BorderSide(
                              color: gHintTextColor,
                              width: 1,
                            ),
                          )),
                        ),
                        TextButton(
                            onPressed: () {
                              pickFromFile();
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  color: gMainColor,
                                ),
                                Text(
                                  'Gallery',
                                  style: TextStyle(
                                    color: gTextColor,
                                    fontFamily: kFontMedium,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  File? _image;

  Future getImageFromCamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      if (getFileSize(_image!) <= 12) {
        print("filesize: ${getFileSize(_image!)}Mb");
        // addFilesToList(_image!);
        _finalFiles.add(_image!);
      } else {
        print("filesize: ${getFileSize(_image!)}Mb");

        AppConfig()
            .showSnackbar(context, "File size must be <12Mb", isError: true);
      }
    });
    print("captured image: $_image");
  }

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  void pickFromFile() async {
    final result = await FilePicker.platform
        .pickFiles(withReadStream: true, allowMultiple: false);

    if (result == null) return;
    if (result.files.first.extension!.contains("pdf") ||
        result.files.first.extension!.contains("png") ||
        result.files.first.extension!.contains("jpg") ||
        result.files.first.extension!.contains("jpeg")) {
      var path2 = result.files.single.path;

      if (!item.contains(path2)) {
        item.add(path2);
        File file = File(path2 ?? "");
        setState(() {
          medicalRecords.add(result.files.first);
          _finalFiles.add(file);
          print("medical reports : $medicalRecords");
          print("_finalFiles : $_finalFiles");
        });
      } else {
        // Scaffold.of(globalkey2.currentContext??context)
        AppConfig().showSnackbar(context, "File Already Exist", isError: true);
      }
    } else {
      AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
          isError: true);
    }
    setState(() {});
  }

  Widget buildFile(File file, int index) {
    return buildRecordList(file, index: index);

    // return Wrap(
    //   children: [
    //     RawChip(
    //         label: Text(file.name),
    //       deleteIcon: Icon(
    //         Icons.cancel,
    //       ),
    //       deleteIconColor: gMainColor,
    //       onDeleted: (){
    //         medicalRecords.removeAt(index);
    //         setState(() {});
    //       },
    //     )
    //   ],
    // );
  }

  buildRecordList(File filename, {int? index}) {
    return ListTile(
      shape: Border(bottom: BorderSide()),
      // leading: SizedBox(
      //     width: 50, height: 50, child: Image.file(File(filename.path!))),
      title: Text(
        filename.path.split("/").last,
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: kFontBold,
          fontSize: 11.sp,
        ),
      ),
      trailing: GestureDetector(
          onTap: () {
            medicalRecords.removeAt(index!);
            item.removeAt(index!);
            _finalFiles.removeAt(index);
            setState(() {});
          },
          child: const Icon(
            Icons.delete_outline_outlined,
            color: gMainColor,
          )),
    );
    // return Padding(
    //   padding: EdgeInsets.symmetric(vertical: 1.5.h),
    //   child: OutlinedButton(
    //     onPressed: () {},
    //     style: ButtonStyle(
    //       overlayColor: getColor(Colors.white, const Color(0xffCBFE86)),
    //       backgroundColor: getColor(Colors.white, const Color(0xffCBFE86)),
    //     ),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: Text(
    //             filename.split("/").last,
    //             textAlign: TextAlign.start,
    //             maxLines: 2,
    //             overflow: TextOverflow.ellipsis,
    //             style: TextStyle(
    //               fontFamily: "PoppinsBold",
    //               fontSize: 11.sp,
    //             ),
    //           ),
    //         ),
    //         (widget.showData)
    //             ? SvgPicture.asset(
    //           'assets/images/attach_icon.svg',
    //           fit: BoxFit.cover,
    //         )
    //             : GestureDetector(
    //             onTap: () {
    //               medicalRecords.removeAt(index!);
    //               setState(() {});
    //             },
    //             child: const Icon(
    //               Icons.delete_outline_outlined,
    //               color: gMainColor,
    //             )),
    //       ],
    //     ),
    //   ),
    // );
  }

  // vlc
  // VlcPlayerController? _videoPlayerController;
  // final _key = GlobalKey<VlcPlayerWithControlsState>();

  // Chewie
  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;

  // VideoPlayerController? _videoPlayerController;
  // CustomVideoPlayerController? _customVideoPlayerController;
  // final CustomVideoPlayerSettings _customVideoPlayerSettings =
  // CustomVideoPlayerSettings(
  //   controlBarAvailable: false,
  //   showPlayButton: true,
  //   playButton: Center(child: Icon(Icons.play_circle, color: Colors.white,),),
  //   settingsButtonAvailable: false,
  //   playbackSpeedButtonAvailable: false,
  //   placeholderWidget: Container(child: Center(child: CircularProgressIndicator()),color: gBlackColor,),
  // );

  bool showUploadProgress = false;

  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    // _videoPlayerController = VideoPlayerController.network(Uri.parse(url).toString());
    // _videoPlayerController!.initialize().then((value) => setState(() {}));
    // _customVideoPlayerController = CustomVideoPlayerController(
    //   context: context,
    //   videoPlayerController: _videoPlayerController!,
    //   customVideoPlayerSettings: _customVideoPlayerSettings,
    // );
    // _videoPlayerController!.play();
    // Wakelock.enable();
    videoPlayerController = VideoPlayerController.network(url);
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        hideControlsTimer: Duration(seconds: 3),
        showControls: false);
    if (!await WakelockPlus.enabled) {
      WakelockPlus.enable();
    }
    setState(() {});
  }

  // addUrlToVideoPlayer(String url) async {
  //   print("url"+ url);
  //   // _videoPlayerController = VideoPlayerController.network(Uri.parse(url).toString());
  //   // _videoPlayerController!.initialize().then((value) => setState(() {}));
  //   // _customVideoPlayerController = CustomVideoPlayerController(
  //   //   context: context,
  //   //   videoPlayerController: _videoPlayerController!,
  //   //   customVideoPlayerSettings: _customVideoPlayerSettings,
  //   // );
  //   // _videoPlayerController!.play();
  //   // Wakelock.enable();
  //
  //   _videoPlayerController = VlcPlayerController.network(
  //     Uri.parse(url).toString(),
  //     // url,
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.auto,
  //     autoPlay: true,
  //     options: VlcPlayerOptions(
  //       advanced: VlcAdvancedOptions([
  //         VlcAdvancedOptions.networkCaching(2000),
  //       ]),
  //       subtitle: VlcSubtitleOptions([
  //         VlcSubtitleOptions.boldStyle(true),
  //         VlcSubtitleOptions.fontSize(30),
  //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
  //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
  //         // works only on externally added subtitles
  //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
  //       ]),
  //       http: VlcHttpOptions([
  //         VlcHttpOptions.httpReconnect(true),
  //       ]),
  //       rtp: VlcRtpOptions([
  //         VlcRtpOptions.rtpOverRtsp(true),
  //       ]),
  //     ),
  //   )..initialize()..play();
  //   if (!await Wakelock.enabled) {
  //     Wakelock.enable();
  //   }
  //   setState(() {
  //
  //   });
  // }

  buildVideoPlayer() {
    if (_chewieController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: gPrimaryColor, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Center(
              child: OverlayVideo(
                controller: _chewieController!,
              ),
            ),
          ),
        ),
      );
    }
    // else if(_videoPlayerController != null){
    //   return Stack(
    //     children: [
    //       AspectRatio(
    //         aspectRatio: 16/9,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5),
    //             border: Border.all(color: gPrimaryColor, width: 1),
    //             // boxShadow: [
    //             //   BoxShadow(
    //             //     color: Colors.grey.withOpacity(0.3),
    //             //     blurRadius: 20,
    //             //     offset: const Offset(2, 10),
    //             //   ),
    //             // ],
    //           ),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(5),
    //             child: Center(
    //               // child: CustomVideoPlayer(
    //               //   customVideoPlayerController: _customVideoPlayerController!,
    //               // ),
    //                 child: VlcPlayerWithControls(
    //                   key: _key,
    //                   controller: _videoPlayerController!,
    //                   showVolume: false,
    //                   showVideoProgress: false,
    //                   seekButtonIconSize: 10.sp,
    //                   playButtonIconSize: 14.sp,
    //                   replayButtonSize: 10.sp,
    //                 )
    //             ),
    //           ),
    //         ),
    //       ),
    //       // Positioned(child:
    //       // AspectRatio(
    //       //   aspectRatio: 16/9,
    //       //   child: GestureDetector(
    //       //     onTap: (){
    //       //       print("onTap");
    //       //       if(_videoPlayerController != null){
    //       //         if(_customVideoPlayerController!.videoPlayerController.value.isPlaying){
    //       //           _customVideoPlayerController!.videoPlayerController.pause();
    //       //         }
    //       //         else{
    //       //           _customVideoPlayerController!.videoPlayerController.play();
    //       //         }
    //       //       }
    //       //     },
    //       //   ),
    //       // )
    //       // )
    //
    //     ],
    //   );
    // }
    else {
      return SizedBox.shrink();
    }
  }

  showUploadReportPopup() {
    return showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: showReportUploadStatus(setState),
            );
          });
        });
  }

  showReportUploadStatus(Function setState) {
    print("medical Reports : $medicalRecords");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showRadioList("Uploaded all report.", setState),
          showRadioList("Not all reports uploaded.", setState),
          SizedBox(
            height: 2.h,
          ),
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.75),
            child: Center(
              child: GestureDetector(
                  onTap: () {
                    EvaluationModelFormat1? model =
                        widget.evaluationModelFormat1;
                    model?.allReportsUploaded = selectedUploadRadio;
                    // 28 items if other is null
                    print(model?.toMap());
                    // if(_videoPlayerController != null){
                    //   _videoPlayerController!.stop();
                    // }
                    if (videoPlayerController != null)
                      videoPlayerController!.pause();
                    if (_chewieController != null) _chewieController!.pause();

                    Map finalMap = {
                      "part": "3",
                    };

                    print("medical Reportsss : $medicalRecords");
                    // finalMap
                    //     .addAll(widget.evaluationModelFormat1!.toMap().cast());
                    // finalMap
                    //     .addAll(widget.evaluationModelFormat2!.toMap().cast());
                    // uploadSelectedFile(
                    //     finalMap, medicalRecords.map((e) => e.bytes).toList());
                    callApi(
                        finalMap, medicalRecords.map((e) => e.bytes).toList());
                  },
                  child: Container(
                    width: 35.w,
                    height: 4.h,
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: eUser().buttonColor,
                      borderRadius:
                          BorderRadius.circular(eUser().buttonBorderRadius),
                    ),
                    child: Center(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontFamily: eUser().buttonTextFont,
                          color: eUser().buttonTextColor,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }

  String selectedUploadRadio = "";

  showRadioList(String name, Function setstate) {
    return GestureDetector(
      onTap: () {
        setstate(() {
          selectedUploadRadio = name;
        });
      },
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Radio(
              value: name,
              activeColor: kPrimaryColor,
              groupValue: selectedUploadRadio,
              onChanged: (value) {
                setstate(() {
                  selectedUploadRadio = name;
                });
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              name,
              style: buildTextStyle(
                  color:
                      name == selectedUploadRadio ? kTextColor : gHintTextColor,
                  fontFamily:
                      name == selectedUploadRadio ? kFontMedium : kFontBook),
            ),
          ),
        ],
      ),
    );
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  Future<void> disposePlayer() async {
    // if(_videoPlayerController != null){
    //   _videoPlayerController!.dispose();
    // }

    if (videoPlayerController != null) videoPlayerController!.dispose();
    if (_chewieController != null) _chewieController!.dispose();
    // if(_customVideoPlayerController != null){
    //   _customVideoPlayerController!.dispose();
    // }
    if (await WakelockPlus.enabled) {
      WakelockPlus.disable();
    }
  }

  bool isSubmitPressed = false;
  final _pref = AppConfig().preferences;

  void uploadSelectedFile(Map form, List? medicalReports) async {
    //---Create http package multipart request object
    Map<String, String> m2 = Map.from(form);
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(submitEvaluationFormUrl),
    );

    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": "Bearer ${_prefs!.getString(AppConfig().BEARER_TOKEN)}",
    };
    if (medicalReports != null) {
      medicalReports.forEach((element) async {
        request.files.add(
            await http.MultipartFile.fromBytes('medical_report[]', element));
      });
    }
    request.headers.addAll(headers);
    request.fields.addAll(m2);

    //-----add selected file with request
    request.files.add(http.MultipartFile(
        "medical_report[]", objFile!.readStream!, objFile!.size,
        filename: objFile?.name));

    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);
  }

  void callApi(Map form, List? medicalReports) async {
    setState(() {
      isSubmitPressed = true;
    });

    print("medical report : $medicalReports");

    final res = await EvaluationFormService(repository: evalRepository)
        .submitEvaluationFormService(form, medicalRecords);
    // print("eval form response" + res.runtimeType.toString());
    if (res.runtimeType == ReportUploadModel) {
      ReportUploadModel result = res;
      setState(() {
        isSubmitPressed = false;
      });
      _pref!.setString(AppConfig.EVAL_STATUS, "evaluation_done");
      // AppConfig().showSnackbar(context, result.message ?? '');
      Get.offAll(const DashboardScreen(
        index: 2,
      ));
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (context) =>
      //       const DashboardScreen()
      //   ), (route) {
      //     print("route.currentResult:${route.currentResult}");
      //     print(route.isFirst);
      //   return route.isFirst;
      // }
      // );
    } else {
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        isSubmitPressed = false;
      });
    }
  }

  final EvaluationFormRepository evalRepository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
