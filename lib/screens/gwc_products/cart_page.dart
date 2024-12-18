import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/gwc_products/screen_widgets.dart';
import 'package:http/http.dart' as http;

import '../../model/error_model.dart';
import '../../model/gwc_products_model/get_gwc_products_model.dart';
import '../../model/ship_track_model/user_address_model/get_user_address_model.dart';
import '../../repository/api_service.dart';
import '../../repository/shipping_repository/ship_track_repo.dart';
import '../../services/shipping_service/ship_track_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class CartPage extends StatefulWidget {
  final int cartItemCount;
  final List<GwcProducts> productList;
  final GwcProducts? product;
  final String type;
  const CartPage({
    Key? key,
    required this.cartItemCount,
    required this.productList,
    this.product,
    required this.type,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  GetUserAddressModel? getUserAddress;

  bool showAddress = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserAddressData();
  }

  getUserAddressData() async {
    setState(() {
      showAddress = true;
    });
    final result = await ShipTrackService(repository: shipTrackRepository)
        .getUserAddressService();
    print("result: $result");

    if (result.runtimeType == GetUserAddressModel) {
      setState(() {
        print("nutri delight meal plan");
        GetUserAddressModel model = result as GetUserAddressModel;

        getUserAddress = model;
        address1Controller =
            TextEditingController(text: getUserAddress?.data?.user?.address);
        address2Controller =
            TextEditingController(text: getUserAddress?.data?.address2);
        pinCodeController =
            TextEditingController(text: getUserAddress?.data?.user?.pincode);
        cityController =
            TextEditingController(text: getUserAddress?.data?.city);
        stateController =
            TextEditingController(text: getUserAddress?.data?.state);
        countryController =
            TextEditingController(text: getUserAddress?.data?.country);
      });
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showAddress = false;
    });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide > 600
        ? buildWebScreen()
        : const Placeholder();
  }

  buildWebScreen() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: profileBackGroundColor,
        appBar: CommonAppBar(
          cartItemCount: widget.cartItemCount,
          productList: widget.productList,
          type: '',
        ),
        body: (showAddress)
            ? Center(
                child: buildCircularIndicator(),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.maxFinite,
                      margin:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: gWhiteColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_new_sharp,
                                    color: gBlackColor,
                                    size: 2.h,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Cart',
                                style: TextStyle(
                                  fontSize: 15.dp,
                                  fontFamily: kFontMedium,
                                  color: gBlackColor,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 2.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delivery Address',
                                        style: TextStyle(
                                          fontSize: 14.dp,
                                          fontFamily: kFontBold,
                                          color: gBlackColor,
                                        ),
                                      ),
                                      Text(
                                        'Change',
                                        style: TextStyle(
                                          fontSize: 12.dp,
                                          fontFamily: kFontMedium,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    "${getUserAddress?.data?.user?.name},",
                                    style: TextStyle(
                                      fontFamily: kFontBook,
                                      height: 1.5,
                                      color: eUser().mainHeadingColor,
                                      fontSize: 12.dp,
                                    ),
                                  ),
                                  Text(
                                    "${getUserAddress?.data?.user?.address}, ${getUserAddress?.data?.address2},",
                                    style: TextStyle(
                                      fontFamily: kFontBook,
                                      height: 1.5,
                                      color: eUser().mainHeadingColor,
                                      fontSize: 12.dp,
                                    ),
                                  ),
                                  Text(
                                    "${getUserAddress?.data?.city}, ${getUserAddress?.data?.state}, ${getUserAddress?.data?.country} - ${getUserAddress?.data?.user?.pincode}.",
                                    style: TextStyle(
                                      fontFamily: kFontBook,
                                      height: 1.5,
                                      color: eUser().mainHeadingColor,
                                      fontSize: 12.dp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      margin:
                          EdgeInsets.only(top: 2.h, bottom: 2.h, right: 1.5.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.h),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: mainView(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  mainView() {
    return Container();
  }

  final ShipTrackRepository shipTrackRepository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
