import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/createplaylist/createplaylistparams.dart';
import 'package:trybelocker/model/createplaylist/createplaylistresponse.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_params.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_response.dart';
import 'package:trybelocker/model/favouritecollectios/create_collection_params.dart';
import 'package:trybelocker/model/favouritecollectios/create_collectionresponse.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';

import 'package:trybelocker/model/registration/registration_params.dart';
import 'package:trybelocker/model/registration/registration_response.dart';

import 'package:trybelocker/model/savetrybelist/savetrybelistparams.dart';
import 'package:trybelocker/model/savetrybelist/savetrybelistresponse.dart';

import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class CreatePostViewModel with ChangeNotifier {
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;
  getCollectionLoaded() => _isCollectionLoaded;

  Future<dynamic> createpost(RegistrationParams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.createpost,
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



  Future<dynamic> createcollection(Create_collection_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.createcollection, requestBody: request.toJson());
    Create_collectionresponse create_collectionresponse  = new Create_collectionresponse.fromJson(response);
    if (create_collectionresponse != null && create_collectionresponse.status != null && create_collectionresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(create_collectionresponse);
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
  Future<dynamic> getallcollections(Collection_list_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.allcollectionlist, requestBody: request.toJson());
    Collection_list_response collectionlistresponse  = new Collection_list_response.fromJson(response);
    if (collectionlistresponse != null && collectionlistresponse.status != null && collectionlistresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(collectionlistresponse);
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
