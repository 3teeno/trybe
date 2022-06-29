
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:trybelocker/model/treebegroup/create_trybe_params.dart';
import 'package:trybelocker/model/treebegroup/delete_trybe.dart';
import 'package:trybelocker/model/treebegroup/rename_tree.dart';
import 'package:trybelocker/model/treebegroup/treebe_group_list_response.dart';
import 'package:trybelocker/model/treebegroup/treebe_list_params.dart';
import 'package:trybelocker/model/trybemembers/trybe_add_members_response.dart';
import 'package:trybelocker/model/trybemembers/tryebe_add_members_params.dart';
import 'package:trybelocker/model/trybemembers/get_trybe_members_params.dart';
import 'package:trybelocker/model/trybemembers/gettrybe_members_response.dart';

import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';



class TrybeTreeViewModel extends ChangeNotifier{
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;
  getCollectionLoaded() => _isCollectionLoaded;


  Future<dynamic> getAllTreebeGroups(Treebe_list_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.treebegrouplist, requestBody: request.toJson());
    Treebe_group_list_response treebegroupresponse  = new Treebe_group_list_response.fromJson(response);
    if (treebegroupresponse != null && treebegroupresponse.status != null && treebegroupresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(treebegroupresponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> createTrybeTree(Create_trybe_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.createtrybetree, requestBody: request.toJson());
    Treebe_group_list_response treebegroupresponse  = new Treebe_group_list_response.fromJson(response);
    if (treebegroupresponse != null && treebegroupresponse.status != null && treebegroupresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(treebegroupresponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> addtrybemember(Tryebe_add_members_params params, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
     try{
      var response = await APIHandler.post(context: context, url: APIs.addtrybemember, requestBody: params.toJson());
      Trybe_add_members_response trybe_add_members_response  = new Trybe_add_members_response.fromJson(response);
    print("adddapii${response}");
      if (trybe_add_members_response != null && trybe_add_members_response.status != null && trybe_add_members_response.status.trim().length > 0) {
        hideLoader();
        completer.complete(trybe_add_members_response);
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
  Future<dynamic> deleteTrybe(Delete_trybe request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.deletetrybe, requestBody: request.toJson());
    Treebe_group_list_response treebegroupresponse  = new Treebe_group_list_response.fromJson(response);
    if (treebegroupresponse != null && treebegroupresponse.status != null && treebegroupresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(treebegroupresponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> renameTrybe(Rename_tree request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.renametrybe, requestBody: request.toJson());
    Treebe_group_list_response treebegroupresponse  = new Treebe_group_list_response.fromJson(response);
    if (treebegroupresponse != null && treebegroupresponse.status != null && treebegroupresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(treebegroupresponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }
  Future<dynamic> deleteTrybeNode(String id, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.deleteTreeMember, requestBody: {'tree_member_id' :id});
    Treebe_group_list_response treebegroupresponse  = new Treebe_group_list_response.fromJson(response);
    if (treebegroupresponse != null && treebegroupresponse.status != null && treebegroupresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(treebegroupresponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> gettrybemembers(Get_trybe_members_params params, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    try{
      var response = await APIHandler.post(context: context, url: APIs.getmembertree, requestBody: params.toJson());
      Gettrybe_members_response gettrybe_members_response  = new Gettrybe_members_response.fromJson(response);
      if (gettrybe_members_response != null && gettrybe_members_response.status != null && gettrybe_members_response.status.trim().length > 0) {
        hideLoader();
        completer.complete(gettrybe_members_response);
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