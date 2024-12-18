import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/gwc_products/screen_widgets.dart';

import '../../model/gwc_products_model/get_gwc_products_model.dart';
import '../../widgets/constants.dart';
import 'cart_page.dart';
import 'image_widget.dart';

class ProductView extends StatefulWidget {
  final int cartItemCount;
  final List<GwcProducts> productList;
  final GwcProducts product;
  final String type;
  const ProductView({
    Key? key,
    required this.cartItemCount,
    required this.productList,
    required this.product, required this.type,
  }) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  // Map to keep track of cart quantities
  Map<String, int> cart = {};

  // Function to add item to cart
  void addToCart(String itemName) {
    setState(() {
      cart[itemName] = 1;
    });
  }

  // Function to increase quantity
  void incrementQuantity(String itemName) {
    setState(() {
      cart[itemName] = (cart[itemName] ?? 0) + 1;
    });
  }

  // Function to decrease quantity
  void decrementQuantity(String itemName) {
    setState(() {
      if (cart[itemName] != null && cart[itemName]! > 1) {
        cart[itemName] = cart[itemName]! - 1;
      } else {
        cart.remove(itemName); // Remove item from cart if quantity is 1
      }
    });
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
          product: widget.product,
          type: widget.type.toString(),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: double.maxFinite,
                margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 2.h),
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
                          widget.product.name ?? '',
                          style: TextStyle(
                            fontSize: 15.dp,
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: NetworkImageWithFallback(
                          networkImageUrl: widget.product.itemPhoto ?? '',
                          height: 40.h,
                          width: 40.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                margin: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 1.5.w),
                padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.h),
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

  mainView(){
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.h),
          Text(
            '${widget.product.name} | ${widget.product.maxWeight}${widget.product.maxQtyUnit} | ${widget.product.orderServings} Servings',
            style: TextStyle(
              fontFamily: kFontMedium,
              color: gTextColor,
              fontSize: 18.dp,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.5.h),
            child: Text(
              widget.type,
              style: TextStyle(
                fontFamily: kFontBook,
                color: gTextColor,
                fontSize: 11.dp,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '₹',
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 11.dp,
                    fontFamily: kFontBook,
                    color: gBlackColor,
                  ),
                ),
                TextSpan(
                  text: widget.product.price == "null" ? "00" : widget.product.price,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 15.dp,
                    fontFamily: kFontMedium,
                    color: gBlackColor,
                  ),
                ),
                TextSpan(
                  text: ".00",
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 11.dp,
                    fontFamily: kFontBook,
                    color: gBlackColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(height: 1.h),
          Text('Product description',
            style: TextStyle(
              fontFamily: kFontMedium,
              color: gTextColor,
              fontSize: 15.dp,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 2.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CartPage(
                          cartItemCount: widget.cartItemCount,
                          productList: widget.productList,
                          product: widget.product,
                          type: widget.type.toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Go to cart",
                      style: TextStyle(
                        fontSize: 15.dp,
                        fontFamily: kFontBook,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                cart.containsKey(widget.product.name)
                    ? Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 1.h, horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: gWhiteColor,
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.remove),
                        onTap: () =>
                            decrementQuantity(widget.product.name.toString()),
                      ),
                      SizedBox(width: 1.5.w),
                      Text('${cart[widget.product.name]}'),
                      SizedBox(width: 1.5.w),
                      GestureDetector(
                        child: const Icon(Icons.add),
                        onTap: () =>
                            incrementQuantity(widget.product.name.toString()),
                      ),
                    ],
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    addToCart(widget.product.name.toString());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 13.dp,
                        fontFamily: kFontBook,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
