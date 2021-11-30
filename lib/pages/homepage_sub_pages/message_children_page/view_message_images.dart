import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';

class ViewMessageImages extends StatefulWidget {
  String image;
  ViewMessageImages(this.image);
  @override
  _ViewMessageImagesState createState() => _ViewMessageImagesState();
}

class _ViewMessageImagesState extends State<ViewMessageImages> {

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
          body: Stack(
            children: <Widget>[
             widget.image.toString().contains('pdf') ?
             Container(
               width: 1800,
               height: 1800,
               child: doc == null
                   ? Center(child: CircularProgressIndicator())
                   : PDFViewer(document: doc)
             ) :
             Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: widget.image.toString() == "null" ||  widget.image.toString() == "" ? Colors.white : Colors.grey[300],
                  image: DecorationImage(
                    fit: BoxFit.contain,
                      image: widget.image.toString() == "null" ||  widget.image.toString() == "" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage(widget.image)
                  )
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: GestureDetector(
                      child: Container(
                      padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(1000.0)
                        ),
                        child: Icon(Icons.arrow_back,size: screenwidth < 700 ? 25 : 30,color: Colors.white,)
                    ),
                    onTap: (){
                        Navigator.of(context).pop(null);
                    },
                  ),
                ),
              ),

            ],
          ),
        );
      }
    );
  }
}
