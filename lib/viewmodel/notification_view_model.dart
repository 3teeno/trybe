import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/acceptNCancelGrounded/accept_cancel_grounded_params.dart';
import 'package:trybelocker/model/acceptNCancelGrounded/accept_cancel_grounded_response.dart';
import 'package:trybelocker/model/acceptcancelrequest/accept_cancel_response.dart';
import 'package:trybelocker/model/acceptcancelrequest/accpet_cancelparams.dart';
import 'package:trybelocker/model/accountexecutor/accpet_cancelexecutorparams.dart';
import 'package:trybelocker/model/notification/notification_params.dart';
import 'package:trybelocker/model/notification/notification_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class NotificationViewModel extends ChangeNotifier {
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;

  getCollectionLoaded() => _isCollectionLoaded;

  Future<dynamic> notification(
      Notification_params request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.notification,
        requestBody: request.toJson());
    print("testsuccess=>$response");
    Notification_response notification_response =
        new Notification_response.fromJson(response);
    if (notification_response != null &&
        notification_response.status != null &&
        notification_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(notification_response);
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

  Future<dynamic> acceptcancelrequest(
      AccpetCancelparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.acceptcancelrequest,
        requestBody: request.toJson());
    print("testsuccess=>$response");
    AcceptCancelResponse acceptCancelResponse =
        new AcceptCancelResponse.fromJson(response);
    if (acceptCancelResponse != null &&
        acceptCancelResponse.status != null &&
        acceptCancelResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(acceptCancelResponse);
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

  Future<dynamic> acceptcancelexecutorrequest(
      AccpetCancelExecutorparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.acceptcancelexecutorrequest,
        requestBody: request.toJson());
    print("testsuccess=>$response");
    AcceptCancelResponse acceptCancelResponse =
        new AcceptCancelResponse.fromJson(response);
    if (acceptCancelResponse != null &&
        acceptCancelResponse.status != null &&
        acceptCancelResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(acceptCancelResponse);
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


  Future<dynamic> acceptcancelgroundedrequest(
      AcceptCancelGroundedParams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.acceptrejecttransfergroundedaccount,
        requestBody: request.toJson());
    print("testsuccess=>$response");
    AcceptCancelGroundedResponse acceptCancelResponse =
    new AcceptCancelGroundedResponse.fromJson(response);
    if (acceptCancelResponse != null &&
        acceptCancelResponse.status != null &&
        acceptCancelResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(acceptCancelResponse);
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

  void hideCollectionLoaded() {
    _isCollectionLoaded = false;
    notifyListeners();
  }

  void showCollectionLoaded() {
    _isCollectionLoaded = true;
    notifyListeners();
  }
}
