import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomPhotoViewer extends StatelessWidget {
  final String url;
  const CustomPhotoViewer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
      imageProvider: CachedNetworkImageProvider(
        url,
      ),
    ),);
  }
}
