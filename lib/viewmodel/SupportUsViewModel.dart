import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/supportUs/support_us_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class SupportUsViewModel with ChangeNotifier {
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;

  getCollectionLoaded() => _isCollectionLoaded;

  Future<dynamic> supportUs(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.supportus);
    SupportUsResponse supportUsResponse =
        new SupportUsResponse.fromJson(response);
    if (supportUsResponse != null &&
        supportUsResponse.status != null &&
        supportUsResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(supportUsResponse);
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
