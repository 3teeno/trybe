import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/login/login_params.dart';
import 'package:trybelocker/model/login/loginresponse.dart';
import 'package:trybelocker/model/registration/registration_params.dart';
import 'package:trybelocker/model/registration/registration_response.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_params.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_response.dart';
import 'package:trybelocker/model/setnewpassword/new_password_params.dart';
import 'package:trybelocker/model/setnewpassword/new_password_response.dart';
import 'package:trybelocker/model/updateprofile/update_profile_params.dart';
import 'package:trybelocker/model/updateprofile/update_profile_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/model/receiveotpresetpassword/receive_otp_reset_password_response.dart';
import 'package:trybelocker/model/receiveotpresetpassword/receive_otp_reset_password_params.dart';
class AuthViewModel with ChangeNotifier {
  var _isLoading = false;
  getLoading() => _isLoading;

  Future<dynamic> registration(RegistrationParams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.registrationUrl,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
    RegistrationResponse registrationResponse =
        new RegistrationResponse.fromJson(response);
    if (registrationResponse != null &&
        registrationResponse.status != null &&
        registrationResponse.status.trim().length > 0) {
      print("testsuccess,${registrationResponse.message}");
      hideLoader();
      completer.complete(registrationResponse);
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

  Future<dynamic> login(LoginParams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context, url: APIs.loginUrl, requestBody: request.toJson());
    print("testsuccess=>$response.");
    Loginresponse loginresponse = new Loginresponse.fromJson(response);
    if (loginresponse != null && loginresponse.status != null && loginresponse.status.trim().length > 0) {
      print("testsuccess");
      hideLoader();
      completer.complete(loginresponse);
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

  Future<dynamic> sociallogin(UserDatas request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context, url: APIs.sociallogin, requestBody: request.toJson());
    print("testsuccess=>$response.");
    Loginresponse loginresponse = new Loginresponse.fromJson(response);
    if (loginresponse != null && loginresponse.status != null && loginresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(loginresponse);
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

  Future<dynamic> sendotp(Send_otp_params request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.sendotptoresetpassword, requestBody: request.toJson());
    print("testsuccess=>$response.");
    Send_otp_response send_otp_response = new Send_otp_response.fromJson(response);
    if (send_otp_response != null &&
        send_otp_response.status != null &&
        send_otp_response.status.trim().length > 0) {
      print("testsuccess");
      hideLoader();
      completer.complete(send_otp_response);
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

  Future<dynamic> receiveotp(Receiveotpresetpasswordparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.receiveotptoresetpassword,
        requestBody: request.toJson());
    print("testsuccess=>$response.");
    ReceiveOtpResetPasswordResponse receiveOtpResetPassword =
    new ReceiveOtpResetPasswordResponse.fromJson(response);
    if (receiveOtpResetPassword != null && receiveOtpResetPassword.status != null && receiveOtpResetPassword.status.trim().length > 0) {
      print("testsuccess");
      hideLoader();
      completer.complete(receiveOtpResetPassword);
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


  Future<dynamic> setNewPassword(New_passsword_params request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.setnewpassword,
        requestBody: request.toJson());
    New_password_response newpasswordresponse =
    new New_password_response.fromJson(response);
    if (newpasswordresponse != null && newpasswordresponse.status != null && newpasswordresponse.status.trim().length > 0) {
      print("testsuccess");
      hideLoader();
      completer.complete(newpasswordresponse);
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
