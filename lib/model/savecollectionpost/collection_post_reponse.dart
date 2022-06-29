import 'package:trybelocker/model/fullpostdetail/full_detail_post_response.dart';
import 'package:trybelocker/model/search/search_response.dart';

class Collection_post_reponse {
  String status;
  CollectionPostDatas collectionData;
  bool loggedin;

  Collection_post_reponse({
      this.status, 
      this.collectionData, 
      this.loggedin});

  Collection_post_reponse.fromJson(dynamic json) {
    status = json["status"];
    collectionData = json["collectionData"] != null ? CollectionPostDatas.fromJson(json["collectionData"]) : null;
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (collectionData != null) {
      map["collectionData"] = collectionData.toJson();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}

class CollectionPostDatas {
  int currentPage;
  List<DataCollection> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  CollectionPostDatas({
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

  CollectionPostDatas.fromJson(dynamic json) {
    currentPage = json["current_page"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(DataCollection.fromJson(v));
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

class DataCollection {
  int id;
  int collectionId;
  int postId;
  FullPostData postData;

  DataCollection({
      this.id, 
      this.collectionId, 
      this.postId, 
      this.postData});

  DataCollection.fromJson(dynamic json) {
    id = json["id"];
    collectionId = json["collection_id"];
    postId = json["post_id"];
    postData = json["postData"] != null ? FullPostData.fromJson(json["postData"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["collection_id"] = collectionId;
    map["post_id"] = postId;
    if (postData != null) {
      map["postData"] = postData.toJson();
    }
    return map;
  }

}


