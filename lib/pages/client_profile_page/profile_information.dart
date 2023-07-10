import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
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
import 'package:ujap/pages/client_profile_page/update_picture.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/view_message_images.dart';
import 'package:ujap/services/image_uploader.dart';

TextEditingController Fname = new TextEditingController()..text=userdetails['name'] == null ? "" : userdetails['name'].toString();
TextEditingController Lname = new TextEditingController()..text=userdetails['lastname'] == null ? "" : userdetails['lastname'].toString();
TextEditingController telephone = new TextEditingController()..text=userdetails['telephone'] == null ? "" : userdetails['telephone'].toString();
TextEditingController email = new TextEditingController()..text=userdetails['email'] == null ? "" : userdetails['email'].toString();
TextEditingController address = new TextEditingController()..text=userdetails['address'] == null ? "" : userdetails['address'].toString();
TextEditingController city = new TextEditingController()..text=userdetails['city'] == null ? "" : userdetails['city'].toString();
TextEditingController company = new TextEditingController()..text=userdetails['company'] == null ? "" : userdetails['company'].toString();
TextEditingController position = new TextEditingController()..text=userdetails['position'] == null ? "" : userdetails['position'].toString();
TextEditingController country = new TextEditingController()..text=userdetails['country'] == null ? "" : userdetails['country'].toString();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Informations sur le profil', style: TextStyle(fontSize:  16, color: Colors.white, fontFamily: 'Google-Medium'),),
        actions: [
          Builder(
            builder:(context)=> IconButton(
              icon: Icon(Icons.edit, color: _editinformation ?  Colors.transparent : Colors.white,
                size: 22,),
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Image(
                width: 230,
                image: AssetImage("assets/new_app_icon.png"),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: kPrimaryColor.withOpacity(0.8),
          ),
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: kPrimaryColor,width: 3),
                          borderRadius: BorderRadius.circular(1000),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: userdetails['filename'].toString() == "null" ||  userdetails['filename'].toString() == "" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage('https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}')
                          )
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 140,
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.bottomRight,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(1000)
                          ),
                          child: Icon(Icons.camera_alt,color: Colors.white,)
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 15),
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
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 15),
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
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 15),
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
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 15),
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
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 15),
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
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 15),
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
                  controller: company,
                  enabled: _editinformation,
                  style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white.withOpacity(0.9), fontFamily: 'Google-Medium'),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Société',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 15),
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
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 15),
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
                height: 30,
              ),
              !_editinformation ? Container() :
              Builder(
                builder:(context)=> GestureDetector(
                  child: Container(
                    height: 55,
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
                    if (Fname.text.isEmpty){
                      showSnackBar(context, "Le prénom ne doit pas être vide.");
                    }else if (Lname.text.isEmpty){
                      showSnackBar(context, "Le nom de famille ne doit pas être vide.");
                    }
                    else if (telephone.text.isEmpty){
                      showSnackBar(context, "Le téléphone ne doit pas être vide.");
                    }
                    else if (email.text.isEmpty){
                      showSnackBar(context, "L'adresse e-mail ne doit pas être vide.");
                    }
                    else if (address.text.isEmpty){
                      showSnackBar(context, "L'adresse ne doit pas être vide.");
                    }
                    else if (city.text.isEmpty){
                      showSnackBar(context, "La ville ne doit pas être vide.");
                    }
                    else if (company.text.isEmpty){
                      showSnackBar(context, "L'entreprise ne doit pas être vide.");
                    }
                    else if (position.text.isEmpty){
                      showSnackBar(context, "La position ne doit pas être vide.");
                    }
                    else if (country.text.isEmpty){
                      showSnackBar(context, "Le pays ne doit pas être vide.");
                    }else{
                      setState(() {
                        _isLoading = true;
                      });

                      var rng = new Random();
                      Directory tempDir = await getTemporaryDirectory();
                      String tempPath = tempDir.path;
                      File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
                      http.Response response = await http.get(Uri.parse('https://ujap.checkmy.dev/storage/clients/${userdetails['filename'].toString()}'));
                      File result = await file.writeAsBytes(response.bodyBytes);

                      String _userdetails = '{"id":${userdetails['id'].toString()},"name":"${Fname.text.toString()}","telephone":"${telephone.text.toString()}","email":"${email.text.toString()}","address":"${address.text.toString().replaceAll('\n', "")}","city":"${city.text.toString()}","company":"${company.text.toString()}","position":"${position.text.toString()}","country":"${country.text.toString()}","lastname":"${Lname.text.toString()}"}';

                      print('INFO :'+_userdetails.toString());
                      print('PROFILE :'+result.toString());

                      UploadImage().upload(files: result,user: _userdetails).then((value) {
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
                    }
                  },
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
