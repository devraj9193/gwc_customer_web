import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';

class NetworkErrorItem extends StatefulWidget {
  const NetworkErrorItem({Key? key}) : super(key: key);

  @override
  State<NetworkErrorItem> createState() => _NetworkErrorItemState();
}

class _NetworkErrorItemState extends State<NetworkErrorItem> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        print("Internet : $isDeviceConnected");
        if (!isDeviceConnected && isAlertSet == false) {
          Get.to(() => const NetworkErrorItem());
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // No Internet Connection
            Image(
              image:
              const AssetImage("assets/images/Success.png"),
              height: 30.h,
            ),
            // Icon(
            //   Icons.signal_wifi_statusbar_connected_no_internet_4_sharp,
            //   color: newLightGreyColor,
            //   size: 10.h,
            // ),
            SizedBox(height: 4.h),
            Text(
              'No Internet Connection',
              style: TextStyle(
                  fontFamily: kFontBold,
                  color: gBlackColor,
                  fontSize: 12.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              'Check your connection and try again.',
              style: TextStyle(
                  fontFamily: kFontBook,
                  color: gBlackColor,
                  fontSize: 10.sp),
            ),
            SizedBox(height: 4.h),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  Get.to(() => const NetworkErrorItem());
                  setState(() => isAlertSet = true);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: gsecondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 09.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// showDialogBox() {
//   return showCupertinoDialog<String>(
//     context: context,
//     builder: (BuildContext context) => CupertinoAlertDialog(
//       title: const Text('No Connection'),
//       content: const Text('Please check your internet connectivity'),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () async {
//             Navigator.pop(context, 'Cancel');
//             setState(() => isAlertSet = false);
//             isDeviceConnected =
//             await InternetConnectionChecker().hasConnection;
//             if (!isDeviceConnected && isAlertSet == false) {
//               showDialogBox();
//               setState(() => isAlertSet = true);
//             }
//           },
//           child: const Text('OK'),
//         ),
//       ],
//     ),
//   );
// }
}
