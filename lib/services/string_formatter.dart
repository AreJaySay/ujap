import 'dart:convert';

import 'package:intl/intl.dart';

class StringFormatter{
  String titlize({String data}) {
    return data[0].toUpperCase() + data.substring(1).toLowerCase();
  }
  String date({DateTime date}){
    return DateFormat('dd MMM. yyyy').format(date).toString();
  }
  String time({String tt}){
    DateTime _time = DateTime.parse(DateTime.now().toString().split(' ')[0] + ' ' +tt);

    return DateFormat('hh:mm').format(_time).toString();
  }
  Map strToObj(String string){
    return json.decode(string);
  }
  String cleaner(String string){
      return string.replaceAll('\\', '');
  }
}