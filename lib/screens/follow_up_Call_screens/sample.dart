import 'dart:html' as html;
import 'dart:ui' as ui; // Conditional import handles web-specific APIs

import 'package:flutter/material.dart';

class PdfViewerWeb extends StatelessWidget {
  final String pdfUrl =
      'https://gutandhealth.com/storage/uploads/users/meal_protocol/file_888_20241113_120607.pdf';

  const PdfViewerWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String viewId = 'pdf-viewer';

// // Register the iframe as a platform view for Flutter Web
//     ui.platformViewRegistry.registerViewFactory(
//       viewId,
//       (int viewId) => html.IFrameElement()
//         ..src = pdfUrl
//         ..style.border = 'none', // Removes iframe border
//     );

    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: HtmlElementView(viewType: viewId),
    );
  }
}
