import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsPushEnabled {
  BehaviorSubject<Status> _controller = BehaviorSubject.seeded(null);
  Stream get stream$ => _controller.stream;
  Status get current => _controller.value;
  SharedPreferences _preferences;
  void start() async {
    await getSavedData();
  }
  getSavedData() async {
    _preferences = await SharedPreferences.getInstance();
    String data = _preferences.getString('enabler');
    print("PICKED DATA : $data");
    if(data == null || data == 'granted'){
      _controller.add(Status.granted);
    }else{
      _controller.add(Status.denied);
    }
    print(this.current);
  }
  updateData({String newStatus}) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setString('enabler', newStatus);
    if(newStatus == 'denied') {
      _controller.add(Status.denied);
    }else{
      _controller.add(Status.granted);
    }
  }
  clear() async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.remove('enabler');
  }
}
enum Status {
  granted,
  denied,
  undefined
}
IsPushEnabled isPushEnabled = IsPushEnabled();