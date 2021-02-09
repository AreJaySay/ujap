import 'package:ujap/globals/user_data.dart';

class SelfChecker{
  bool isPresent({List toCheck}){
    for(var x in toCheck){
      if(x['clients']['id'] == userdetails['id']){
        return true;
      }
    }
    return false;
  }
}