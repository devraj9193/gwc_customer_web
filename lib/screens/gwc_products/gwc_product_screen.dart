import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/screens/gwc_products/product_view.dart';
import 'package:gwc_customer_web/screens/gwc_products/screen_widgets.dart';
import 'package:http/http.dart' as http;
import '../../model/error_model.dart';
import '../../model/gwc_products_model/get_gwc_products_model.dart';
import '../../repository/api_service.dart';
import '../../repository/gwc_products_repo/gwc_products_repo.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'image_widget.dart';

class GwcProductScreen extends StatefulWidget {
  const GwcProductScreen({Key? key}) : super(key: key);

  @override
  State<GwcProductScreen> createState() => _GwcProductScreenState();
}

class _GwcProductScreenState extends State<GwcProductScreen> {
  String? selectedSortOption;
  int cartItemCount = 0;
  TextEditingController searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink layerLink = LayerLink();

  final ScrollController gridController = ScrollController();
  final Map<String, int> categoryIndexMap = {};

  final List<String> sortOptions = [
    'A to Z',
    'Price - High to Low',
    'Price - Low to High',
  ];

  @override
  void initState() {
    super.initState();
    getGwcProductList();
    searchController.addListener(() {
      filterItems();
      if (searchController.text.isNotEmpty) {
        showOverlay();
      } else {
        removeOverlay();
      }
    });
  }

