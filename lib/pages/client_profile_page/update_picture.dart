import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/pages/client_profile_page/profile_page.dart';
import 'package:ujap/services/image_uploader.dart';
import '../../globals/variables/other_variables.dart';

bool changeProfilePict = false;

class UpdatePicture extends StatefulWidget {
  String chooseFrom;
  String pagechecker;
  UpdatePicture(this.chooseFrom,this.pagechecker);
  @override
  _UpdatePictureState createState() => _UpdatePictureState();
}

class _UpdatePictureState extends State<UpdatePicture> {
  File _file;
  var binaryImage;
  int choice = 0;
  bool _isLoading = false;
  Future _choosegallery() async {
   await ImagePicker().getImage(source: ImageSource.gallery).then((value)async {
      if(value != null) {
        setState(() {
          _file = new File(value.path);
        });
        print('IMAGE PHOTO :'+_file.toString());
        final  g = await _file.readAsBytes();
        setState(() {
          choice = 1;
          binaryImage = g;
        });
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
      }
    });
  }

  Future _choosecamera() async {
    await ImagePicker().getImage(source: ImageSource.camera).then((value)async {
      if(value != null) {
        setState(() {
          _file = new File(value.path);
        });
        print('IMAGE PHOTO :'+_file.toString());
        final  g = await _file.readAsBytes();
        setState(() {
          choice = 1;
          binaryImage = g;
        });
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
      }
    });
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
                  child: _file == null ? Container() :
                  Container(
                    child: Image(
                      image: FileImage(_file),
                    ),
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
                                setState(() {
                                  _isLoading = true;
                                });
// //
                                UploadImage().init(context,file: _file, id: userdetails['id']).then((value) {
                                  if(value){
                                    setState(() {
                                      currentindex = 1;
                                      indexListener.update(data: 1);
                                    });
                                    login(user, pass, context, true, widget.pagechecker == "profileinformation" ? true : false);
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
