import 'package:flutter/material.dart';

class NetworkImageWithFallback extends StatelessWidget {
  final String networkImageUrl;
  final double height;
  final double width;

  const NetworkImageWithFallback({
    Key? key,
    required this.networkImageUrl,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        networkImageUrl,
        height: height,
        width: width,
        fit: BoxFit.contain,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          // Show an asset image if the network image fails to load
          return Image.asset(
            'assets/images/meal_placeholder.png',
            fit: BoxFit.contain,
            height: height,
            width: width,
          );
        },
      ),
    );
  }
}
