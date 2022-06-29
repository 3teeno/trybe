class Followunfollowparams {
  String userid;
  String followerId;
  String key;

  Followunfollowparams({
      this.userid, 
      this.followerId, 
      this.key});

  Followunfollowparams.fromJson(dynamic json) {
    userid = json["userid"];
    followerId = json["follower_id"];
    key = json["key"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userid"] = userid;
    map["follower_id"] = followerId;
    map["key"] = key;
    return map;
  }

}