class Save_post_collection_params {
  String key;
  String collectionId;
  String postId;

  Save_post_collection_params({
      this.key, 
      this.collectionId, 
      this.postId});

  Save_post_collection_params.fromJson(dynamic json) {
    key = json["key"];
    collectionId = json["collection_id"];
    postId = json["post_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["key"] = key;
    map["collection_id"] = collectionId;
    map["post_id"] = postId;
    return map;
  }

}