  void scrollToCategory(String category) {
    final index = categoryIndexMap[category] ?? 0;
    final position =
        index * 50.0; // Approximate height of each grid item for scrolling
    gridController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  bool isLoading = false;
  Map<String, List<GwcProducts>> items = {};
  List<GwcProducts> productList = [];
  List<GwcProducts> filteredItems = [];
  GwcProducts? selectedProducts;
  String? selectedKey;

  getGwcProductList() async {
    setState(() {
      isLoading = true;
    });
    final result = await repository.getGwcProductsRepo();
    print("result: $result");

    if (result.runtimeType == GetGwcProductsModel) {
      print("Product List");
      GetGwcProductsModel model = result as GetGwcProductsModel;

      setState(() {
        items = model.data;
        selectedKey = items.keys.first;
        int currentIndex = 0;
        items.forEach((category, products) {
          categoryIndexMap[category] = currentIndex;
          currentIndex += products.length;
        });

        productList =
            items.values.expand((productList) => productList).toList();

        print("All Product : $productList");
      });
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    print(result);
  }

  void filterItems() {
    setState(() {
      filteredItems = productList
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

  // Function to sort items based on the selected option
  void sortItems(String option) {
    setState(() {
      if (option == 'A to Z') {
        items.forEach((key, productList) {
          productList.sort((a, b) =>
              a.name!.compareTo(b.name.toString())); // Sorting by name
        });
      } else if (option == 'Price - High to Low') {
        items.forEach((key, productList) {
          productList.sort((a, b) =>
              b.price!.compareTo(a.price.toString())); // Sorting by name
        });
      } else if (option == 'Price - Low to High') {
        items.forEach((key, productList) {
          productList.sort((a, b) =>
              a.price!.compareTo(b.price.toString())); // Sorting by name
        });
      }
      selectedSortOption = option;
    });
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
                isSearch: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    gridController.dispose();
    removeOverlay();
    super.dispose();
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
          cartItemCount: cartItemCount,
          productList: productList,
          type: "",
        ),
        body: (isLoading)
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: Center(
                  child: buildCircularIndicator(),
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
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
                      child: ListView(
                        children: items.keys.map((key) {
                          return ListTile(
                            title: Text(
                              key,
                              style: key == selectedKey
                                  ? TextStyle(
                                      fontFamily: kFontBold,
                                      color: gsecondaryColor,
                                      fontSize: 15.dp)
                                  : TextStyle(
                                      fontFamily: kFontMedium,
                                      color: gBlackColor,
                                      fontSize: 12.dp),
                            ),
                            selected: key == selectedKey,
                            onTap: () {
                              setState(() {
                                scrollToCategory(key);
                                selectedKey = key;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
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
                      child: buildItems(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  buildItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 20.w,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 14.dp,
                      fontFamily: kFontBook,
                      color: gBlackColor,
                    ),
                  ),
                  items: sortOptions
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: gBlackColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: selectedSortOption,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      sortItems(newValue);
                    }
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 160,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: gWhiteColor,
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: IconStyleData(
                    icon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                    ),
                    iconSize: 14.dp,
                    iconEnabledColor: gBlackColor,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: gWhiteColor,
                    ),
                    offset: const Offset(35, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: WidgetStateProperty.all(6),
                      thumbVisibility: WidgetStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 20.w,
            //       child: CompositedTransformTarget(
            //         link: layerLink,
            //         child: TextField(
            //           controller: searchController,
            //           decoration: InputDecoration(
            //             prefixIcon: const Icon(Icons.search),
            //             hintText: "Search",
            //             border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(8)),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 1.w),
            //     IconButton(
            //       icon: Stack(
            //         clipBehavior: Clip.none,
            //         children: [
            //           const Icon(
            //             Icons.shopping_cart_outlined,
            //             size: 28, // Adjust icon size as needed
            //             color: gBlackColor,
            //           ),
            //           if (cartItemCount > 0)
            //             Positioned(
            //               right:
            //                   -6, // Adjust this value to control horizontal position
            //               top:
            //                   -6, // Adjust this value to control vertical position
            //               child: CircleAvatar(
            //                 radius: 10,
            //                 backgroundColor: Colors.red,
            //                 child: Text(
            //                   '$cartItemCount',
            //                   style: TextStyle(
            //                     fontSize: 9.dp,
            //                     color: gWhiteColor,
            //                     fontFamily: kFontBook,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //         ],
            //       ),
            //       onPressed: () {
            //         // Navigate to cart or show cart page
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: SingleChildScrollView(
            controller: gridController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...groupList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  groupList() {
    List<Column> _data = [];
    items.forEach((dayTime, value) {
      _data.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Text(
                dayTime,
                style: TextStyle(
                  height: 1.5,
                  color: MealPlanConstants().mealNameTextColor,
                  fontSize: 15.dp,
                  fontFamily: MealPlanConstants().mealNameFont,
                ),
              ),
            ),
            buildList(value,type: dayTime),
          ],
        ),
      );
    });
    return _data;
  }

  buildList(List<GwcProducts> lst, {bool isSearch = false,String? type,}) {
    return isSearch
        ? Expanded(
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
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: GridView.builder(
                // controller: gridController,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  crossAxisCount: 2,
                  mainAxisExtent: 18.h,
                ),
                itemCount: lst.length,
                itemBuilder: (context, index) {
                  var item = lst[index];
                  return showItems(item,type: type);
                }),
          );
  }

  showItems(GwcProducts item,{String? type,}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductView(
              cartItemCount: cartItemCount,
              productList: productList,
              product: item,
              type: type.toString(),
            ),
          ),
        );
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
                NetworkImageWithFallback(
                  networkImageUrl: item.itemPhoto ?? '',
                  height: 6.h,
                  width: 4.w,
                ),
                // ImageNetwork(
                //   image: item.itemPhoto ?? '',
                //   height: 6.h,
                //   width: 4.w,
                //   duration: 1500,
                //   onPointer: true,
                //   debugPrint: false,
                //   fullScreen: false,
                //   borderRadius: BorderRadius.circular(8),
                //   fitAndroidIos: BoxFit.fill,
                //   fitWeb: BoxFitWeb.fill,
                //   onLoading: const CircularProgressIndicator(
                //     color: Colors.indigoAccent,
                //   ),
                //   onError: const Image(
                //     image: AssetImage(
                //       'assets/images/meal_placeholder.png',
                //     ),
                //     fit: BoxFit.fill,
                //   ),
                //   onTap: () {},
                // ),
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

  final GwcProductsRepository repository = GwcProductsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
