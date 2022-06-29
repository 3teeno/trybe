import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/creategroundedaccount/creategroundedaccountresponse.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccparams.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccresponse.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_account_listparams.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_accountlistResponse.dart';
import 'package:trybelocker/model/resetpassword/resetpasswordparams.dart';
import 'package:trybelocker/model/resetpassword/resetpasswordresponse.dart';
import 'package:trybelocker/model/updateprofile/update_profile_params.dart';
import 'package:trybelocker/model/updateprofile/update_profile_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class GroundedAccountViewModel extends ChangeNotifier {
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;

  getCollectionLoaded() => _isCollectionLoaded;

  Future<dynamic> groundedaccountlist(GroundedAccountListparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.groundaccountlist, requestBody: request.toJson());
    GroundedAccountlistResponse groundedAccountlistResponse  = new GroundedAccountlistResponse.fromJson(response);
    if (groundedAccountlistResponse != null && groundedAccountlistResponse.status != null && groundedAccountlistResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(groundedAccountlistResponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }



  Future<dynamic> updateprofile(Update_profile_params request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.updateprofile,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
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

  Future<dynamic> deleteuseraccount(Deleteuseraccparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.deleteuseraccount, requestBody: request.toJson());
    DeleteuseraccResponse deleteuseraccResponse  = new DeleteuseraccResponse.fromJson(response);
    if (deleteuseraccResponse != null && deleteuseraccResponse.status != null && deleteuseraccResponse.status.trim().length > 0) {
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
