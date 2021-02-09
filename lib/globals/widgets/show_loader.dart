import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ujap/globals/variables/other_variables.dart';

showloader(context){
  return showDialog(
      context: context,
      builder: (_)=> Container(
        width: screenwidth,
        height: screenheight,
        color: Colors.black54,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4,sigmaY: 4),
          child: Container(
              width: screenwidth,
              height: screenheight,
              alignment: AlignmentDirectional.center,
              child: Image(
                fit: BoxFit.contain,
                width: screenwidth/2.5,
                image: AssetImage('assets/loaded-ujap.gif'),
              )
          ),
        ),
      )
  );
}

