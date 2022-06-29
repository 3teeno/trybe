import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trybelocker/model/followunfollow/followunfollowparams.dart';
import 'package:trybelocker/model/followunfollow/followunfollowresponse.dart';
import 'package:trybelocker/model/getallvideos/getallvideosparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/model/getuserpost/getuserpostparams.dart';
import 'package:trybelocker/model/getuserpost/getuserpostresponse.dart';
import 'package:trybelocker/model/notificationoff/notificationoff_params.dart';
import 'package:trybelocker/model/notificationoff/notificationoff_response.dart';
import 'package:trybelocker/model/resetpassword/resetpasswordparams.dart';
import 'package:trybelocker/model/resetpassword/resetpasswordresponse.dart';
import 'package:trybelocker/model/search/search_post_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class PublicProfileViewModel with ChangeNotifier {
  var _isLoading = false;
  getLoading() => _isLoading;

  Future<dynamic> followunfollow(Followunfollowparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.followunfollow,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
    Followunfollowresponse followunfollowresponse =
    new Followunfollowresponse.fromJson(response);
    if (followunfollowresponse != null &&
        followunfollowresponse.status != null &&
        followunfollowresponse.status.trim().length > 0) {
      print("testsuccess,${followunfollowresponse.message}");
      hideLoader();
      completer.complete(followunfollowresponse);
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

  Future<dynamic> notificationoffapi(NotificationoffParams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.notificationoff,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
    NotificationoffResponse notificationoffResponse =
    new NotificationoffResponse.fromJson(response);
    if (notificationoffResponse != null &&
        notificationoffResponse.status != null &&
        notificationoffResponse.status.trim().length > 0) {
      print("testsuccess,${notificationoffResponse.message}");
      hideLoader();
      completer.complete(notificationoffResponse);
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

  Future<dynamic> getuserposts(Getuserpostparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.getuserposts,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
    Getuserpostresponse getuserpostresponse = new Getuserpostresponse.fromJson(response);
    if (getuserpostresponse != null && getuserpostresponse.status != null && getuserpostresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(getuserpostresponse);
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

  Future<dynamic> getallimages(Getallvideosparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.getallimages,
        requestBody: request.toJson());
    print("allImagesResponse=>$response");
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



  Future<dynamic> resetpassword(Resetpasswordparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.resetpassword,
        requestBody: request.toJson());
    print("testsuccess=>$response");
    Resetpasswordresponse resetpasswordresponse = new Resetpasswordresponse.fromJson(response);
    if (resetpasswordresponse != null && resetpasswordresponse.status != null && resetpasswordresponse.status.trim().length > 0) {
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
  Future<dynamic> getplaylist(Getplaylistparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
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

  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }
}
