import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
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
      body: Container(
        padding: EdgeInsets.all(0),
        width: double.infinity,
        height: screenheight,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: Container(
                width: 1800,
                height: 1800,
                child: PDF.file(
                  pdfFile,
                  height: pdfFile == null ? screenheight/15 : screenheight/1,
                  width: pdfFile == null ? screenheight/15 :  screenwidth/1,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: screenheight,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: SafeArea(
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(1000.0)
                      ),
                      padding: EdgeInsets.all(screenwidth < 700 ? 2 : 3),
                      child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: screenwidth < 700 ? screenwidth/12 : screenwidth/18,)),
                  onTap: (){
                    Navigator.of(context).pop(null);
                  },
                ),
              ),
            ),
          ],
        ),
    ),
    );
  }
}
