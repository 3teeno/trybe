class Saveposttohistoryparams {
  String uid;
  String postId;

  Saveposttohistoryparams({
      this.uid, 
      this.postId});

  Saveposttohistoryparams.fromJson(dynamic json) {
    uid = json["uid"];
    postId = json["post_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["post_id"] = postId;
    return map;
  }

}