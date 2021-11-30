import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'dart:convert';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/client_profile_page/profile_information.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';

Map clientData;
  class UploadImage{
  Future<bool> init(context,{File file, int id}) async {
    try{
      print('USER DETAILS :'+id.toString());

      FormData formData = new FormData.fromMap({
        "id" : id.toString(),
        "file" : await MultipartFile.fromFile(file.path)
      });
      final response_save = await dio.post("https://ujap.checkmy.dev/api/client/clients/save-file", data: formData,options: Options(
          headers: {
            HttpHeaders.authorizationHeader : "Bearer $accesstoken"
          }
      ));
      if(response_save.statusCode == 200){
        print('PROFILE :'+userdetails['filename'].toString());
        return true;
      }
      editProfile = true;
      return false;
    }catch(e){
      print('ERROR :'+e.toString());
      showSnackBar(context, "Une erreur s'est produite. Veuillez réessayer plus tard.");
      return false;
    }
  }

  Future<bool> upload({File files, String user}) async {
    try{
      String _userdetails = '{"id":${userdetails['id'].toString()},"name":"${Fname.text.toString()}","telephone":"${telephone.text.toString()}","email":"${email.text.toString()}","address":"${address.text.toString().replaceAll('\n', "")}","city":"${city.text.toString()}","company":"${company.text.toString()}","position":"${position.text.toString()}","country":"${country.text.toString()}","lastname":"${Lname.text.toString()}"}';
      FormData formData = new FormData.fromMap({
        "item" : _userdetails,
        "file" : await MultipartFile.fromFile(files.path)
      });
      final response_save = await dio.post("https://ujap.checkmy.dev/api/client/clients/save", data: formData,options: Options(
          headers: {
            HttpHeaders.authorizationHeader : "Bearer $accesstoken"
          }
      ));
      if (response_save.statusCode == 200){
        return true;
      }
      editProfile = true;
      print('SUCCESS'+editProfile.toString());
      return false;
    }catch(e){
      print('ERROR :'+e.toString());
      return false;
    }
  }
}