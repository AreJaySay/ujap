import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';

class ViewDownloadPdf extends StatefulWidget {
  @override
  _ViewDownloadPdfState createState() => _ViewDownloadPdfState();
}

class _ViewDownloadPdfState extends State<ViewDownloadPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PDFView(
            filePath: pdfFile.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
            },
          ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(1000.0)
                  ),
                  padding: EdgeInsets.all(screenwidth < 700 ? 2 : 3),
                  child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 26,)),
              onTap: (){
                Navigator.of(context).pop(null);
              },
            ),

        ],
      ),
    );
  }
}
