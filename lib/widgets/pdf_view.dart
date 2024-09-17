import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PdfView extends StatefulWidget {
  final String pdfUrl;
  const PdfView({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {

  double _progress = 0;
  late InAppWebViewController  inAppWebViewController;

  @override
  Widget build(BuildContext context) {

    print("pdf url : ${widget.pdfUrl}");

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: WebUri(
                    // widget.pdfUrl,
                    "https://shiprocket.co/tracking/163436108051",
                    // "https://flutter.dev",
                  )
              ),
              onWebViewCreated: (InAppWebViewController controller){
                inAppWebViewController = controller;
              },
              onProgressChanged: (InAppWebViewController controller , int progress){
                setState(() {
                  _progress = progress / 100;
                });
              },
            ),
            _progress < 1 ? LinearProgressIndicator(
              value: _progress,
            ):const SizedBox()
          ],
        ),
      ),
    );

    //   Scaffold(
    //   body: SafeArea(
    //     child: InAppWebView(
    //       initialUrlRequest: URLRequest(
    //         url: WebUri(
    //           // widget.pdfUrl,
    //           "https://flutter.dev",
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
