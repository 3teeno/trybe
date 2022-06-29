

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_params.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_response.dart';
import 'package:trybelocker/model/favouritecollectios/create_collection_params.dart';
import 'package:trybelocker/model/favouritecollectios/create_collectionresponse.dart';
import 'package:trybelocker/model/saveViewByStatus/view_by_status_params.dart';
import 'package:trybelocker/model/saveViewByStatus/view_by_status_response.dart';
import 'package:trybelocker/model/savecollectionpost/collection_post_reponse.dart';
import 'package:trybelocker/model/savecollectionpost/get_post_collection_params.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class FavouritesViewModel extends ChangeNotifier{
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;
  getCollectionLoaded() => _isCollectionLoaded;



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
  Future<dynamic> getPostCollection(Get_post_collection_params params, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.getpostcollection, requestBody: params.toJson());
    Collection_post_reponse collection_post_reponse  = new Collection_post_reponse.fromJson(response);
    if (collection_post_reponse != null && collection_post_reponse.status != null && collection_post_reponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(collection_post_reponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> saveViewByStatus(ViewByStatusParams params, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.saveviewbycollection, requestBody: params.toJson());
    ViewByStatusResponse collection_post_reponse  = new ViewByStatusResponse.fromJson(response);
    if (collection_post_reponse != null && collection_post_reponse.status != null && collection_post_reponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(collection_post_reponse);
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