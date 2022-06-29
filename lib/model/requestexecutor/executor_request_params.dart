class ExecutorRequestParams {
  String uid;
  String requestedUid;

  ExecutorRequestParams({
      this.uid, 
      this.requestedUid});

  ExecutorRequestParams.fromJson(dynamic json) {
    uid = json["uid"];
    requestedUid = json["requested_uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["requested_uid"] = requestedUid;
    return map;
  }

}