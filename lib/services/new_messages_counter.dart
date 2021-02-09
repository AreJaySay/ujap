import 'dart:async';

import 'package:rxdart/rxdart.dart';

class NMessageCounter{
  BehaviorSubject<int> _count = BehaviorSubject.seeded(0);
  Stream get stream$ => _count.stream;
  int get current => _count.value;

  updateCount(int count){
    _count.add(count);
    print("ASDSAD");
  }

  countFetcher(List messages) {
    var counted = 0;
    for(var x in messages){
      print("${x['unread_messages']}");
      if(x['unread_messages'] != null){
        counted += x['unread_messages'];
      }
    }
    _count.add(counted);
  }
}

NMessageCounter nMessageCounter = NMessageCounter();
//class Bloc{
//  final _subject = BehaviorSubject<int>();
//  Stream<int> get stream => _subject.stream;
//
//}