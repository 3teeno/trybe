import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/accountexecutorlist/executor_list_param.dart';
import 'package:trybelocker/model/accountexecutorlist/executor_list_response.dart';
import 'package:trybelocker/model/deleteExecutor/delete_exe_params.dart';
import 'package:trybelocker/model/deleteExecutor/delete_exe_response.dart';
import 'package:trybelocker/model/requestGroundedAccount/request_grounded_account_params.dart';
import 'package:trybelocker/model/requestGroundedAccount/request_grounded_response.dart';
import 'package:trybelocker/model/requestexecutor/executor_request_params.dart';
import 'package:trybelocker/model/requestexecutor/executor_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/model/searchfollowfollowing/search_followfollowingparams.dart';
import 'package:trybelocker/model/searchfollowfollowing/search_followfollowingresponse.dart';

class AccountExecutorViewModel with ChangeNotifier {
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;
  getCollectionLoaded() => _isCollectionLoaded;

  Future<dynamic> searchexecutorUser(Search_followfollowing request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.searchfollowfollowing, requestBody: request.toJson());
    Search_followfollowingresponse executor_response  = new Search_followfollowingresponse.fromJson(response);
    if (executor_response != null && executor_response.status != null && executor_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(executor_response);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }



  Future<dynamic> acceptedexecutorlist(ExecutorListParam request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(url: APIs.acceptedexecutorlist,context: context, requestBody: request.toJson());
    print("testsuccess=>$response.");
    ExecutorListResponse executorListResponse  = new ExecutorListResponse.fromJson(response);
    if (executorListResponse != null && executorListResponse.status != null && executorListResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(executorListResponse);
      notifyListeners();
      print("testsuccess");
      return completer.future;
    } else {
      print("testfailure");
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }
  Future<dynamic> requestedexecutorlist(ExecutorListParam request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(url: APIs.requestedexecutorlist,context: context, requestBody: request.toJson());
    print("testsuccess=>$response.");
    ExecutorListResponse executorListResponse  = new ExecutorListResponse.fromJson(response);
    if (executorListResponse != null && executorListResponse.status != null && executorListResponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(executorListResponse);
      notifyListeners();
      print("testsuccess");
      return completer.future;
    } else {
      print("testfailure");
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }





  //request executor working   here
  Future<dynamic> requestexecutor(ExecutorRequestParams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.accountexecutorrequest, requestBody: request.toJson());
    print("testsuccess=>$response.");
    ExecutorResponse executor_response  = new ExecutorResponse.fromJson(response);
    if (executor_response != null && executor_response.status != null && executor_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(executor_response);
      notifyListeners();
      print("testsuccess");
      return completer.future;
    } else {
      hideLoader();
      print("testfailure");
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }


  //request executor working   here
  Future<dynamic> requestgroundedAcount(RequestGroundedAccountParams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.requesttransfergroundedaccount, requestBody: request.toJson());
    print("testsuccess=>$response.");
    RequestGroundedResponse executor_response  = new RequestGroundedResponse.fromJson(response);
    if (executor_response != null && executor_response.status != null && executor_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(executor_response);
      notifyListeners();
      print("testsuccess");
      return completer.future;
    } else {
      hideLoader();
      print("testfailure");
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> deleteExecutor(DeleteExeParams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.deleteexecutoraccount, requestBody: request.toJson());
    print("testsuccess=>$response.");
    DeleteExeResponse executor_response  = new DeleteExeResponse.fromJson(response);
    if (executor_response != null && executor_response.status != null && executor_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(executor_response);
      notifyListeners();
      print("testsuccess");
      return completer.future;
    } else {
      hideLoader();
      print("testfailure");
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