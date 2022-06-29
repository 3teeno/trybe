class RequestGroundedAccountParams {
  String uid;
  String requestedUid;
  String groundedUid;

  RequestGroundedAccountParams({
      this.uid, 
      this.requestedUid, 
      this.groundedUid});

  RequestGroundedAccountParams.fromJson(dynamic json) {
    uid = json["uid"];
    requestedUid = json["requested_uid"];
    groundedUid = json["grounded_uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["requested_uid"] = requestedUid;
    map["grounded_uid"] = groundedUid;
    return map;
  }

}