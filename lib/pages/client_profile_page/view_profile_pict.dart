import 'package:flutter/material.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';

class ViewProfilePicture extends StatefulWidget {
  bool showProfilePict = false;
  ViewProfilePicture(this.showProfilePict);
  @override
  _ViewProfilePictureState createState() => _ViewProfilePictureState();
}

class _ViewProfilePictureState extends State<ViewProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return !widget.showProfilePict ? Container() : Container(
      width: screenwidth,
      height: screenheight,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: screenwidth,
              height: screenheight / 1.5,
              decoration: BoxDecoration(
                color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: userdetails['filename'].toString() == "null" ||  userdetails['filename'].toString() == "" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage('https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}')
                  )

              ),
            ),
            Container(
              width: screenwidth,
              height: screenheight / 1.5,
              padding: EdgeInsets.all(5),
              alignment: Alignment.topRight,
                  child: GestureDetector(
                  child: Container(
                  padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(1000.0)
                    ),
                    child: Icon(Icons.close,size: 30,color: Colors.white,)),
                    onTap: (){
                      setState(() {
                        widget.showProfilePict = false;
                      });
                    },
                ),
            )
          ],
        ),
      ),
    );
  }
}
