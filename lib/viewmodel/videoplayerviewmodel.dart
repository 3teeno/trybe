

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/saveposttohistory/saveposttohistoryparams.dart';
import 'package:trybelocker/model/saveposttohistory/saveposttohistoryresponse.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class VideoPlayerViewModel extends ChangeNotifier{
  var _isLoading = false;
  getLoading() => _isLoading;


  Future<dynamic> savevideotohistory(Saveposttohistoryparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.saveposttohistory,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
    Saveposttohistoryresponse showhistorylistresponse = new Saveposttohistoryresponse.fromJson(response);
    if (showhistorylistresponse != null && showhistorylistresponse.status != null && showhistorylistresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(showhistorylistresponse);
      notifyListeners();
      return completer.future;
    } else {
      print("testfailure");
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }


  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }


}