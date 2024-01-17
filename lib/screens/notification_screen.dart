/*
Notification types

meal_plan
enquiry
report
appointment
shopping

API for notification list

https://gwc.disol.in/apidoc/#api-User-notification_list
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
import '../model/error_model.dart';
import '../model/local_storage_dashboard_model.dart';
import '../model/notification_model/NotificationModel.dart';
import '../model/notification_model/child_notification_model.dart';
import '../repository/api_service.dart';
import '../repository/notification_repository/notification_repo.dart';
import '../services/notification_service/notification_service.dart';
import '../utils/app_config.dart';
import '../widgets/constants.dart';
import '../widgets/widgets.dart';
import 'appointment_screens/consultation_screens/consultation_success.dart';
import 'appointment_screens/consultation_screens/medical_report_screen.dart';
import 'appointment_screens/doctor_slots_details_screen.dart';
import 'cook_kit_shipping_screens/cook_kit_tracking.dart';

/// enum for each stages we get in Notification api
enum NotificationTypeEnum{
  meal_plan, enquiry, report, appointment, shopping, reminder_appointment, new_appointment,
  doctor_requested_reports, consultation_rejected, mr_report
}


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {


  final _pref = AppConfig().preferences;
  Future? notificationFuture;

  String type = "shopping";

  LocalStorageDashboardModel? _localStorageDashboardModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotificationList();
    if(_pref!.getString(AppConfig.LOCAL_DASHBOARD_DATA) != null){
      _localStorageDashboardModel = LocalStorageDashboardModel.fromJson(jsonDecode(_pref!.getString(AppConfig.LOCAL_DASHBOARD_DATA)!));
    }
  }

  getNotificationList(){
    notificationFuture = NotificationService(repository: repo).getNotificationListService();
    print(NotificationTypeEnum.shopping);
    print(type == NotificationTypeEnum.shopping.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: const AssetImage("assets/images/eval_bg.png"),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.lighten)
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h,bottom: 2.h),
                child: buildAppBar((){
                  Navigator.pop(context);
                }),
              ),
              SizedBox(
                height: 4.h,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text('Notifications',
                              style: TextStyle(
                                fontFamily: kFontBold,
                                color: PPConstants().topViewHeadingText,
                                fontSize: headingFont
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            color: gHintTextColor,
                          ),
                          FutureBuilder(
                            future: notificationFuture,
                              builder: (_, snapshot){
                              print(snapshot.connectionState);
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return Padding(padding: EdgeInsets.symmetric(vertical: 30.h),child: buildCircularIndicator(),);
                              }
                              else if(snapshot.connectionState == ConnectionState.done){
                                if(snapshot.hasData){
                                  print(snapshot.data.runtimeType);
                                  if(snapshot.data.runtimeType == ErrorModel){
                                    return Center(
                                      child: Column(children: [
                                        Text(snapshot.error.toString(),
                                          style: TextStyle(
                                              fontSize: eUser().userFieldLabelFontSize,
                                              fontFamily: kFontMedium
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              getNotificationList();
                                            },
                                            child: Text('Retry',
                                              style: TextStyle(
                                                  fontSize: 10.dp,
                                                  fontFamily: kFontMedium
                                              ),
                                            )
                                        )
                                      ],),
                                    );
                                  }
                                  else{
                                    NotificationModel model = snapshot.data as NotificationModel;
                                    List<ChildNotificationModel> childModel = model.data as List<ChildNotificationModel>;
                                    childModel.forEach((element) {
                                      print(element.type);
                                    });
                                    return ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: childModel.length,
                                        itemBuilder: (_, index){
                                        return showListItem(
                                            getIcons(childModel[index].type) ?? '',
                                            childModel[index].subject ?? '',
                                            childModel[index].message ?? '',
                                            childModel[index].created_at ?? '',
                                          type: childModel[index].type
                                        );
                                        }
                                    );
                                  }
                                }
                                else if(snapshot.hasError){
                                  return Center(
                                    child: Column(children: [
                                      Text(snapshot.error.toString(),
                                        style: TextStyle(
                                          fontSize: 11.dp,
                                          fontFamily: kFontMedium
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: (){
                                            getNotificationList();
                                          },
                                          child: Text('Retry',
                                            style: TextStyle(
                                                fontSize: 10.dp,
                                                fontFamily: kFontMedium
                                            ),
                                          )
                                      )
                                    ],),
                                  );
                                }
                              }
                              return buildCircularIndicator();
                              }
                          ),
                          // showListItem('assets/images/notification/pay_done.png', 'Payment is done', 'Your enquiry was successfully verified. Tap to sign in right now!', '1 Month ago'),
                          // showListItem('assets/images/notification/booking.png', 'Booked Appointment', 'Success! Your appointment is scheduled with Gut Wellness Club. Tap to find out more.', '1 Month ago'),
                          // showListItem('assets/images/notification/appoint_reminder.png', 'Reminder of Appointment', 'Reminder: Appointment scheduled for [Date] at [Time]. Tap to join. ', '1 Month ago'),
                          // showListItem('assets/images/notification/appoint_schedule.png', 'Appointment Rescheduled', 'Your appointment was successfully rescheduled. Tap to see more details.', '1 Month ago'),
                          // showListItem('assets/images/notification/appoint_schedule.png', 'MR was uploaded', 'Your Medical Report was uploaded. Tap it to see the details.', '1 Month ago'),
                          // showListItem('assets/images/notification/list_upload.png', 'Shopping List Upload', 'Your Shopping list has been uploaded. Enjoy! Tap to see it. ', '1 Month ago'),
                          // showListItem('assets/images/notification/intransit.png', 'Intransit, Reached Near, Delivered', 'a. Your #(order number) is in transit. Track here: b.Your #(order number) has reached a nearby location. Track here:  c. Success! Your order has been delivered to you. Enjoy your program with tasty, healthy meals!', '1 Month ago'),
                          //
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  showListItem(String asset, String title, String subTitle, String lastTitle,
      {String? type}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: (){
            handleOnTap(type);
          },
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 10,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(asset,
              fit: BoxFit.scaleDown,
              color: gBlackColor,
              width: 50,
              // height: 70
            ),
          ),
          minLeadingWidth:1.w,
          title: Text(title,
            style: TextStyle(
                fontFamily: kFontBold,
                color: gPrimaryColor,
                fontSize: eUser().userFieldLabelFontSize
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subTitle,
                style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gTextColor,
                    fontSize: eUser().userTextFieldHintFontSize
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(lastTitle,
                style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gHintTextColor,
                    fontSize: 12.dp
                ),
              )
            ],
          ),
          isThreeLine: true,
        ),
        // SizedBox(
        //   child: Row(
        //     children: [
        //       Expanded(
        //           flex: 1,
        //           child: Image.asset(asset)),
        //       Expanded(
        //         flex: 3,
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text(title,
        //               style: TextStyle(
        //                   fontFamily: kFontBold,
        //                   color: gMainColor,
        //                   fontSize: 11.dp
        //               ),
        //             ),
        //             Expanded(
        //               child: Text(subTitle,
        //                 style: TextStyle(
        //                     fontFamily: kFontBold,
        //                     color: gMainColor,
        //                     fontSize: 10.dp
        //                 ),
        //               ),
        //             ),
        //             Text(lastTitle,
        //               style: TextStyle(
        //                   fontFamily: kFontBold,
        //                   color: gMainColor,
        //                   fontSize: 9.5.dp
        //               ),
        //             )
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        Divider()
      ],
    );
  }

  NotificationRepo repo = NotificationRepo(
      apiClient: ApiClient(
        httpClient: http.Client()
      )
  );

  //meal_plan
  // enquiry
  // report
  // appointment
  // shopping
  String? getIcons(String? type) {
    String? asset;

    if(type == NotificationTypeEnum.meal_plan.name){
      asset = 'assets/images/notification/intransit.png';
    }
    else if(type == NotificationTypeEnum.enquiry.name){
      asset = 'assets/images/notification/pay_done.png';
    }
    else if(type == NotificationTypeEnum.report.name || type == NotificationTypeEnum.mr_report.name){
      asset = 'assets/images/notification/appoint_schedule.png';
    }
    else if(type == NotificationTypeEnum.appointment.name || type == NotificationTypeEnum.reminder_appointment.name){
      asset = 'assets/images/notification/appoint_reminder.png';
    }
    else if(type == NotificationTypeEnum.new_appointment.name || type == NotificationTypeEnum.consultation_rejected.name){
      asset = 'assets/images/notification/booking.png';
    }
    else if(type == NotificationTypeEnum.shopping.name){
      asset = 'assets/images/notification/list_upload.png';
    }
    else if(type == NotificationTypeEnum.doctor_requested_reports.name){
      asset = 'assets/images/notification/list_upload.png';
    }

    return asset;
  }

  handleOnTap(String? type) {
    if(_localStorageDashboardModel == null || type == null){
      return null;
    }
    else{
      if(type == NotificationTypeEnum.meal_plan.name){
        return null;
      }
      else if(type == NotificationTypeEnum.enquiry.name){
        AppConfig().showSnackbar(context, "Already Logged In");
      }
      else if(type == NotificationTypeEnum.report.name || type == NotificationTypeEnum.mr_report.name){
        goToScreen(MedicalReportScreen(pdfLink: _localStorageDashboardModel!.mrReport!,));
      }
      else if(type == NotificationTypeEnum.appointment.name){
        goToScreen(const ConsultationSuccess());
      }
      else if(type == NotificationTypeEnum.reminder_appointment.name){
        final model = jsonDecode(_localStorageDashboardModel!.appointmentModel!);
        if(model != null){
          goToScreen(DoctorSlotsDetailsScreen(bookingDate: model!.value!.date!,
            bookingTime: model.value!.slotStartTime!,
            dashboardValueMap: model.value!.toJson(),isFromDashboard: true,));
        }
      }
      else if(type == NotificationTypeEnum.new_appointment.name){
        print(_localStorageDashboardModel!.toJson());
          final model = jsonDecode(_localStorageDashboardModel!.appointmentModel!);
          if(model != null){
            goToScreen(DoctorSlotsDetailsScreen(bookingDate: model!.value!.date!,
              bookingTime: model.value!.slotStartTime!,
              dashboardValueMap: model.value!.toJson(),isFromDashboard: true,));
          }

      }
      else if(type == NotificationTypeEnum.shopping.name){
        goToScreen(CookKitTracking(currentStage: _localStorageDashboardModel?.shippingStage ?? ''));
        // asset = 'assets/images/notification/list_upload.png';
      }
    }
  }

  goToScreen(screenName){
    print(screenName);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screenName,
        // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
      ),
    );
  }

}
