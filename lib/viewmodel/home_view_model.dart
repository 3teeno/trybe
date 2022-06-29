import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/createplaylist/createplaylistparams.dart';
import 'package:trybelocker/model/createplaylist/createplaylistresponse.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccparams.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccresponse.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_params.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_response.dart';
import 'package:trybelocker/model/favouritecollectios/create_collection_params.dart';
import 'package:trybelocker/model/favouritecollectios/create_collectionresponse.dart';
import 'package:trybelocker/model/fullpostdetail/full_detail_post_params.dart';
import 'package:trybelocker/model/fullpostdetail/full_detail_post_response.dart';
import 'package:trybelocker/model/getallcomment/getallcommentparams.dart';
import 'package:trybelocker/model/getallcomment/getallcommentresponse.dart';
import 'package:trybelocker/model/getallposts/getallpostresponse.dart';
import 'package:trybelocker/model/getallposts/getallpostsparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/model/getpostofplaylist/getpostplaylistparams.dart';
import 'package:trybelocker/model/getpostofplaylist/getpostplaylistresponse.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_account_listparams.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_accountlistResponse.dart';
import 'package:trybelocker/model/likepost/likepostparams.dart';
import 'package:trybelocker/model/likepost/likepostresponse.dart';
import 'package:trybelocker/model/notification/notification_params.dart';
import 'package:trybelocker/model/notification/notification_response.dart';
import 'package:trybelocker/model/postcomment/post_comment_params.dart';
import 'package:trybelocker/model/postcomment/post_comment_response.dart';
import 'package:trybelocker/model/recentsearch/recentsearchparams.dart';
import 'package:trybelocker/model/recentsearch/recentsearchresponse.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistparams.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistresponse.dart';
import 'package:trybelocker/model/reportpost/reportpost_params.dart';
import 'package:trybelocker/model/reportpost/reportpost_response.dart';
import 'package:trybelocker/model/savecollectionpost/collection_post_reponse.dart';
import 'package:trybelocker/model/savecollectionpost/get_post_collection_params.dart';
import 'package:trybelocker/model/savecollectionpost/save_post_collection_params.dart';
import 'package:trybelocker/model/savecollectionpost/savepostcollectionresponse.dart';
import 'package:trybelocker/model/savecollectionpost/unsave_collection_post_response.dart';
import 'package:trybelocker/model/savetrybelist/savetrybelistparams.dart';
import 'package:trybelocker/model/savetrybelist/savetrybelistresponse.dart';
import 'package:trybelocker/model/search/search_post_response.dart';
import 'package:trybelocker/model/treebegroup/create_trybe_params.dart';
import 'package:trybelocker/model/treebegroup/delete_trybe.dart';
import 'package:trybelocker/model/treebegroup/treebe_group_list_response.dart';
import 'package:trybelocker/model/treebegroup/treebe_list_params.dart';
import 'package:trybelocker/model/trybemembers/trybe_add_members_response.dart';
import 'package:trybelocker/model/trybemembers/tryebe_add_members_params.dart';
import 'package:trybelocker/model/trybemembers/get_trybe_members_params.dart';
import 'package:trybelocker/model/trybemembers/gettrybe_members_response.dart';
import 'package:trybelocker/model/search/search_params.dart';
import 'package:trybelocker/model/search/search_response.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/model/privacy/privacyparams.dart';
import 'package:trybelocker/model/privacy/privacyresponse.dart';
import 'package:trybelocker/model/logout/logoutparams.dart';
import 'package:trybelocker/model/logout/logoutresponse.dart';

class HomeViewModel with ChangeNotifier {
  StreamController<bool> controller = StreamController<bool>.broadcast();
  var _isLoading = false;
  var _isCollectionLoaded = false;

  getLoading() => _isLoading;
  getCollectionLoaded() => _isCollectionLoaded;


