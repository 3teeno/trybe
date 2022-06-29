class Likepostparams {
  String key;
  String uid;
  String postId;

  Likepostparams({
      this.key, 
      this.uid, 
      this.postId});

  Likepostparams.fromJson(dynamic json) {
    key = json["key"];
    uid = json["uid"];
    postId = json["post_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["key"] = key;
    map["uid"] = uid;
    map["post_id"] = postId;
    return map;
  }

}