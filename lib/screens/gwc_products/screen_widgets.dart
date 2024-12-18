import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_network/image_network.dart';

import '../../model/gwc_products_model/get_gwc_products_model.dart';
import '../../widgets/constants.dart';
import 'cart_page.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int cartItemCount;
  final List<GwcProducts> productList;
  final GwcProducts? product;
  final String type;
  const CommonAppBar({Key? key, required this.cartItemCount, required this.productList, this.product, required this.type}) : super(key: key);

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // This must be defined
}

class _CommonAppBarState extends State<CommonAppBar> {

  TextEditingController searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterItems();
      if (searchController.text.isNotEmpty) {
        showOverlay();
      } else {
        removeOverlay();
      }
    });
  }
  List<GwcProducts> filteredItems = [];

  void filterItems() {
    setState(() {
      filteredItems = widget.productList
          .where((item) => item.name!
          .toLowerCase()
          .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void showOverlay() {
    if (_overlayEntry != null) _overlayEntry!.remove();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.25,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset:
          const Offset(0, 50), // Adjust this based on the search bar height
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 40.h,
              width: 25.w,
              // margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: buildList(
                filteredItems,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      backgroundColor: profileBackGroundColor,
      title: Row(
        children: [
          SizedBox(width: 1.w),
          Image(
            image: const AssetImage(
              "assets/images/progress_logo.png",
            ),
            height: 4.h,
          ),
          SizedBox(width: 0.5.w),
          Text(
            "Additional Products By Gut Wellness Club",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: kFontBold,
              color: gBlackColor,
              fontSize: 16.dp,
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: 20.w,
          child: CompositedTransformTarget(
            link: layerLink,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
        SizedBox(width: 1.w),
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap:(){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cartItemCount: widget.cartItemCount,
                        productList: widget.productList,
                        type: widget.type.toString(),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 28, // Adjust icon size as needed
                  color: gBlackColor,
                ),
              ),
              if (widget.cartItemCount > 0)
                Positioned(
                  right:
                  -6, // Adjust this value to control horizontal position
                  top: -6, // Adjust this value to control vertical position
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${widget.cartItemCount}',
                      style: TextStyle(
                        fontSize: 9.dp,
                        color: gWhiteColor,
                        fontFamily: kFontBook,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            // Navigate to cart or show cart page
          },
        ),
        SizedBox(width: 1.w),
      ],
    );
  }

  buildList(List<GwcProducts> lst) {
    return  Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: lst.length,
        itemBuilder: ((context, index) {
          var item = lst[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 1.h,
            ),
            child: showItems(item),
          );
        }),
      ),
    );
  }

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

  showItems(GwcProducts item) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: gWhiteColor,
          border: Border.all(
              color: eUser().buttonBorderColor,
              width: eUser().buttonBorderWidth),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                ImageNetwork(
                  image: item.itemPhoto ?? '',
                  height: 6.h,
                  width: 4.w,
                  duration: 1500,
                  onPointer: true,
                  debugPrint: false,
                  fullScreen: false,
                  borderRadius: BorderRadius.circular(8),
                  fitAndroidIos: BoxFit.fill,
                  fitWeb: BoxFitWeb.fill,
                  onLoading: const CircularProgressIndicator(
                    color: Colors.indigoAccent,
                  ),
                  onError: const Image(
                    image: AssetImage(
                      'assets/images/meal_placeholder.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                  onTap: () {},
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    '${item.name} | ${item.maxWeight}${item.maxQtyUnit} | ${item.orderServings} Servings',
                    style: TextStyle(
                      fontFamily: kFontMedium,
                      color: gTextColor,
                      fontSize: 12.dp,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '₹',
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 13.dp,
                          fontFamily: kFontBook,
                          color: gBlackColor,
                        ),
                      ),
                      TextSpan(
                        text: item.price == "null" ? "00" : item.price,
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
                          fontSize: 13.dp,
                          fontFamily: kFontBook,
                          color: gBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
                cart.containsKey(item.name)
                    ? Container(
                  // padding: EdgeInsets.symmetric(
                  //     vertical: 1.5.h, horizontal: 2.w),
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
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () =>
                            decrementQuantity(item.name.toString()),
                      ),
                      Text('${cart[item.name]}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            incrementQuantity(item.name.toString()),
                      ),
                    ],
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    addToCart(item.name.toString());
                    // setState(() {
                    //   cartItemCount++;
                    // });
                    // removeOverlay();
                    // searchController.clear();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.5.h, horizontal: 2.w),
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
          ],
        ),
      ),
    );
  }

}