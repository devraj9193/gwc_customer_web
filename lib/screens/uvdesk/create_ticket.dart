import 'dart:io';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_customer_web/screens/uvdesk/ticket_list.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import '../../model/error_model.dart';
import '../../repository/api_service.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';
import '../../services/uvdesk_service/uv_desk_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/unfocus_widget.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' show basename;


class CreateTicket extends StatefulWidget {
  const CreateTicket({Key? key}) : super(key: key);

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  bool showProgress = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  late UvDeskService _uvDeskService = UvDeskService(uvDeskRepo: repository);

  final _pref = AppConfig().preferences;

  late String _agentId = _pref?.getString(AppConfig.UV_SUCCESS_ID) ?? '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = _pref?.getString(AppConfig.User_Name) ?? '';
    emailController.text = _pref?.getString(AppConfig.User_Email) ?? '';

    Future.delayed(Duration.zero).whenComplete(() {
      titleController.addListener(() {
        setState(() {});
      });
      descriptionController.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.removeListener(() { });
    descriptionController.removeListener(() { });
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: SafeArea(child: Scaffold(
        backgroundColor: gBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1.h),
              child: buildAppBar(() {Navigator.pop(context); }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: Text("Raise A Ticket",
              style: TextStyle(
                fontFamily: kFontBold,
                fontSize: headingFont,
              ),
              textAlign: TextAlign.center,),
            ),
            Container(
              height: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 4.h),
                    Stack(
                      children: [
                        Container(
                          height: 6.h,
                          margin:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
                          padding: EdgeInsets.only(
                              left: 5.w, top: 0.6.h, bottom: 0.5.h, right: 0.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: gGreyColor.withOpacity(0.3),
                            ),
                          ),
                          child: TextFormField(
                            controller: nameController,
                            cursorColor: gPrimaryColor,
                            style: mainTextField(),
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: nameController.text.isEmpty
                                  ? const SizedBox()
                                  : InkWell(
                                onTap: () {
                                  nameController.clear();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: gTextColor,
                                  size: 2.h,
                                ),
                              ),
                              hintText: "",
                              border: InputBorder.none,
                              hintStyle: mainTextField(),
                            ),
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Positioned(
                          left: 6.w,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: kNumberCirclePurple,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Name",
                              style: TextStyle(
                                fontSize: smTextFontSize,
                                color: gWhiteColor,
                                fontFamily: kFontMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Stack(
                      children: [
                        Container(
                          height: 6.h,
                          margin:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
                          padding: EdgeInsets.only(
                              left: 5.w, top: 0.6.h, bottom: 0.5.h, right: 0.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: gGreyColor.withOpacity(0.3),
                            ),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            cursorColor: gPrimaryColor,
                            style: mainTextField(),
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: emailController.text.isEmpty
                                  ? const SizedBox()
                                  : InkWell(
                                onTap: () {
                                  emailController.clear();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: gTextColor,
                                  size: 2.h,
                                ),
                              ),
                              hintText: "",
                              border: InputBorder.none,
                              hintStyle: mainTextField(),
                            ),
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Positioned(
                          left: 6.w,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: kNumberCirclePurple,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: smTextFontSize,
                                color: gWhiteColor,
                                fontFamily: kFontMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Stack(
                      children: [
                        Container(
                          height: 6.h,
                          margin:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
                          padding: EdgeInsets.only(
                              left: 5.w, top: 0.6.h, bottom: 0.5.h, right: 0.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: gGreyColor.withOpacity(0.3),
                            ),
                          ),
                          child: TextFormField(
                            controller: titleController,
                            cursorColor: gPrimaryColor,
                            style: mainTextField(),
                            decoration: InputDecoration(
                              suffixIcon: titleController.text.isEmpty
                                  ? const SizedBox()
                                  : InkWell(
                                onTap: () {
                                  titleController.clear();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: gTextColor,
                                  size: 2.h,
                                ),
                              ),
                              hintText: "",
                              border: InputBorder.none,
                              hintStyle: mainTextField(),
                            ),
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Positioned(
                          left: 6.w,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: kNumberCirclePurple,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: RichText(
                              // key: key,
                              // textScaleFactor: textScleFactor,
                                text: TextSpan(
                                    text: "Title",
                                    style: TextStyle(
                                      fontSize: 8.5.sp,
                                      color: gWhiteColor,
                                      fontFamily: kFontMedium,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: kPrimaryColor,
                                          fontFamily: "PoppinsSemiBold",
                                        ),
                                      )
                                    ])),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Stack(
                      children: [
                        Container(
                          // height: 20.h,
                          constraints: BoxConstraints(
                              minHeight: 12.h,
                              maxHeight: 20.h
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
                          padding: EdgeInsets.only(
                              left: 5.w, top: 1.h, bottom: 0.5.h, right: 0.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: gGreyColor.withOpacity(0.3),
                            ),
                          ),
                          child: TextFormField(
                            controller: descriptionController,
                            cursorColor: gPrimaryColor,
                            style: mainTextField(),
                            maxLines: null,
                            decoration: InputDecoration(
                              suffixIcon: descriptionController.text.isEmpty
                                  ? const SizedBox()
                                  : InkWell(
                                onTap: () {
                                  descriptionController.clear();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: gTextColor,
                                  size: 2.h,
                                ),
                              ),
                              hintText: "",
                              border: InputBorder.none,
                              helperStyle: mainTextField(),
                            ),
                            textInputAction: TextInputAction.newline,
                            textAlign: TextAlign.start,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),
                        Positioned(
                          left: 6.w,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: kNumberCircleAmber,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: RichText(
                                // key: key,
                                // textScaleFactor: textScleFactor,
                                text: TextSpan(
                                    text: "Description",
                                    style: TextStyle(
                                      fontSize: 8.5.sp,
                                      color: gBlackColor,
                                      fontFamily: kFontMedium,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: kPrimaryColor,
                                          fontFamily: "PoppinsSemiBold",
                                        ),
                                      )
                                    ])),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Stack(
                      children: [
                        Container(
                          // height: 20.h,
                          constraints: BoxConstraints(
                            maxHeight: 35.h
                          ),
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.5.h),
                          padding: EdgeInsets.only(
                              left: 2.w, top: 1.h, bottom: 0.5.h, right: 2.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: gGreyColor.withOpacity(0.3),
                            ),
                          ),
                          child: fileFormatList.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                            onTap: (){
                                showChooserSheet();
                            },
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                      fontSize: smTextFontSize,
                                      color: gBlackColor,
                                      fontFamily: kFontMedium,
                                    ),
                                  ),
                                  Icon(Icons.attach_file_outlined,
                                    color: Colors.black,
                                    size: 10.sp,
                                  )
                                ],
                            ),
                          ),
                              )
                              : ListView.separated(
                            shrinkWrap: true,
                            itemCount: fileFormatList.length,
                              itemBuilder: (_, fileIndex){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(basename(fileFormatList[fileIndex].path)),
                                    InkWell(
                                      onTap: () {
                                        newList.removeWhere((element) => element.filename == fileFormatList[fileIndex].path);

                                        fileFormatList.removeAt(fileIndex);

                                        print(newList);
                                        setState(() {});
                                      },
                                      child: SvgPicture.asset(
                                        "assets/images/DElete.svg",
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              },
                            separatorBuilder: (_, fileIndex){
                              return const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Divider(
                                  color: kLineColor,
                                  thickness: 1.2,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 6.w,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: kNumberCircleAmber,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Attachments",
                              style: TextStyle(
                                fontSize: smTextFontSize,
                                color: gTextColor,
                                fontFamily: kFontMedium,
                              ),
                            ),
                          ),
                        ),
                        if(fileFormatList.isNotEmpty)
                          Positioned(
                          right: 6.w,
                          child: GestureDetector(
                            onTap: (){
                              showChooserSheet();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: kNumberCircleAmber,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                      fontSize: smTextFontSize,
                                      color: gWhiteColor,
                                      fontFamily: kFontMedium,
                                    ),
                                  ),
                                  Icon(Icons.attach_file_outlined,
                                    color: Colors.black,
                                    size: 10.sp,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
            ),
            GestureDetector(
              onTap: (){
                print("fileFormatList: ${fileFormatList.length}");
                print("newList.length: ${newList.length}");

                if(titleController.text.isEmpty){
                  AppConfig().showSnackbar(context, "Please Mention Title", isError: true);
                }
                else if(descriptionController.text.isEmpty){
                  AppConfig().showSnackbar(context, "Please Mention Description", isError: true);
                }
                else{
                  createTicket();
                }
              },
              child: Center(
                child: Container(
                  width: 40.w,
                  height: 4.5.h,
                  // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: eUser().buttonColor,
                    borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                    // border: Border.all(color: eUser().buttonBorderColor,
                    //     width: eUser().buttonBorderWidth),
                  ),
                  child: (showProgress)
                      ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                      : Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontFamily:
                        kFontBold,
                        color: gWhiteColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h,)

          ],
        ),
      ))
    );
  }

  createTicket() async{
    setState((){
      showProgress = true;
    });
    Map data = {
      //'type': "${TicketStatusType.open.index+1}",
      'name': nameController.text,
      'from': emailController.text,
      'message': descriptionController.text,
      'subject': titleController.text,
    'actAsType':"customer",
    'actAsEmail':emailController.text,
      'agent_id': _agentId
    };

    final res = await _uvDeskService.createTicketService(data, attachments: fileFormatList.isNotEmpty ? fileFormatList : null);

    print(res.runtimeType);
    if(res.runtimeType == ErrorModel){

    }
    else{
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const TicketListScreen()))
          .then((value) {
        if (true) {
          setState(() {});
        }
      });
    }

    setState((){
      showProgress = false;
    });
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );


  /*
  Attachment codes
   */

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
                      child: Text('Choose File Source'),
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
                                Text('Camera'),
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
                                  Icons.insert_drive_file,
                                  color: gMainColor,
                                ),
                                Text('File'),
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

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  List<MultipartFile> newList = <MultipartFile>[];
  List<File> fileFormatList = [];


  void pickFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      type: FileType.any,
      // allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      allowMultiple: true,
    );
    if (result == null) return;

    /// if allowMultiple: true
    List<File> _files = result.paths.map((path) => File(path!)).toList();

    _files.forEach((element) {
      print(element.path.split('.').last);
      if (element.path.split('.').last.toLowerCase().contains("pdf") ||
          element.path.split('.').last.toLowerCase().contains("png") ||
          element.path.split('.').last.toLowerCase().contains("jpg") ||
          element.path.split('.').last.toLowerCase().contains("jpeg")) {
        if (getFileSize(element) <= 12) {
          print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
          print(element.path);
          addFilesToList(element);
          // addToMultipartList();
        } else {
          AppConfig()
              .showSnackbar(context, "File size must be <12Mb", isError: true);
        }
      } else {
        AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
            isError: true);
      }
    });

    /// single file select for this  allowMultiple should be false allowMultiple: false
    // if (result.files.first.extension!.contains("pdf") ||
    //     result.files.first.extension!.contains("png") ||
    //     result.files.first.extension!.contains("jpg") ||
    //     result.files.first.extension!.contains("jpeg")) {
    //   if (getFileSize(File(result.paths.first!)) <= 12) {
    //     print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
    //     files.add(result.files.first);
    //     // addFilesToList(File(result.paths.first!));
    //     if (type != null) {
    //       if (reportsObject.isNotEmpty) {
    //         reportsObject.forEach((element) {
    //           if (element.id.toString().contains(type)) {
    //             element.path.add(result.paths.first!);
    //           }
    //         });
    //       }
    //       if (type == "others") {
    //         otherFilesObject.add(result.paths.first ?? '');
    //       }
    //       print("otherFilesObject: $otherFilesObject");
    //     }
    //   }
    //   else {
    //     AppConfig()
    //         .showSnackbar(context, "File size must be <12Mb", isError: true);
    //   }
    // }
    // else {
    //   AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
    //       isError: true);
    // }
    setState(() {});
  }

  addFilesToList(File file) async {
    print("contains: ${fileFormatList.any((element) => element.path == file.path)}");

    if(!fileFormatList.any((element) => element.path == file.path)){
      fileFormatList.add(file);
    }
    setState(() {});
  }

  addToMultipartList() async{
    print("addToMultipartList");
    newList.clear();

    // for (int i = 0; i < fileFormatList.length; i++) {
    //   var length = await fileFormatList[i].length();
    //   print("cleard: $i");
    //   print("newList for: ${newList.length} ${fileFormatList.length}");
    //   var stream =
    //   http.ByteStream(DelegatingStream.typed(fileFormatList[i].openRead()));
    //   var multipartFile = http.MultipartFile("attachments[]", stream, length,
    //       filename: fileFormatList[i].path);
    //   newList.add(multipartFile);
    //   print("newList after: ${newList.length}");
    // }

    print("fileFormatList: ${fileFormatList.length}");

    print("newList: ${newList.length}");
  }

  File? _image;

  Future getImageFromCamera({String? type}) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 40);

    setState(() {
      _image = File(image!.path);
      if (getFileSize(_image!) <= 12) {
        print("filesize: ${getFileSize(_image!)}Mb");

        addFilesToList(_image!);

      } else {
        print("filesize: ${getFileSize(_image!)}Mb");

        AppConfig()
            .showSnackbar(context, "File size must be <12Mb", isError: true);
      }
    });
    print("captured image: ${_image} ${_image!.path}");
  }

  isExists(File file) {
    fileFormatList.map((element) {
      if(element.absolute.path == file.absolute.path){
        print("found :: path exists file: ${file.path} ele: ${element.path}");
        return true;
      }
      else{
        print("found :: path not exists file: ${file.path} ele: ${element.path}");
        return false;
      }
    });
  }

}
