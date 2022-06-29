class Full_detail_post_params {
  String postId;
  String uid;

  Full_detail_post_params({
      this.postId, 
      this.uid});

  Full_detail_post_params.fromJson(dynamic json) {
    postId = json["post_id"];
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["post_id"] = postId;
    map["uid"] = uid;
    return map;
  }

}