import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/profile_variables.dart';
import '../../globals/variables/other_variables.dart';

// THIS IS FOR THE SAVE TO DATABASE
final ImagePicker _picker = ImagePicker();

Future _choosecamera() async {
  var file = await _picker.pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
//   BinaryImage = await file.toByteData(format: ImageByteFormat.png);
}

Future _choosegallery() async {
  var file = await _picker.pickImage(
      source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
  ClientImagefile = file as File;
}

showAlertDialog(BuildContext context) {
   showDialog(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(0),
        width: screenwidth,
        height: screenheight,
        // margin: EdgeInsets.symmetric(vertical: 220),
        child: Center(
          child: Container(
            height: screenwidth < 700 ? 140 : 180,
            width: screenwidth,
            margin:
            EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 30 : 100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: screenwidth,
                  color: kPrimaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(
                              top: 10,
                              left: 15,
                              bottom: screenwidth < 700 ? 0 : 20),
                          child: Text(
                            'Image source:',
                            style: TextStyle(
                                fontSize: screenheight / 40,
                                decoration: TextDecoration.none,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                      Container(
                        margin: EdgeInsets.only(right: screenwidth < 700 ? 0 : 10),
                        width: 50,
                        child: InkWell(
                          child: Icon(
                            Icons.close,
                            size: screenheight / 30,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.of(context).pop(null);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            width: screenwidth,
                            height: screenheight,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    width: screenwidth,
                                    height: screenheight,
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.camera_alt,
                                            size: screenwidth < 700 ? 25 : 30,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Camera',
                                            style: TextStyle(
                                                fontSize: screenwidth > 700 ? screenwidth/35 : screenwidth/25,
                                                decoration: TextDecoration.none,
                                                color: Colors.white,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    editProfile = true;
                                    _choosecamera();
                                    Navigator.of(context).pop(null);
                                  },
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                            width: screenwidth,
                            height: screenheight,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.image,
                                            size: screenwidth < 700 ? 25 : 30,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Gallery',
                                            style: TextStyle(
                                                fontSize: screenwidth > 700 ? screenwidth/35 : screenwidth/25,
                                                decoration: TextDecoration.none,
                                                color: Colors.white,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w700),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    editProfile = true;
                                    _choosegallery();
                                    Navigator.of(context).pop(null);
                                  },
                                ),
                                Expanded(
                                  child: Container(
                                    width: screenwidth,
                                    height: screenheight,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      )
   );
}
