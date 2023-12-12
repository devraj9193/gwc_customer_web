/*
not using this screen
 */

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';

class ClapScreen extends StatelessWidget {
  const ClapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 150,
            child: Lottie.network('https://assets6.lottiefiles.com/packages/lf20_drkxsxuy.json'),
          ),
        ),
      ],
    ));
    //getClapButton()));
  }

  Widget getClapButton() {
    return GestureDetector(
        child: Container(
      height: 60.0,
      width: 60.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.pink, width: 1.0),
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.pink, blurRadius: 8.0)]),
      child: const ImageIcon(AssetImage("assets/clap.png"),
          color: Colors.pink, size: 40.0),
    ));
  }
}
