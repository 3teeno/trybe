class Reportpost_params {
  String userid;
  String postId;

  Reportpost_params({
      this.userid, 
      this.postId});

  Reportpost_params.fromJson(dynamic json) {
    userid = json["userid"];
    postId = json["post_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userid"] = userid;
    map["post_id"] = postId;
    return map;
  }

}