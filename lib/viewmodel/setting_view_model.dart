import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/contactus/contact_us_response.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccparams.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccresponse.dart';
import 'package:trybelocker/model/privacy/privacyparams.dart';
import 'package:trybelocker/model/privacy/privacyresponse.dart';
import 'package:trybelocker/model/resetpassword/resetpasswordparams.dart';
import 'package:trybelocker/model/resetpassword/resetpasswordresponse.dart';
import 'package:trybelocker/model/updateprofile/update_profile_params.dart';
import 'package:trybelocker/model/updateprofile/update_profile_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class SettingViewModel with ChangeNotifier {
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;

  getCollectionLoaded() => _isCollectionLoaded;

  Future<dynamic> updateprofile(
      Update_profile_params request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.updateprofile,
        requestBody: request.toJson());
    print("testsuccess=>$response");
    UpdateProfileResponse updateProfileResponse =
        new UpdateProfileResponse.fromJson(response);
    if (updateProfileResponse != null &&
        updateProfileResponse.status != null &&
        updateProfileResponse.status.trim().length > 0) {
      print("testsuccess");
      hideLoader();
      completer.complete(updateProfileResponse);
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

  Future<dynamic> changeprivacy(
      Privacyparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.changeprivacy,
        requestBody: request.toJson());
    Privacyresponse privacyresponse = new Privacyresponse.fromJson(response);
    if (privacyresponse != null &&
        privacyresponse.status != null &&
        privacyresponse.status.trim().length > 0) {
      completer.complete(privacyresponse);
      return completer.future;
    } else {
      completer.complete(null);
      return completer.future;
    }
  }

  Future<dynamic> contactUsAPI(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.contactus);
    ContactUsResponse contactUsResponse =
        new ContactUsResponse.fromJson(response);
    if (contactUsResponse != null &&
        contactUsResponse.status != null &&
        contactUsResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(contactUsResponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> resetpassword(
      Resetpasswordparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.resetpassword,
        requestBody: request.toJson());
    print("testsuccess=> $response");
    Resetpasswordresponse resetpasswordresponse =
        new Resetpasswordresponse.fromJson(response);
    if (resetpasswordresponse != null &&
        resetpasswordresponse.status != null &&
        resetpasswordresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(resetpasswordresponse);
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

  Future<dynamic> deleteuseraccount(
      Deleteuseraccparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.deleteuseraccount,
        requestBody: request.toJson());
    DeleteuseraccResponse deleteuseraccResponse =
        new DeleteuseraccResponse.fromJson(response);
    if (deleteuseraccResponse != null &&
        deleteuseraccResponse.status != null &&
        deleteuseraccResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(deleteuseraccResponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> sendStripeToken(Map request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.sendstripetoken,
        requestBody: json.encode(request));
    DeleteuseraccResponse deleteuseraccResponse =
        new DeleteuseraccResponse.fromJson(response);
    if (deleteuseraccResponse != null &&
        deleteuseraccResponse.status != null &&
        deleteuseraccResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(deleteuseraccResponse);
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
