/*
Api's used

Get profile api calling in initstate
var getUserProfileUrl = "${AppConfig().BASE_URL}/api/user";

which is used to show the data

update api:
var updateUserProfileUrl = "${AppConfig().BASE_URL}/api/submitForm/update_user_profile";

update profile api from that we can update fname, lname, age, gender, profile pic

but now we r updating only profile pic

from this screen we r navigating to evaluation report screen, my reports, feedback screen

for my reports we need to pass isFromSetting as true

if its false than in report screen it will show upload file ui

 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gwc_customer_web/model/profile_model/user_profile/send_user_model.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/dart_extensions.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/error_model.dart';
import '../../model/profile_model/logout_model.dart';
import '../../model/profile_model/user_profile/child_user_model.dart';
import '../../model/profile_model/user_profile/update_user_model.dart';
import '../../model/profile_model/user_profile/user_profile_model.dart';
import '../../repository/api_service.dart';
import '../../repository/login_otp_repository.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../services/login_otp_service.dart';
import '../../services/profile_screen_service/user_profile_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/widgets.dart';
import '../appointment_screens/consultation_screens/upload_files.dart';
import '../evalution_form/evaluation_get_details.dart';
import '../gut_list_screens/new_stages_data.dart';
import '../user_registration/existing_user.dart';
import 'feedback_rating_screen.dart';

class MyProfileDetails extends StatefulWidget {
  const MyProfileDetails({Key? key}) : super(key: key);

  @override
  State<MyProfileDetails> createState() => _MyProfileDetailsState();
}

class _MyProfileDetailsState extends State<MyProfileDetails> {
  final SharedPreferences _pref = AppConfig().preferences!;

  bool photoError = false;
  String profile = '';
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  String genderSelected = "";

  Future? getProfileDetails;

  bool isEdit = false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  getProfileData() {
    getProfileDetails =
        UserProfileService(repository: repository).getUserProfileService();
  }

  updateProfileData(Map user) async {
    final res = await UserProfileService(repository: repository)
        .updateUserProfileService(user);

    if (res.runtimeType == UpdateUserModel) {
      UpdateUserModel model = res as UpdateUserModel;
      AppConfig().showSnackbar(context, model.message ?? '');
      setState(() {
        isEdit = false;
      });
      getProfileData();
    } else {
      ErrorModel model = res as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: buildAppBar(() {
                        Navigator.pop(context);
                      })),
                  Padding(
                    padding: EdgeInsets.only(right: 3.w),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'V.',
                            style: TextStyle(
                                fontFamily: kFontMedium,
                                color: gBlackColor,
                                fontSize: 6.dp),
                          ),
                          TextSpan(
                            text: "10.2",
                            style: TextStyle(
                                fontFamily: kFontBook,
                                color: gBlackColor,
                                fontSize: 6.dp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              FutureBuilder(
                  future: getProfileDetails,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.runtimeType == UserProfileModel) {
                        UserProfileModel data =
                            snapshot.data as UserProfileModel;
                        ChildUserModel? subData = data.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "My Profile",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: kFontBold,
                                        color: gBlackColor,
                                        fontSize: 16.dp),
                                  ),
                                  (!isEdit)
                                      ? InkWell(
                                          onTap: () {
                                            toggleEdit();
                                            if (isEdit) {
                                              setState(() {
                                                ChildUserModel data = subData!;
                                                print(
                                                    "${data.name}, ${data.age}");
                                                fnameController.text =
                                                    data.fname ?? '';
                                                lnameController.text =
                                                    data.lname ?? '';
                                                ageController.text =
                                                    data.age ?? '';
                                                genderSelected = data.gender!
                                                        .toTitleCase() ??
                                                    '';
                                                emailController.text =
                                                    data.email!;
                                                mobileController.text =
                                                    data.phone!;
                                              });
                                            }
                                            // Navigator.of(context).push(
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //     const RegisterScreen(),
                                            //   ),
                                            // );
                                          },
                                          child: SvgPicture.asset(
                                            "assets/images/Icon feather-edit.svg",
                                            color: Colors.grey,
                                            fit: BoxFit.contain,
                                            height: 2.h,
                                          ))
                                      : Align(
                                          alignment: Alignment.topRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    toggleEdit();
                                                    _image = null;
                                                  },
                                                  child: Icon(Icons.clear)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                  onTap: () async {
                                                    if (int.parse(ageController
                                                                .text) <
                                                            10 ||
                                                        int.parse(ageController
                                                                .text) >
                                                            100) {
                                                      AppConfig().showSnackbar(
                                                          context,
                                                          "Age Should be Greater than 10 and less than 100",
                                                          isError: true);
                                                    } else {
                                                      var file;
                                                      if (_image != null) {
                                                        file = await http
                                                                .MultipartFile
                                                            .fromPath("photo",
                                                                _image!.path);
                                                      }
                                                      SendUserModel user = SendUserModel(
                                                          fname: fnameController
                                                              .text,
                                                          lname: lnameController
                                                              .text,
                                                          age: ageController
                                                              .text,
                                                          gender: genderSelected
                                                              .toLowerCase(),
                                                          email: subData!.email,
                                                          phone: subData.phone,
                                                          profile: (_image !=
                                                                      null &&
                                                                  file != null)
                                                              ? file
                                                              : null);
                                                      updateProfileData(
                                                          user.toJson());
                                                    }

                                                    // toggleEdit();
                                                  },
                                                  child: Icon(Icons.check))
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Center(
                              child: IntrinsicWidth(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 2.h,
                                      bottom: 3.h,
                                      right: 0.w,
                                      left: 0.w),
                                  padding: EdgeInsets.only(
                                      top: 3.h,
                                      bottom: 3.h,
                                      right: 5.w,
                                      left: 5.w),
                                  decoration: BoxDecoration(
                                    color: gWhiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: kLineColor.withOpacity(0.5),
                                        offset: Offset(2, 3),
                                        blurRadius: 5,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        ImageNetwork(
                                          image: subData!.profile!,
                                          height: 140,
                                          width: 140,
                                          duration: 1500,
                                          curve: Curves.easeIn,
                                          onPointer: true,
                                          debugPrint: false,
                                          fullScreen: false,
                                          fitAndroidIos: BoxFit.cover,
                                          fitWeb: BoxFitWeb.cover,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                          onLoading:
                                              const CircularProgressIndicator(
                                            color: Colors.indigoAccent,
                                          ),
                                          onError: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            debugPrint(
                                                "©gabriel_patrick_souza");
                                          },
                                        ),
                                        // CircleAvatar(
                                        //   radius: 8.h,
                                        //   backgroundColor: Colors.black26,
                                        //   backgroundImage:
                                        //       // (subData!.profile == null || photoError) ? ExactAssetImage(
                                        //       //     "assets/images/cheerful.png") :
                                        //       (_image != null)
                                        //           ? FileImage(_image!)
                                        //           : CachedNetworkImageProvider(
                                        //               subData!.profile!,
                                        //               errorListener: (message) {
                                        //               print("image error");
                                        //               setState(() =>
                                        //                   photoError = true);
                                        //             }) as ImageProvider,
                                        //   child: Stack(
                                        //       //  overflow: Overflow.visible,
                                        //       clipBehavior: Clip.none,
                                        //       children: [
                                        //         Visibility(
                                        //           visible: isEdit,
                                        //           child: GestureDetector(
                                        //             onTap: showChooserSheet,
                                        //             child: Align(
                                        //               alignment:
                                        //                   Alignment.bottomRight,
                                        //               child: CircleAvatar(
                                        //                 radius: 11,
                                        //                 backgroundColor:
                                        //                     gPrimaryColor
                                        //                         .withOpacity(0.9),
                                        //                 child: const Padding(
                                        //                   padding:
                                        //                       EdgeInsets.all(4.0),
                                        //                   child: Icon(
                                        //                     CupertinoIcons.camera,
                                        //                     color: gWhiteColor,
                                        //                     size: 14,
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ]),
                                        // ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          "${subData?.name}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  eUser().mainHeadingFont,
                                              color: eUser().mainHeadingColor,
                                              fontSize:
                                                  eUser().mainHeadingFontSize),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          "${subData?.email}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  eUser().userTextFieldHintFont,
                                              color: gHintTextColor,
                                              fontSize: eUser()
                                                  .userTextFieldFontSize),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          "${subData?.phone}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  eUser().userTextFieldHintFont,
                                              color: gHintTextColor,
                                              fontSize: eUser()
                                                  .userTextFieldFontSize),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              buildButtons(
                                                "Evaluation",
                                                "assets/images/Group 62759.png",
                                                () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const EvaluationGetDetails(
                                                        isFromProfile: false,
                                                      ),
                                                      // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(width: 3.w),
                                              buildButtons(
                                                "My Reports",
                                                "assets/images/Group 62760.png",
                                                () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UploadFiles(
                                                        isFromSettings: true,
                                                      ),
                                                      // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(width: 3.w),
                                              buildButtons(
                                                "Feedback",
                                                "assets/images/Group 62758.png",
                                                () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FeedbackRatingScreen(),
                                                      // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width:
                                    MediaQuery.of(context).size.shortestSide >
                                            600
                                        ? 40.w
                                        : double.maxFinite,
                                child: Column(
                                  children: [
                                    profileTile("First Name: ",
                                        subData?.fname ?? "Gut-Wellness Club",
                                        controller: fnameController),
                                    profileTile("Last Name: ",
                                        subData?.lname ?? "Gut-Wellness Club",
                                        controller: lnameController),
                                    profileTile("Age: ", subData?.age ?? '',
                                        controller: ageController,
                                        maxLength: 2),
                                    genderTile('Gender', subData?.gender ?? "")
                                    // profileTile("Email: ", subData?.email ?? ''),
                                    // profileTile("Mobile Number: ", subData?.phone ?? ''),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        ErrorModel data = snapshot.data as ErrorModel;
                        // AppConfig().showSnackbar(context, data.message ?? 'Unauthenticated', isError: true);
                        errorDisplayLayout();
                      }
                    } else if (snapshot.hasError) {
                      // AppConfig().showSnackbar(context, snapshot.error.toString(), isError: true);
                      errorDisplayLayout();
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.h),
                      child: buildCircularIndicator(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  /// this method is for showing common Circle image for reports
  buildButtons(String title, String image, func) {
    return GestureDetector(
      onTap: func,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: gsecondaryColor, shape: BoxShape.circle),
            child: Image(
              image: AssetImage(
                image,
              ),
              color: gWhiteColor,
              height: 4.h,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: TextStyle(
              color: gTextColor,
              fontFamily: kFontMedium,
              fontSize: 13.dp,
            ),
          ),
        ],
      ),
    );
  }

  profileTile(String title, String subTitle,
      {TextEditingController? controller, int? maxLength}) {
    print(controller);
    print(controller.runtimeType);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: gHintTextColor,
              fontFamily: kFontBook,
              fontSize: 10.dp,
            ),
          ),
          SizedBox(height: 1.h),
          // (isEdit && controller != null)
          //     ? TextField(
          //   controller: controller,
          //   readOnly: !isEdit,
          //   decoration: InputDecoration(
          //       contentPadding: EdgeInsets.all(0.0),
          //       isDense: true,
          //       counterText: ""
          //     // border: InputBorde,
          //   ),
          //   minLines: 1,
          //   maxLines: 1,
          //   maxLength: maxLength,
          //   // onSaved: (String value) {
          //   //   // This optional block of code can be used to run
          //   //   // code when the user saves the form.
          //   // },
          //   // validator: (value) {
          //   //   if(value!.isEmpty){
          //   //     return 'Name filed can\'t be empty';
          //   //   }
          //   // },
          // )
          //     :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subTitle,
                style: TextStyle(
                  color: gBlackColor,
                  fontFamily: kFontBold,
                  fontSize: 11.dp,
                ),
              ),
              Container(
                height: 1,
                margin: EdgeInsets.only(top: 1.h, right: 5.w),
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  genderTile(String title, String selectedGender) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: gHintTextColor,
              fontFamily: kFontBook,
              fontSize: 10.dp,
            ),
          ),
          SizedBox(height: 1.h),

          /// commented the edit for gender
          /// if we need edit than uncomment this
          // (isEdit)
          //     ? Row(
          //   children: [
          //     GestureDetector(
          //         onTap: (){
          //           setState(() => genderSelected = "Male");
          //         },
          //         child: Row(
          //           children: [
          //             Radio(
          //               value: "Male",
          //               activeColor: kPrimaryColor,
          //               groupValue: genderSelected,
          //               onChanged: (value) {
          //                 setState(() {
          //                   genderSelected = value as String;
          //                 });
          //               },
          //             ),
          //             Text('Male',
          //               style: buildTextStyle(color: genderSelected == "Male" ? kTextColor : gHintTextColor,
          //                   fontFamily: genderSelected == "Male" ? kFontMedium : kFontBook
          //               ),
          //             ),
          //           ],
          //         )),
          //     SizedBox(
          //       width: 3.w,
          //     ),
          //     GestureDetector(
          //       onTap: (){
          //         setState(() => genderSelected = "Female");
          //       },
          //       child: Row(
          //         children: [
          //           Radio(
          //             value: "Female",
          //             activeColor: kPrimaryColor,
          //             groupValue: genderSelected,
          //             onChanged: (value) {
          //               setState(() {
          //                 genderSelected = value as String;
          //               });
          //             },
          //           ),
          //           Text(
          //             'Female',
          //             style: buildTextStyle(color: genderSelected == "Female" ? kTextColor : gHintTextColor,
          //                 fontFamily: genderSelected == "Female" ? kFontMedium : kFontBook
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(
          //       width: 3.w,
          //     ),
          //     GestureDetector(
          //       onTap: (){
          //         setState(() => genderSelected = "Other");
          //       },
          //       child: Row(
          //         children: [
          //           Radio(
          //               value: "Other",
          //               groupValue: genderSelected,
          //               activeColor: kPrimaryColor,
          //               onChanged: (value) {
          //                 setState(() {
          //                   genderSelected = value as String;
          //                 });
          //               }),
          //           Text(
          //             "Other",
          //             style: buildTextStyle(color: genderSelected == "Other" ? kTextColor : gHintTextColor,
          //                 fontFamily: genderSelected == "Other" ? kFontMedium : kFontBook
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // )
          //     :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedGender,
                style: TextStyle(
                  color: gBlackColor,
                  fontFamily: kFontBold,
                  fontSize: 11.dp,
                ),
              ),
              Container(
                height: 1,
                margin: EdgeInsets.only(top: 1.h, right: 5.w),
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  errorDisplayLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 11.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(2, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //     const RegisterScreen(),
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h, right: 3.w),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                            "assets/images/Icon feather-edit.svg",
                            color: Colors.grey,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    profileTile("Name: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    profileTile("Age: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    profileTile("Gender: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    profileTile("Email: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    profileTile("Mobile Number: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5.h,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: const Icon(Icons.account_circle),
                  radius: 6.h,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  final UserProfileRepository repository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  toggleEdit() {
    setState(() {
      if (isEdit) {
        isEdit = false;
      } else {
        isEdit = true;
      }
    });
  }

  File? _image;

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
                          fontSize: 12.dp,
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
                                    fontSize: 10.dp,
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
                                    fontSize: 10.dp,
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

  Future getImageFromCamera() async {
    await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then(
          (pickedFile) => cropSelectedImage("${pickedFile?.path}").then(
            (croppedFile) => setState(() {
              _image = File("${croppedFile?.path}");
            }),
          ),
        );
    print("captured image: $_image");
  }

  void pickFromFile() async {
    await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then(
          (pickedFile) => cropSelectedImage("${pickedFile?.path}").then(
            (croppedFile) => setState(() {
              _image = File("${croppedFile?.path}");
            }),
          ),
        );
    // setState(() {
    //   _image = File(image);
    // });
    // var image = await ImagePicker.platform
    //     .pickImage(source: ImageSource.gallery, imageQuality: 50);
    // setState(() {
    //   _image = File(image!.path);
    // });
    // print(_image);
  }

  final LoginOtpRepository logoutRepository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void logOut() async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    final res =
    await LoginWithOtpService(repository: logoutRepository).logoutService();

    if (res.runtimeType == LogoutModel) {
      clearAllUserDetails();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ExistingUser(),
      ));
    } else {
      ErrorModel model = res as ErrorModel;
      Get.snackbar(
        "",
        model.message!,
        colorText: gWhiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gsecondaryColor.withOpacity(0.55),
      );
    }

    logoutProgressState(() {
      showLogoutProgress = true;
    });
  }

  // clearing some details in local storage
  clearAllUserDetails() {
    _pref.setBool(AppConfig.isLogin, false);
    _pref.remove(AppConfig().BEARER_TOKEN);

    _pref.remove(AppConfig.User_Name);
    _pref.remove(AppConfig.USER_ID);
    _pref.remove(AppConfig.QB_USERNAME);
    _pref.remove(AppConfig.QB_CURRENT_USERID);
    _pref.remove(AppConfig.KALEYRA_USER_ID);
    _pref.remove(AppConfig.User_Name);
    _pref.remove(AppConfig.User_Profile);
    _pref.remove(AppConfig.User_Number);

    updateStageData();
  }

  bool showLogoutProgress = false;

  /// we r showing in stateful builder so this parameter will be used
  /// when we get setstate we will assign to this parameter based on that logout progress is used
  var logoutProgressState;

  logoutWidget() {
    return StatefulBuilder(builder: (_, setstate) {
      logoutProgressState = setstate;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "We will miss you.",
              style: TextStyle(
                  fontSize: bottomSheetHeadingFontSize,
                  fontFamily: bottomSheetHeadingFontFamily,
                  height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              color: kLineColor,
              thickness: 1.2,
            ),
          ),
          Center(
            child: Text(
              'Do you really want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gTextColor,
                fontSize: bottomSheetSubHeadingXFontSize,
                fontFamily: bottomSheetSubHeadingMediumFont,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          (showLogoutProgress)
              ? Center(child: buildCircularIndicator())
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: () => logOut(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.5.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: gsecondaryColor,
                        border: Border.all(color: kLineColor, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "YES",
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gWhiteColor,
                        fontSize: 11.dp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.5.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: gWhiteColor,
                        border: Border.all(color: kLineColor, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "NO",
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gsecondaryColor,
                        fontSize: 11.dp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h)
        ],
      );
    });
  }
}
