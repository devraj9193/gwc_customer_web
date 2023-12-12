import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ComingSoonWidget extends StatelessWidget {
  final String imagePath;
  const ComingSoonWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Lottie.asset(imagePath)
        ),
      ),
    );
  }
}
