class AccpetCancelparams {
  String userId;
  String requestBy;
  String key;

  AccpetCancelparams({this.userId, this.requestBy, this.key});

  AccpetCancelparams.fromJson(dynamic json) {
    userId = json["user_id"];
    requestBy = json["request_by"];
    key = json["key"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["user_id"] = userId;
    map["request_by"] = requestBy;
    map["key"] = key;
    return map;
  }
}
