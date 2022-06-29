import 'dart:io';

import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/service/MyService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:trybelocker/service/service_locator.dart';
// import 'package:ext_storage/ext_storage.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class MyServiceImpl extends MyService {
  @override
  Future<void> startdownload(String url, String post_type) async {
  try{
    int id = 0;
    if (MemoryManagement.getNotificationId() != null &&
        MemoryManagement.getNotificationId() > 0) {
      id = MemoryManagement.getNotificationId() + 1;
      MemoryManagement.setnotificationid(id: id);
    } else {
      id = 1;
      MemoryManagement.setnotificationid(id: 1);
    }
    showLocalNotifications(false, "", "Post start Dowloading", id, 0);
    var appDocDir = await getTemporaryDirectory();
    print("dir== $appDocDir");
    var urlName=url.split("/").last;
    var mediaName = urlName.split(".").first;
    String savePath = null;
    if (post_type.compareTo("1") == 0) {
      savePath = appDocDir.path + "/trybe/$mediaName.png";
    } else {
      savePath = appDocDir.path + "/trybe/$mediaName.mov";
    }

    await Dio().download(url, savePath, onReceiveProgress: (count, total) {
      print((count / total * 100).toStringAsFixed(0) + "%");
      showLocalNotifications(true, "", "Post start Dowloading", id, (count / total * 100).toInt());
    }).whenComplete(() {
      new Future.delayed(const Duration(seconds: 1), () {
        showLocalNotifications(
            false, "", "Post downloaded in downloads folder", id, 0);
      });
    });
  }catch(e){

  }
  }

}
