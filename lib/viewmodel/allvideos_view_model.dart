

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/getallvideos/getallvideosparams.dart';
import 'package:trybelocker/model/search/search_post_response.dart';
import 'package:trybelocker/model/showhistorylist/showhistorylistparams.dart';
import 'package:trybelocker/model/showhistorylist/showhistorylistresponse.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class AllVideosViewModel extends ChangeNotifier{
  var _isLoading = false;
  getLoading() => _isLoading;



  Future<dynamic> getallvideos(Getallvideosparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.getallvideos,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
    Search_post_response getallvideosresponse = new Search_post_response.fromJson(response);
    if (getallvideosresponse != null && getallvideosresponse.status != null && getallvideosresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(getallvideosresponse);
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

  Future<dynamic> gethistorylist(Showhistorylistparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.showhistorylist,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
    Showhistorylistresponse showhistorylistresponse = new Showhistorylistresponse.fromJson(response);
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