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
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: kPrimaryColor,
                                                          borderRadius: BorderRadius.circular(1000.0)
                                                      ),
                                                      padding: EdgeInsets.all(screenwidth < 700 ? 2 : 3),
                                                      child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 26,)),
                                                  onTap: (){
                                                    Navigator.pushReplacement(context,PageTransition(child: MainScreen(true),type: PageTransitionType.fade));
                                                  },
                                                ),
                                                Text('Informations sur le profil', style: TextStyle(fontSize:  20, color: Colors.white, fontFamily: 'Google-Medium'),),
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
                                            Center(
                                              child: GestureDetector(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: 10),
                                                      width: 150,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          border: Border.all(color: Colors.white,width: 2),
                                                          borderRadius: BorderRadius.circular(1000),
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                              image: userdetails['filename'].toString() == "null" ||  userdetails['filename'].toString() == "" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage('https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}')
                                                          )
                                                      ),
                                                    ),
                                                  Container(
                                                    width: 150,
                                                    height: 150,
                                                    padding: EdgeInsets.all(5),
                                                    alignment: Alignment.bottomRight,
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius: BorderRadius.circular(1000)
                                                      ),
                                                      child: Icon(Icons.camera_alt,color: Colors.white,)
                                                    ),
                                                  )
                                                  ],
                                                ),
                                                onTap: (){
                                                  setState(() {
                                                    showProfilePict = true;
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
                    margin: EdgeInsets.only(left: 20,right: 20,top: screenwidth/1.6,bottom: 50),
                    child: Container(
                      width: screenwidth,
                      margin: EdgeInsets.only(top: screenwidth/8),
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
                              controller: company,
                              enabled: _editinformation,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white.withOpacity(0.9), fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Société',
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
                          // Container(
                          //   width: screenwidth,
                          //   margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20),
                          //   child: TextFormField(
                          //     controller: position,
                          //     enabled: _editinformation,
                          //     style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white.withOpacity(0.9), fontFamily: 'Google-Medium'),
                          //     decoration: InputDecoration(
                          //         border: InputBorder.none,
                          //         labelText: 'Positionner',
                          //         labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          //         enabledBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(color: Colors.grey)
                          //         ),
                          //         focusedBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(color: Colors.grey)
                          //         ),
                          //         disabledBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(color: Colors.grey)
                          //         )
                          //     ),
                          //   ),
                          // ),
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
          ) : Container(),
          !showProfilePict ? Container() :
          GestureDetector(
            child: Container(
              width: screenwidth,
              height: screenheight,
              alignment: Alignment.bottomCenter,
              color: Colors.black.withOpacity(0.4),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: screenwidth,
                height: !showProfilePict ? 0 : screenwidth < 700 ? screenwidth/1.8 : screenwidth/3.5,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.contacts_outlined),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(1000.0)
                              ),
                              padding: EdgeInsets.all(7),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Voir la photo de profil',style: TextStyle(fontFamily: 'Google-medium',fontSize: screenwidth < 700 ? screenwidth/27 : screenwidth/33,color: Colors.grey[800]),)
                          ],
                        ),
                      ),
                      onPressed: (){
                        Navigator.push(context, PageTransition(child:  ViewMessageImages(
                            userdetails['filename'].toString() == "null" || userdetails['filename'].toString() == "" ? "null" : "https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}"
                        ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                      },
                    ),
                    FlatButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.camera_alt),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(1000.0)
                              ),
                              padding: EdgeInsets.all(7),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Prendre une photo',style: TextStyle(fontFamily: 'Google-medium',fontSize:  screenwidth < 700 ? screenwidth/27 : screenwidth/33,color: Colors.grey[800]),)
                          ],
                        ),
                      ),
                      onPressed: (){
                        setState(() {
                          Navigator.push(context, PageTransition(child: UpdatePicture(
                              "TakePhoto","profileinformation"
                          )));
                        });
                      },
                    ),
                    FlatButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.folder_open),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(1000.0)
                              ),
                              padding: EdgeInsets.all(7),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Photo depuis la galerie',style: TextStyle(fontFamily: 'Google-medium',fontSize:  screenwidth < 700 ? screenwidth/27 : screenwidth/33,color: Colors.grey[800]),)
                          ],
                        ),
                      ),
                      onPressed: (){
                        setState(() {
                          Navigator.push(context, PageTransition(child: UpdatePicture(
                              "UploadPhoto","profileinformation"
                          )));
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            onTap: (){
              setState(() {
                showProfilePict = false;
              });
            },
          )
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
