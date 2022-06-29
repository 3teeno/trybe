

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/recentsearch/recentsearchparams.dart';
import 'package:trybelocker/model/recentsearch/recentsearchresponse.dart';
import 'package:trybelocker/model/search/search_params.dart';
import 'package:trybelocker/model/search/search_post_response.dart';
import 'package:trybelocker/model/search/search_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class SearchViewModel extends ChangeNotifier{
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;
  getCollectionLoaded() => _isCollectionLoaded;

  Future<dynamic> searchUser(Search_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.globalusersearch, requestBody: request.toJson());
    Search_response search_response  = new Search_response.fromJson(response);
    if (search_response != null && search_response.status != null && search_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(search_response);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> searchPost(Search_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.globalpostsearch, requestBody: request.toJson());
    Search_post_response search_response  = new Search_post_response.fromJson(response);
    if (search_response != null && search_response.status != null && search_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(search_response);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> getrecentsearchlist(Recentsearchparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.getrecentsearchlist, requestBody: request.toJson());
    Recentsearchresponse recentsearchresponse  = new Recentsearchresponse.fromJson(response);
    if (recentsearchresponse != null && recentsearchresponse.status != null && recentsearchresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(recentsearchresponse);
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