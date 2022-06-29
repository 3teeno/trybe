

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:trybelocker/model/createplaylist/createplaylistparams.dart';
import 'package:trybelocker/model/createplaylist/createplaylistresponse.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class ProfileViewModel extends ChangeNotifier{
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;
  getCollectionLoaded() => _isCollectionLoaded;


  Future<dynamic> getplaylist(Getplaylistparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.getplaylist, requestBody: request.toJson());
    Getplaylistresponse getplaylistresponse  = new Getplaylistresponse.fromJson(response);
    if (getplaylistresponse != null && getplaylistresponse.status != null && getplaylistresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(getplaylistresponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> createplaylist(Createplaylistparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.createplaylist, requestBody: request.toJson());
    Createplaylistresponse createplaylistresponse  = new Createplaylistresponse.fromJson(response);
    if (createplaylistresponse != null && createplaylistresponse.status != null && createplaylistresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(createplaylistresponse);
      notifyListeners();
      return completer.future;
    } else {
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


  void hideCollectionLoaded() {
    _isCollectionLoaded = false;
    notifyListeners();
  }

  void showCollectionLoaded() {
    _isCollectionLoaded = true;
    notifyListeners();
  }


}