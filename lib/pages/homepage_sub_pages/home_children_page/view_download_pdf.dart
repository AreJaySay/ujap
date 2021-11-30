import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';

class ViewDownloadPdf extends StatefulWidget {
  @override
  _ViewDownloadPdfState createState() => _ViewDownloadPdfState();
}

class _ViewDownloadPdfState extends State<ViewDownloadPdf> {
  PDFDocument doc;
  Stream _convert()async*{
    doc = await PDFDocument.fromFile(pdfFile);
    print(pdfFile.toString());
    print(pdfFile.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _convert(),
      builder: (context, snapshot) {
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
                    child:  doc == null
                        ? Center(child: CircularProgressIndicator())
                        : PDFViewer(document: doc)),
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
                          child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 26,)),
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
    );
  }
}
