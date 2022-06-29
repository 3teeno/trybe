class AccpetCancelExecutorparams {
  String userId;
  String requestBy;
  int key;

  AccpetCancelExecutorparams({this.userId, this.requestBy, this.key});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = userId;
    map["requested_uid"] = requestBy;
    map["status"] = key;
    return map;
  }
}
