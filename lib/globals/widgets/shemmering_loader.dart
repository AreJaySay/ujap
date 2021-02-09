import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget loadingShimmering(){
  return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
        ),
      )
  );
}