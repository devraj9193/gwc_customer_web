import 'package:flutter/cupertino.dart';

class MyUtility {
  BuildContext context;

  MyUtility(this.context);

  double get w => MediaQuery.of(context).size.width;
  double get h => MediaQuery.of(context).size.height;
}