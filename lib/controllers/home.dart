import 'dart:async';

import 'package:rxdart/subjects.dart';

class IndexListener{
  StreamController _indexStream = new BehaviorSubject();
  Stream get stream => _indexStream.stream;
  update({int data}) => _indexStream.add(data);
}
IndexListener indexListener = IndexListener();