  Future<dynamic> getallcomment(Getallcommentparams request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.getallcomment, requestBody: request.toJson());
    print("testsuccess=>$response");
    Getallcommentresponse notification_response = new Getallcommentresponse.fromJson(response);
    if (notification_response != null && notification_response.status != null && notification_response.status.trim().length > 0) {
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

  Future<dynamic> postComment(Post_comment_params request, BuildContext context) async {
    print("requet ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.postcomment, requestBody: request.toJson());
    print("testsuccess=>$response");
    Post_comment_response post_comment_response = new Post_comment_response.fromJson(response);
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

  // Future<dynamic> deleteuseraccount(Deleteuseraccparams request, BuildContext context) async {
  //   Completer<dynamic> completer = new Completer<dynamic>();
  //   var response = await APIHandler.post(context: context, url: APIs.deleteuseraccount, requestBody: request.toJson());
  //   DeleteuseraccResponse deleteuseraccResponse  = new DeleteuseraccResponse.fromJson(response);
  //   if (deleteuseraccResponse != null && deleteuseraccResponse.status != null && deleteuseraccResponse.status.trim().length > 0) {
  //     hideLoader();
  //     completer.complete(deleteuseraccResponse);
  //     notifyListeners();
  //     return completer.future;
  //   } else {
  //     hideLoader();
  //     completer.complete(null);
  //     notifyListeners();
  //     return completer.future;
  //   }
  // }

  Future<dynamic> searchUser(Search_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.globalusersearch, requestBody: request.toJson());
    Search_response search_response  = new Search_response.fromJson(response);
    if (search_response != null && search_response.status != null && search_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(search_response);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> searchPost(Search_params request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.globalpostsearch, requestBody: request.toJson());
    Search_post_response search_response  = new Search_post_response.fromJson(response);
    if (search_response != null && search_response.status != null && search_response.status.trim().length > 0) {
      hideLoader();
      completer.complete(search_response);
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

  Future<dynamic> getrecentuserlist(Getrecentuserlistparams params, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    try{
      var response = await APIHandler.post(context: context, url: APIs.getrecentuserlist, requestBody: params.toJson());
      Getrecentuserlistresponse getrecentuserlistresponse  = new Getrecentuserlistresponse.fromJson(response);
      if (getrecentuserlistresponse != null && getrecentuserlistresponse.status != null && getrecentuserlistresponse.status.trim().length > 0) {
        hideLoader();
        completer.complete(getrecentuserlistresponse);
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


  Future<dynamic> addtrybemember(Tryebe_add_members_params params, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    try{
      var response = await APIHandler.post(context: context, url: APIs.addtrybemember, requestBody: params.toJson());
      Trybe_add_members_response trybe_add_members_response  = new Trybe_add_members_response.fromJson(response);
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

  Future<dynamic> getrecentsearchlist(Recentsearchparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.getrecentsearchlist, requestBody: request.toJson());
    Recentsearchresponse recentsearchresponse  = new Recentsearchresponse.fromJson(response);
    if (recentsearchresponse != null && recentsearchresponse.status != null && recentsearchresponse.status.trim().length > 0) {
      hideLoader();
      completer.complete(recentsearchresponse);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  // Future<dynamic> createplaylist(Createplaylistparams request, BuildContext context) async {
  //   Completer<dynamic> completer = new Completer<dynamic>();
  //   var response = await APIHandler.post(context: context, url: APIs.createplaylist, requestBody: request.toJson());
  //   Createplaylistresponse createplaylistresponse  = new Createplaylistresponse.fromJson(response);
  //   if (createplaylistresponse != null && createplaylistresponse.status != null && createplaylistresponse.status.trim().length > 0) {
  //     hideLoader();
  //     completer.complete(createplaylistresponse);
  //     notifyListeners();
  //     return completer.future;
  //   } else {
  //     hideLoader();
  //     completer.complete(null);
  //     notifyListeners();
  //     return completer.future;
  //   }
  // }
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

  Future<dynamic> getpostplaylist(Getpostplaylistparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.getplaylistpost, requestBody: request.toJson());
    Getpostplaylistresponse getpostplaylist  = new Getpostplaylistresponse.fromJson(response);
    if (getpostplaylist != null && getpostplaylist.status != null && getpostplaylist.status.trim().length > 0) {
      hideLoader();
      completer.complete(getpostplaylist);
      notifyListeners();
      return completer.future;
    } else {
      hideLoader();
      completer.complete(null);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> changeprivacy(Privacyparams request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.changeprivacy, requestBody: request.toJson());
    Privacyresponse privacyresponse  = new Privacyresponse.fromJson(response);
    if (privacyresponse != null && privacyresponse.status != null && privacyresponse.status.trim().length > 0) {
      completer.complete(privacyresponse);
      return completer.future;
    } else {
      completer.complete(null);
      return completer.future;
    }
  }

  Future<dynamic> logout(Logoutparams request, BuildContext context) async {
    setLoading();
    notifyListeners();
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(context: context, url: APIs.logoutapi, requestBody: request.toJson());
    Logoutresponse logoutResponse  = new Logoutresponse.fromJson(response);
    if (logoutResponse != null && logoutResponse.status != null && logoutResponse.status.trim().length > 0) {
      hideLoader();
      notifyListeners();
      completer.complete(logoutResponse);
      return completer.future;
    } else {
      completer.complete(null);
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
