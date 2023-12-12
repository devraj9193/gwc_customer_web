import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../repository/api_service.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';
import '../../../model/error_model.dart';
import '../../../widgets/widgets.dart';
import '../../services/uvdesk_service/uv_desk_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';

class TicketPopUpMenu extends StatefulWidget {
  final String ticketId;
  final int ticketStatus;
  const TicketPopUpMenu({
    Key? key,
    required this.ticketId,
    required this.ticketStatus
  }) : super(key: key);

  @override
  State<TicketPopUpMenu> createState() => _TicketPopUpMenuState();
}

class _TicketPopUpMenuState extends State<TicketPopUpMenu> {
  bool showLogoutProgress = false;

  var logoutProgressState;

  late final UvDeskService _uvDeskService =
      UvDeskService(uvDeskRepo: repository);

  @override
  Widget build(BuildContext context) {
    print(widget.ticketStatus);
    return PopupMenuButton(
      onSelected: null,
      offset: const Offset(0, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: (widget.ticketStatus == 5 || widget.ticketStatus == 4) ?
                    (){

                  print(widget.ticketStatus);
                  if(widget.ticketStatus == 5 || widget.ticketStatus == 4){
                    sendDialog();
                  }
                } : null,
                child: Text(
                  "Re-Open Ticket",
                  style: listSubHeading(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.5.h),
                height: 1,
                // color: gGreyColor.withOpacity(0.3),
              ),
              SizedBox(height: 0.5.h),
            ],
          ),
        ),
      ],
      child: Container(
        margin: EdgeInsets.only(right: 2.w),
        padding: const EdgeInsets.all(9),
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.3),
        //       blurRadius: 10,
        //     ),
        //   ],
        //   color: gWhiteColor,
        //   borderRadius: BorderRadius.circular(100),
        // ),
        child: const Icon(
          Icons.more_vert_sharp,
          color: gBlackColor,
        ),
      ),
    );
  }

  sendDialog() {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (_, setstate) {
        logoutProgressState = setstate;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0.sp),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 1.h),
          content: Container(
            // margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kLineColor, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Are you sure?',
                  textAlign: TextAlign.center,
                  style: listSubHeading(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: kLineColor,
                ),
                SizedBox(height: 1.h),
                showLogoutProgress
                    ? buildCircularIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              reOpenTicket();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: gsecondaryColor,
                                borderRadius: BorderRadius.circular(5),
                                // border: Border.all(color: gMainColor),
                              ),
                              child: Text(
                                "Yes",
                                style: otherText9(fontColor: gWhiteColor),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: gWhiteColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: kLineColor),
                                ),
                                child: Text("No",
                                    style: otherText9())),
                          ),
                        ],
                      ),
                SizedBox(height: 1.h)
              ],
            ),
          ),
        );
      }),
    );
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  reOpenTicket() async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    print("---------Re - Open Ticket---------");

    final result =
        await _uvDeskService.reOpenTicketService(widget.ticketId);

    if (result.runtimeType == ErrorModel) {
      ErrorModel model = result as ErrorModel;
      logoutProgressState(() {
        showLogoutProgress = false;
      });
      Navigator.pop(context);
      AppConfig().showSnackbar(context, model.message!, isError: true);
    } else {
      logoutProgressState(() {
        showLogoutProgress = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      // GwcApi().showSnackBar(context, response.message!, isError: false);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
    }
    logoutProgressState(() {
      showLogoutProgress = true;
    });
  }

}
