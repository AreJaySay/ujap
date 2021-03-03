import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/services/image_uploader.dart';

TextEditingController Fname = new TextEditingController()..text=userdetails['name'].toString();
TextEditingController Lname = new TextEditingController()..text=userdetails['lastname'].toString();
TextEditingController telephone = new TextEditingController()..text=userdetails['telephone'].toString();
TextEditingController email = new TextEditingController()..text=userdetails['email'].toString();
TextEditingController address = new TextEditingController()..text=userdetails['address'].toString();
TextEditingController city = new TextEditingController()..text=userdetails['city'].toString();
TextEditingController state = new TextEditingController()..text=userdetails['state'].toString();
TextEditingController country = new TextEditingController()..text=userdetails['country'].toString();

File sampleFile;
// List <String> userInformation = List<String>();

class ProfileInformation extends StatefulWidget {
  @override
  _ProfileInformationState createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  bool _editinformation = false;

  File _file;
  var binaryImage;
  bool _isLoading = false;

   editInfo(File file, String _toSendMap) async {
    print('PPPPPPPPPPPPPPPP');
    try{
      // toSendMap = "{\"id\": ${clientData['id']},\"name\" : ${clientData['name']},\"telephone\" : ${clientData['telephone']},\"email\" : ${clientData['email']},\"address\" : ${clientData['address']},\"city\" : ${clientData['city']},\"state\" : ${clientData['state']},\"country\" : ${clientData['country']},\"created_at\" : ${clientData['created_at']},\"updated_at\" : ${clientData['updated_at']},\"email_verified_at\" : ${clientData['email_verified_at']},\"reset_token\" : ${clientData['reset_token']},\"lastname\" : ${clientData['lastname']},\"filename\" : ${clientData['filename']}}";
//       String toSendMap = '{"id":8,"name":"Soledad Murphy8","telephone":"291-591-3538 x7146","email":"client8@gmail.com","address":"94360 Sporer Circle\nLoraton, ID 98737","city":"South Caleb","state":"Kansas","country":"Philippines","created_at":null,"updated_at":"2020-08-28T02:51:47.000000Z","email_verified_at":null,"reset_token":"HEVN8dfT1SUgUtSY0SX43yzGp8T8ospFAQVV","lastname":"Johnson8","filename":"","firebase_keys":{"id":2,"client_id":8,"fcm_key":"dMDyzgMXQn-MZZn6dLuUDA:APA91bEZSWXSrjVdfU8XVT2ejmrQnvqnLEJJka8XetlZRzD5CdrmJPWR0GtDtSpFQmLI48mpwgDJMA1ObaTiIitVIXZCHz5pPMhosjs83M-apnZvPti3MD6Kf8oABfS2e7IIUj5yweas","created_at":"2020-08-27T05:45:06.000000Z","updated_at":"2020-08-27T06:24:06.000000Z"}}';


      Dio dio = new Dio();
      FormData formData = new FormData.fromMap({
        "item" : _toSendMap,
        "file" : await MultipartFile.fromFile(file.path)
      });
      print('1'+formData.fields.toString());
      print('2 :'+file.path.toString());
      print('3 :'+formData.files[0].value.filename.toString());
      final response = await dio.post("https://ujap.checkmy.dev/api/client/clients/save", data: formData,options: Options(
          headers: {
            HttpHeaders.authorizationHeader : "Bearer $accesstoken"
          },
      ));
      print('status code :'+response.toString());
      print('message :'+response.toString());
    }catch(e){
      print('ERROR :'+e.toString());
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Container(
                    child: ListView(
                      children: [
                        Container(
                          width: screenwidth,
                          height: screenwidth < 700 ? screenheight : screenheight,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: [
                              Container(
                                  width: screenwidth,
                                  child: Padding(
                                      padding: const EdgeInsets.only(bottom: 2.0),
                                      child: ClipPath(
                                        clipper: CurvedBottom(),
                                        child: Container(
                                          margin: EdgeInsets.all(100),
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/new_app_icon.png"),
                                              )),
                                        ),
                                      ))),
                              Container(
                                width: screenwidth,
                                child: Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 2.0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.topLeft,
                                      color: kPrimaryColor,
                                      width: MediaQuery.of(context).size.width,
                                      height: screenheight,
                                      child: SafeArea(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
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
                                            Text('Informations sur le profil', style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 40 : 25, color: Colors.white, fontFamily: 'Google-Medium'),),
                                            Builder(
                                              builder:(context)=> IconButton(
                                                icon: Icon(Icons.edit, color: _editinformation ?  Colors.transparent : Colors.white,
                                                  size: screenwidth < 700 ? 25 : 30,),
                                                onPressed: () {
                                                  setState(() {
                                                    _editinformation = true;
                                                    showSnackBar(context, 'Vous pouvez maintenant éditer les informations');
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 50),
                    child: Container(
                      width: screenwidth,
                      margin: EdgeInsets.only(top: 60),
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        children: [
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                            child: TextFormField(
                              controller: Fname,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white, fontFamily: 'Google-Medium'),
                              enabled: _editinformation,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Prénom',
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                                ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  )
                              ),
                            ),
                          ),
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                            child: TextFormField(
                              controller: Lname,
                              enabled: _editinformation,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white, fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Nom',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  )
                              ),
                            ),
                          ),
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                            child: TextFormField(
                              controller: telephone,
                              enabled: _editinformation,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white, fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Telephone',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  )
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                            child: TextFormField(
                              controller: email,
                              enabled: _editinformation,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white.withOpacity(0.9), fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  )
                              ),
                            ),
                          ),
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                            child: TextFormField(
                              controller: address,
                              enabled: _editinformation,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white.withOpacity(0.9), fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                  border: InputBorder.none,
                                  labelText: 'Adresse',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  )
                              ),
                              maxLines: null,
                            ),
                          ),
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                            child: TextFormField(
                              enabled: _editinformation,
                              controller: city,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white.withOpacity(0.9), fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Ville',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  )
                              ),
                            ),
                          ),
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                            child: TextFormField(
                              controller: state,
                              enabled: _editinformation,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white.withOpacity(0.9), fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Province',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  )
                              ),
                            ),
                          ),
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                            child: TextFormField(
                              controller: country,
                              enabled: _editinformation,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white.withOpacity(0.9), fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Pays',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)
                                  )
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          !_editinformation ? Container() :
                           Builder(
                             builder:(context)=> GestureDetector(
                                child: Container(
                                  height: screenwidth < 700 ? screenwidth/8 : screenwidth/13,
                                  width: screenwidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: kPrimaryColor,
                                  ),
                                  child: Center(
                                    child: Text('Mettre à jour les informations',style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 42 : 25, color: Colors.white, fontFamily: 'Google-Medium'),)
                                  ),
                                ),
                                onTap: ()async{
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    // final res = await http.get('https://ujap.checkmy.dev/storage/clients/${userdetails['filename'].toString()}' );
                                    //
                                    // final documentDirectory = await getApplicationDocumentsDirectory();
                                    //
                                    // final fileResult = File(join(documentDirectory.path, 'profile.png'));
                                    //
                                    // fileResult.writeAsBytesSync(res.bodyBytes);

                                    // final buffer = data.buffer;
                                    // return new File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
                                    //
                                    // print('PROFILE :'+filePath.toString());

                                    var rng = new Random();
                                    Directory tempDir = await getTemporaryDirectory();
                                    String tempPath = tempDir.path;
                                    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
                                    http.Response response = await http.get('https://ujap.checkmy.dev/storage/clients/${userdetails['filename'].toString()}');
                                    File result = await file.writeAsBytes(response.bodyBytes);

                                    String _userdetails = '{"id" : ${userdetails['id'].toString()},"name" : "${Fname.text.toString()}","telephone" : "${telephone.text.toString()}","email" : "${email.text.toString()}","address" : "${address.text.toString().replaceAll('\n', "")}","city" : "${city.text.toString()}","state" : "${state.text.toString()}","country" : "${country.text.toString()}","lastname" : "${Lname.text.toString()}"}';

                                    UploadImage().upload(files: result).then((value) {
                                      if(value){
                                        setState(() {
                                          userdetails = json.decode(_userdetails);

                                          isCollapsed = true;

                                          drawerController.reverse();
                                          borderRadius = 0.0;
                                          print('CHANGE PROFILE :'+userdetails.toString());
                                        });
                                        _editinformation = false;
                                        showSnackBar(context, 'Informations mises à jour avec succès');
                                        // Navigator.of(context).pop(null);
                                      }else{
                                        print('NOT HERE');
                                        setState(() {
                                          _file = null;
                                          binaryImage = null;
                                        });
                                      }
                                    }).whenComplete(() => setState(() => _isLoading = false));
                                },
                              ),
                           ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: 3,),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Veuillez patienter un instant...',style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 45 : 25, color: Colors.grey[200], fontFamily: 'Google-Medium',decoration: TextDecoration.none),)
                    ],
                  ),
                ),
              ),
            ),
          ) : Container()
        ],
      ),
      onTap: (){
       setState(() {
         SystemChannels.textInput.invokeMethod('TextInput.hide');
       });
      },
    );
  }
}
