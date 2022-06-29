class Collection_list_response {
  String status;
  List<CollectionData> collectionData;
  bool loggedin;

  Collection_list_response({
      this.status, 
      this.collectionData, 
      this.loggedin});

  Collection_list_response.fromJson(dynamic json) {
    status = json["status"];
    if (json["collectionData"] != null) {
      collectionData = [];
      json["collectionData"].forEach((v) {
        collectionData.add(CollectionData.fromJson(v));
      });
    }
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (collectionData != null) {
      map["collectionData"] = collectionData.map((v) => v.toJson()).toList();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}

class CollectionData {
  int id;
  int uid;
  int post_type;
  String collectionName;
  String post_media_url;
  String createdAt;
  dynamic updatedAt;

  CollectionData({
      this.id, 
      this.uid, 
      this.post_type,
      this.collectionName,
      this.post_media_url,
      this.createdAt,
      this.updatedAt});

  CollectionData.fromJson(dynamic json) {
    id = json["id"];
    uid = json["uid"];
    post_media_url = json["post_media_url"];
    post_type = json["post_type"];
    collectionName = json["collection_name"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uid"] = uid;
    map["post_media_url"] = post_media_url;
    map["post_type"] = post_type;
    map["collection_name"] = collectionName;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}