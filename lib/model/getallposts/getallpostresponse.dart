import 'package:trybelocker/model/search/search_response.dart';

class Getallpostresponse {
  String status;
  PostData postData;
  DataUser userData;
  bool loggedin;

  Getallpostresponse({
    this.status,
    this.postData,
    this.userData,
    this.loggedin});

  Getallpostresponse.fromJson(dynamic json) {
    status = json["status"];
    postData = json["postData"] != null ? PostData.fromJson(json["postData"]) : null;
    userData = json["userData"] != null ? DataUser.fromJson(json["userData"]) : null;
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (postData != null) {
      map["postData"] = postData.toJson();
    }
    if (userData != null) {
      map["userData"] = userData.toJson();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}


class PostData {
  int currentPage;
  List<Data> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  int to;
  bool isAdd;
  int total;

  PostData({
      this.currentPage, 
      this.data, 
      this.firstPageUrl, 
      this.from, 
      this.lastPage, 
      this.lastPageUrl, 
      this.nextPageUrl, 
      this.path, 
      this.perPage, 
      this.prevPageUrl, 
      this.to, 
      this.total});

  PostData.fromJson(dynamic json) {
    currentPage = json["current_page"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json["first_page_url"];
    from = json["from"];
    lastPage = json["last_page"];
    lastPageUrl = json["last_page_url"];
    nextPageUrl = json["next_page_url"];
    path = json["path"];
    perPage = json["per_page"];
    prevPageUrl = json["prev_page_url"];
    to = json["to"];
    isAdd = json["isAdd"];
    total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["current_page"] = currentPage;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    map["first_page_url"] = firstPageUrl;
    map["from"] = from;
    map["last_page"] = lastPage;
    map["last_page_url"] = lastPageUrl;
    map["next_page_url"] = nextPageUrl;
    map["path"] = path;
    map["per_page"] = perPage;
    map["prev_page_url"] = prevPageUrl;
    map["to"] = to;
    map["total"] = total;
    return map;
  }

}

class Data {
  int id;
  int uid;
  int postType;
  bool isliked;
  int likes;
  int collectionId;
  int playlistId;
  int comment;
  bool isSelected=false;
  bool isSaved;
  bool isPlaylistSaved;
  int isFollowed;
  String postMediaUrl;
  String postCaption;
  String status;
  String createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  DataUser userInfo;
  bool isAdd;


  setMenuData(bool isSelected){
    this.isSelected=isSelected;
  }
  Data({
      this.id, 
      this.uid, 
      this.postType, 
      this.isliked,
      this.likes,
      this.isSelected,
      this.comment,
      this.isSaved,
      this.isPlaylistSaved,
      this.isFollowed,
      this.collectionId,
      this.playlistId,
      this.postMediaUrl,
      this.postCaption, 
      this.status,
      this.createdAt,
      this.updatedAt, 
      this.deletedAt, 
      this.userInfo});

  Data.fromJson(dynamic json) {
    id = json["id"];
    uid = json["uid"];
    postType = json["post_type"];
    isliked = json["isliked"];
    isSelected = json["isSelected"];
    likes = json["likes"];
    comment = json["comment"];
    isFollowed = json["isFollowed"];
    isSaved = json["isSaved"];
    isPlaylistSaved = json["isPlaylistSaved"];
    isFollowed = json["isFollowed"];
    collectionId = json["collectionId"];
    playlistId = json["playlistId"];
    postMediaUrl = json["post_media_url"];
    postCaption = json["post_caption"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
    isAdd = json["isAdd"]??false;

    userInfo = json["userInfo"] != null ? DataUser.fromJson(json["userInfo"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uid"] = uid;
    map["post_type"] = postType;
    map["likes"] = likes;
    map["isSelected"] = isSelected;
    map["isliked"] = isliked;
    map["comment"] = comment;
    map["isFollowed"] = isFollowed;
    map["isSaved"] = isSaved;
    map["isPlaylistSaved"] = isPlaylistSaved;
    map["collectionId"] = collectionId;
    map["post_media_url"] = postMediaUrl;
    map["post_caption"] = postCaption;
    map["status"] = status;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
    map["isAdd"] = isAdd;
    if (userInfo != null) {
      map["userInfo"] = userInfo.toJson();
    }
    return map;
  }

}


