import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AttachmentsViewScreen extends StatefulWidget {
  final String attachmentUrl;
  const AttachmentsViewScreen({Key? key, required this.attachmentUrl}) : super(key: key);

  @override
  State<AttachmentsViewScreen> createState() => _AttachmentsViewScreenState();
}

class _AttachmentsViewScreenState extends State<AttachmentsViewScreen> {
  @override
  Widget build(BuildContext context) {
    return buildView();
  }

  buildView() {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InteractiveViewer(
        panEnabled: false, // Set it to false
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2,
        child: FadeInImage(
          placeholder: const AssetImage("assets/images/placeholder.png"),
          image: CachedNetworkImageProvider("${Uri.parse(widget.attachmentUrl)}"),
          imageErrorBuilder: (_, __, ___) {
            return Image.asset("assets/images/placeholder.png");
          },
        ),
      ),
    );
  }
}
