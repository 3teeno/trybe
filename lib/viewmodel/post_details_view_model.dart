


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/createplaylist/createplaylistparams.dart';
import 'package:trybelocker/model/createplaylist/createplaylistresponse.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_params.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_response.dart';
import 'package:trybelocker/model/favouritecollectios/create_collection_params.dart';
import 'package:trybelocker/model/favouritecollectios/create_collectionresponse.dart';
import 'package:trybelocker/model/fullpostdetail/full_detail_post_params.dart';
import 'package:trybelocker/model/fullpostdetail/full_detail_post_response.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/model/likepost/likepostparams.dart';
import 'package:trybelocker/model/likepost/likepostresponse.dart';
import 'package:trybelocker/model/reportpost/reportpost_params.dart';
import 'package:trybelocker/model/reportpost/reportpost_response.dart';
import 'package:trybelocker/model/savecollectionpost/save_post_collection_params.dart';
import 'package:trybelocker/model/savecollectionpost/savepostcollectionresponse.dart';
import 'package:trybelocker/model/savecollectionpost/unsave_collection_post_response.dart';
import 'package:trybelocker/model/savetrybelist/savetrybelistparams.dart';
import 'package:trybelocker/model/savetrybelist/savetrybelistresponse.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';

class PostDetailsViewModel extends ChangeNotifier{
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;
  getCollectionLoaded() => _isCollectionLoaded;


  Future<dynamic> getfullpostdetails(Full_detail_post_params params, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    try{
      var response = await APIHandler.post(context: context, url: APIs.fulldetailpost, requestBody: params.toJson());
      Full_detail_post_response full_detail_post_response  = new Full_detail_post_response.fromJson(response);
      if (full_detail_post_response != null && full_detail_post_response.status != null && full_detail_post_response.status.trim().length > 0) {
        hideLoader();
        completer.complete(full_detail_post_response);
        notifyListeners();
        return completer.future;
      } else {
        hideLoader();
        completer.complete(null);
        notifyListeners();
        return completer.future;
      }
    }catch(e){
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;

    }

  }

  Future<dynamic> likepost(Likepostparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.likepost, requestBody: request.toJson());
    print("testsuccess=>$response");
    Likepostresponse likepostresponse = new Likepostresponse.fromJson(response);
    if (likepostresponse != null && likepostresponse.status != null && likepostresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(likepostresponse);
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

  Future<dynamic> dislikepost(Likepostparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.likepost, requestBody: request.toJson());
    print("testsuccess=>$response");
    Likepostresponse likepostresponse = new Likepostresponse.fromJson(response);
    if (likepostresponse != null && likepostresponse.status != null && likepostresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(likepostresponse);
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

  Future<dynamic> reportpost(Reportpost_params request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.reportpost, requestBody: request.toJson());
    print("testsuccess=>$response");
    Reportpost_response post_comment_response = new Reportpost_response.fromJson(response);
    if (post_comment_response != null && post_comment_response.status != null && post_comment_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(post_comment_response);
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


  Future<dynamic> unsavepostcollection(Save_post_collection_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.savepsotcollection, requestBody: request.toJson());
    Unsave_collection_post_response unsave_collection_post_response  = new Unsave_collection_post_response.fromJson(response);
    if (unsave_collection_post_response != null && unsave_collection_post_response.status != null && unsave_collection_post_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(unsave_collection_post_response);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> savepostcollection(Save_post_collection_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.savepsotcollection, requestBody: request.toJson());
    Savepostcollectionresponse collectionlistresponse  = new Savepostcollectionresponse.fromJson(response);
    if (collectionlistresponse != null && collectionlistresponse.status != null && collectionlistresponse.status.trim().length > 0) {
      completer.complete(collectionlistresponse);
      notifyListeners();
      return completer.future;
    } else {
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

  Future<dynamic> savepostplaylist(Savetrybelistparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.saveplaylist, requestBody: request.toJson());
    Savetrybelistresponse savetrybelistresponse  = new Savetrybelistresponse.fromJson(response);
    if (savetrybelistresponse != null && savetrybelistresponse.status != null && savetrybelistresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(savetrybelistresponse);
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