

import 'package:firebase_storage/firebase_storage.dart';

abstract class MyService{
Future<void> startdownload(String url,String post_type);
}