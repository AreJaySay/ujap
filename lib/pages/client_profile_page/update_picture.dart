import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/client_profile_page/profile_information.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/services/image_uploader.dart';
import '../../globals/variables/other_variables.dart';

bool changeProfilePict = false;

class UpdatePicture extends StatefulWidget {
  String chooseFrom;
  UpdatePicture(this.chooseFrom);
  @override
  _UpdatePictureState createState() => _UpdatePictureState();
}

class _UpdatePictureState extends State<UpdatePicture> {
  File _file;
  var binaryImage;
  int choice = 0;
  bool _isLoading = false;
  Future _choosecamera() async {
    _file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    print('IMAGE PHOTO :'+_file.toString());
    if(_file != null) {
      final  g = await _file.readAsBytes();
      setState(() {
        choice = 1;
        binaryImage = g;
      });
    }
  }

  Future _choosegallery() async {
    _file = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    print('IMAGE PHOTO GALLERY:'+_file.toString());
    if(_file != null) {
      final g = await _file.readAsBytes();
      setState(() {
        choice = 2;
        binaryImage = g;
      });
    }
  }
  Future crop() async {
    File cropped = await ImageCropper.cropImage(sourcePath: _file.path);
    if(cropped != null){
      final g = await cropped.readAsBytes();
      setState(() {
        _file = cropped;
        binaryImage = g;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.chooseFrom.toString() == "TakePhoto"){
      _choosecamera();
    }else{
      _choosegallery();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Text("Changer la photo"),
          ),
          body: Container(
            width: double.infinity,
            child:
            // _file == null ? Container(
            //   padding: const EdgeInsets.all(20),
            //   child: Column(
            //     children: <Widget>[
            //       Expanded(
            //         child: GestureDetector(
            //           onTap: () => _choosecamera(),
            //           child: Container(
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(10),
            //               border: Border.all(color: kPrimaryColor, width: 2)
            //             ),
            //             child: Center(
            //               child: Icon(Icons.camera_alt,color: kPrimaryColor, size: screenheight/8,),
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         height: 20,
            //       ),
            //       Expanded(
            //         child: GestureDetector(
            //           onTap: () => _choosegallery(),
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 border: Border.all(color: kPrimaryColor, width: 2)
            //             ),
            //             child: Center(
            //               child: Icon(Icons.photo,color: kPrimaryColor, size: screenheight/8,),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ) :
            Column(
              children: <Widget>[
                Expanded(
                  child: _file == null ? Container() : Container(
                    child: Image.memory(_file.readAsBytesSync()),
                  ),
                ),
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: screenheight > 700 ? screenheight/12 : screenheight/10,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.cancel,color: Colors.red,),
                            onPressed: () => setState((){
                              _file = null;
                              binaryImage = null;
                            }),
                          ),
                        ),
                        Expanded(
                          child: Builder(
                            builder:(context)=> IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.check_circle, color: Colors.green,size: 40,),
                              onPressed: (){
//                              var _newPhoto = _file.path.split('/')[_file.path.split('/').length - 1];
//                              print(_newPhoto);
//                              print(userdetails['filename']);
                                setState(() {
                                  _isLoading = true;
                                });
//
                                UploadImage().init(context,file: _file, id: userdetails['id']).then((value) {
                                  if(value){
                                    print('IMAGE HERE');
                                    login(user, pass, context, true);
                                    changeProfilePict = true;
                                  }else{
                                    // showSnackBar_download(context, 'Please check your internet connection', Icon(Icons.network_check));
                                    setState(() {
                                      _file = null;
                                      binaryImage = null;
                                    });
                                  }
                                }).whenComplete(() => setState(() => _isLoading = false));
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.crop,color: kPrimaryColor,),
                            onPressed: () => crop(),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
        ),
        _isLoading ? WillPopScope(
          onWillPop: () async => false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 4.0,sigmaX: 4.0),
            child: Container(
              width: double.infinity,
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: 2,),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Veuillez patienter un instant ...',style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 45 : 25, color: Colors.grey[200], fontFamily: 'Google-Medium',decoration: TextDecoration.none),)

                  ],
                ),
              ),
            ),
          ),
        ) : Container()
      ],
    );
  }
}
