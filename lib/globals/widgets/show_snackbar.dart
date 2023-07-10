import 'package:flutter/material.dart';
import 'package:ujap/globals/variables/other_variables.dart';

showSnackBar(BuildContext context, msg) {
  final snackBar = SnackBar(content: Text(msg));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showSnackBar_Ads(BuildContext context, _imageLink,_httpLink){
  final snackbar = SnackBar(
    backgroundColor: kPrimaryColor,
      duration: Duration(days: 1),
        content: Builder(
        builder:(context)=> GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              height: screenheight/3.3,
              margin: EdgeInsets.all(0),
              child: Stack(
                children: [
                   Container(
                       height:  screenheight/3.3,
                       width: screenwidth,
                       decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color: Colors.grey.withOpacity(0.5),
                             spreadRadius: 5,
                             blurRadius: 7,
                             offset: Offset(0, 3), // changes position of shadow
                           ),
                         ],
                       ),
                       child:  Container(
                             height: screenwidth < 700 ? screenheight/4 : screenheight/3.3,
                             width: screenwidth,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(5),
                               image: DecorationImage(
                                 fit: BoxFit.cover,
                                 image: NetworkImage(_imageLink)
                               )
                             ),
                             ),

                   ),
                  GestureDetector(
                    child: Container(
                      width: screenwidth,
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000)
                        ),
                        child: Icon(Icons.close,color: Colors.grey[300],size: screenwidth < 700 ? 20 : 30,),
                      ),
                    ),
                    onTap: (){
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ],
              ),

            ),
          ),
          onTap: (){
            if (_httpLink.toString() != "null"){
              // _openLink(_httpLink);
            }else{
              showSnackBar(context, 'No link provided yet');
            }
            print(_httpLink.toString());
          },
        ),
      ),
    elevation: 0,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

// _openLink(String _httpLink)async{
//   if (await canLaunch(_httpLink)) {
//     await launch(_httpLink);
//   } else {
//     throw 'Could not launch $_httpLink';
//   }
// }