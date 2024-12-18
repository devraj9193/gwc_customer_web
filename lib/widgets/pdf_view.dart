import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_to_image_converter/pdf_to_image_converter.dart';
import 'constants.dart';

class PdfView extends StatefulWidget {
  final String pdfUrl;
  const PdfView({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final PdfImageConverter _converter = PdfImageConverter();
  Uint8List? image;

  String? pdfLocalPath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    final pdfUrl = widget.pdfUrl.toString();
    // 'https://kr-shipmultichannel-mum.s3.ap-south-1.amazonaws.com/2290767/labels/shipping-label-644554361-627374143.pdf'; // Replace with your PDF URL

    setState(() {
      isLoading = true;
    });
    try {
      // Step 1: Download the PDF
      final pdfFile = await _downloadPdfFromUrl(pdfUrl);

      if (pdfFile != null) {
        setState(() {
          pdfLocalPath =
              pdfFile.path; // Get the local path of the downloaded PDF
        });

        await _converter.openPdf(pdfLocalPath!);
        image = await _converter.renderPage(0);
        setState(() {});

        print('PDF downloaded and saved at: $pdfLocalPath');
      } else {
        print('Failed to download PDF.');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  // Download PDF from URL and save it to a temporary directory
  Future<File?> _downloadPdfFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Step 2: Get the temporary directory of the device
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/downloaded_pdf.pdf';

        // Step 3: Write the PDF file to the temporary directory
        final file = File(filePath);
        return file.writeAsBytes(response.bodyBytes);
      } else {
        print('Failed to load PDF from URL');
        return null;
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("pdf url : ${widget.pdfUrl}");

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? buildCircularIndicator()
            : (image != null)
                ? Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Image(
                              image: MemoryImage(image!),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: 30.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gsecondaryColor,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 0.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {},
                              child: Center(
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    fontFamily: kFontMedium,
                                    color: gWhiteColor,
                                    fontSize: 13.dp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
      ),
    );
  }
}
