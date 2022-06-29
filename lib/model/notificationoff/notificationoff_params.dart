class NotificationoffParams {
  String uid;
  String otherUid;
  String notificationValue;

  NotificationoffParams({
      this.uid, 
      this.otherUid, 
      this.notificationValue});

  NotificationoffParams.fromJson(dynamic json) {
    uid = json["uid"];
    otherUid = json["other_uid"];
    notificationValue = json["notification_value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["other_uid"] = otherUid;
    map["notification_value"] = notificationValue;
    return map;
  }

}