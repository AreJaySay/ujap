import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:external_path/external_path.dart';


var ticketFilename = "";
var ticketdownloadID = "";
var loading_indicator= "";
int loadingIndicator = 0;
File pdfFile;
var message_id = "";

final imgUrl = "https://ujap.checkmy.dev/api/client/documents/download-pdf?filename=$ticketFilename&ticket_id=$ticketdownloadID";
final messageUrl = "https://ujap.checkmy.dev/api/client/chat/download-pdf?filename=$ticketFilename&message_id=$message_id";
//final imgUrl = "http://www.pdf995.com/samples/pdf.pdf";
var dio = Dio();


getPermission()async{
  var _permission = await Permission.storage.request();
  print("PERMISSION ${_permission.toString()}");
}

Future download2(Dio dio, String url, String savePath)async{
  print(url.toString());
  try {
    Response response = await dio.post(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $accesstoken",
              "Accept": "application/json"
            }
        ),
    );

    pdfFile = File (savePath);
    var raf = pdfFile.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    print('FILE RESULT :'+raf.toString());

  }catch (e){

    print("error is");
    print(e);
  }
}

 showDownloadProgress(received, total) {
    if (total != -1) {
      loading_indicator = (received / total * 100).toStringAsFixed(0) + "%";
      loadingIndicator = int.parse((received / total * 100).toStringAsFixed(0).toString());
      print('DOWNLOADING :'+loading_indicator);
    }
}

uploadPDF()async{
    String path;
    if(Platform.isAndroid) {
      path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
    } else {
      Directory tempDir = await getTemporaryDirectory();
      path = tempDir.path;
    }
    String fullpath = "$path/ticket.pdf";
    download2(dio, imgUrl, fullpath);
}



showSnackBar_download(BuildContext context, msg, Icon msgIcon) {
  final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(msg),
      msgIcon
    ],
  ));
  Scaffold.of(context).showSnackBar(snackBar);
}

