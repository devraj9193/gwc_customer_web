import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/profile_model/feedback_model.dart';
import 'package:gwc_customer_web/repository/profile_repository/feedback_repo.dart';
import 'package:gwc_customer_web/services/profile_screen_service/feedback_service.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:http/http.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import '../../../repository/api_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/button_widget.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final feedbackController = TextEditingController();

  final _focusNode = FocusNode();

  bool isSubmitted = false;

  List<PlatformFile> files = [];
  List<File> fileFormatList = [];
  List<MultipartFile> newList = <MultipartFile>[];

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        print("focus changed");
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gBlackColor.withOpacity(0.5),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: kNumberCircleAmber,
              width: double.maxFinite,
              height: double.maxFinite,
              margin: EdgeInsets.only(top: 20.h),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.shortestSide > 600
                    ? 40.w
                    : double.maxFinite,
                height: double.maxFinite,
                margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 15.h,
                      padding: EdgeInsets.only(top: 3.h, left: 5.w, right: 3.w),
                      decoration: const BoxDecoration(
                        color: kNumberCircleAmber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Icon(
                                  Icons.feedback_outlined,
                                  color: gBlackColor,
                                  size: 6.h,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Send us your feedback!',
                                      style: TextStyle(
                                          fontFamily: kFontBold,
                                          color: gBlackColor,
                                          height: 1.5,
                                          fontSize: 18.dp),
                                    ),
                                    Text(
                                      'Do you have a suggestion or had any problem?\nLet us know in the fields below.',
                                      style: TextStyle(
                                          fontSize: 12.dp,
                                          color: gGreyColor.withOpacity(0.8),
                                          fontFamily: kFontBook),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: gBlackColor.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: gWhiteColor,
                                    size: 2.5.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 2.h),
                            Text(
                              'How would you rate your experience with our Program?',
                              style: TextStyle(
                                  fontFamily: "GothamRoundedBold_21016",
                                  color: gBlackColor,
                                  height: 2,
                                  fontSize: 12.dp),
                            ),
                            SizedBox(height: 1.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: EmojiFeedback(
                                rating: ratings,
                                enableFeedback: true,
                                elementSize: 70, spaceBetweenItems: 0,
                                inactiveElementBlendColor: Colors.transparent,
                                // gGreyColor.withOpacity(0.5),
                                emojiPreset: handDrawnEmojiPreset,
                                labelTextStyle: TextStyle(
                                  fontSize: 10.dp,
                                  fontFamily: kFontBook,
                                  color: gBlackColor,
                                ),
                                onChanged: (value) {
                                  setState(() => ratings = value!);
                                },
                              ),
                            ),
                            // buildRating(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 2.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tell us a bit more about why you choose $ratings',
                                    style: TextStyle(
                                      fontFamily: "GothamBold",
                                      color: gTextColor,
                                      fontSize: 11.dp,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Form(
                                    key: formKey,
                                    child: TextFormField(
                                      minLines: 6,
                                      maxLines: 8,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Tell us more';
                                        }
                                        return null;
                                      },
                                      focusNode: _focusNode,
                                      controller: feedbackController,
                                      keyboardType: TextInputType.multiline,
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: gMainColor, width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: gMainColor, width: 1),
                                        ),
                                        hintText:
                                            'Tell us about your journey.....',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  (files.isEmpty)
                                      ? GestureDetector(
                                          onTap: () {
                                            pickFromFile();
                                          },
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.folder),
                                              Text(
                                                'Upload File',
                                                style: TextStyle(
                                                    fontFamily: kFontBold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: gPrimaryColor),
                                              )
                                            ],
                                          ),
                                        )
                                      : Text(
                                          "Uploaded File",
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  "GothamRoundedBold_21016",
                                              color: gPrimaryColor,
                                              fontSize: 11.dp),
                                        ),
                                  if (files.isNotEmpty)
                                    ListView.builder(
                                      itemCount: files.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: ScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final file = files[index];
                                        return buildRecordList(file,
                                            index: index);
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 3.w, bottom: 3.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ButtonWidget(
                            onPressed: () {
                              if (ratings == 0.0) {
                                AppConfig().showSnackbar(
                                    context, "Please select the rating",
                                    isError: true);
                              } else if (formKey.currentState!.validate()) {
                                submitRating();

                              }
                            },
                            text: 'Submit',
                            isLoading: isSubmitted,
                            buttonWidth: 20.w,
                            radius: 8,
                            color: kNumberCircleAmber,
                            textColor: gBlackColor,
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     if (ratings == 0.0) {
                          //       AppConfig().showSnackbar(
                          //           context, "Please select the rating",
                          //           isError: true);
                          //     } else if (formKey.currentState!.validate()) {
                          //       submitRating();
                          //     }
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 5.w, vertical: 1.h),
                          //     decoration: BoxDecoration(
                          //       color: kNumberCircleAmber,
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: Center(
                          //       child: (isSubmitted)
                          //           ? buildThreeBounceIndicator(
                          //               color:
                          //                   eUser().threeBounceIndicatorColor)
                          //           : Text(
                          //               'Submit',
                          //               style: TextStyle(
                          //                 fontFamily: eUser().buttonTextFont,
                          //                 color: gBlackColor,
                          //                 fontSize: eUser().buttonTextSize,
                          //               ),
                          //             ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int ratings = 5;

  buildRecordList(PlatformFile file, {int? index}) {
    return ListTile(
      shape: const Border(bottom: BorderSide()),
      // leading: SizedBox(
      //     width: 50, height: 50, child: Image.file(File(filename.path!))),
      title: Text(
        file.name.split("/").last,
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
            files.removeAt(index!);
            item.removeAt(index);
            newList.removeAt(index);
            setState(() {});
          },
          child: const Icon(
            Icons.delete_outline_outlined,
            color: gMainColor,
          )),
    );
  }

  PlatformFile? objFile;
  List<PlatformFile>? _paths;
  List item = [];

  void pickFromFile() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg'],
      ))
          ?.files;

      var path2 = _paths?.single.bytes;

      var path3 = _paths?.single.name;

      if (!item.contains(path3)) {
        item.add(path3);
        File file = File(path3 ?? "");
        setState(() {
          objFile = _paths?.single;
          files.add(objFile!);
          // _finalFiles.add(file);
          print("files : $files");
          // print("_finalFiles : $_finalFiles");
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

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  void _delete(int index) {
    files.removeAt(index);
    fileFormatList.removeAt(index);
    setState(() {});
  }

  addFilesToList(File file) async {
    newList.clear();
    setState(() {
      fileFormatList.add(file);
    });

    for (int i = 0; i < fileFormatList.length; i++) {
      var stream =
          http.ByteStream(DelegatingStream.typed(fileFormatList[i].openRead()));
      var length = await fileFormatList[i].length();
      var multipartFile = http.MultipartFile("files[]", stream, length,
          filename: fileFormatList[i].path);
      newList.add(multipartFile);
    }
    for (var element in files) {
      newList.add(
        http.MultipartFile.fromBytes(
          "files[]",
          element.bytes as List<int>,
          filename: element.name,
        ),
      );
    }
    setState(() {});
  }

  submitRating() async {
    setState(() {
      isSubmitted = true;
    });
    Map feedback = {
      'rating': ratings.toString(),
      'feedback': feedbackController.text
    };

    final res = await FeedbackService(repository: repository)
        .submitFeedbackService(feedback, files);

    if (res.runtimeType == FeedbackModel) {
      FeedbackModel model = res as FeedbackModel;
      AppConfig().showSnackbar(context, model.errorMsg ?? '');
    } else {
      ErrorModel model = res as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    }
    setState(() {
      isSubmitted = false;
    });
  }

  final FeedbackRepository repository = FeedbackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  // Method to create the emoji feedback widget
  Widget _buildEmojiFeedback(IconData icon, String label,
      {Color color = Colors.grey}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 40),
        SizedBox(height: 0.5.h),
        Text(label),
      ],
    );
  }
}
