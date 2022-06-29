class AcceptCancelGroundedParams {
  String uid;
  String requestedUid;
  String groundedUid;
  int status;

  AcceptCancelGroundedParams({
      this.uid, 
      this.requestedUid, 
      this.groundedUid, 
      this.status});

  AcceptCancelGroundedParams.fromJson(dynamic json) {
    uid = json["uid"];
    requestedUid = json["requested_uid"];
    groundedUid = json["grounded_uid"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["requested_uid"] = requestedUid;
    map["grounded_uid"] = groundedUid;
    map["status"] = status;
    return map;
  }

}