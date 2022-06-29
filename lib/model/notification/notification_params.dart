class Notification_params {
  String userid;
  String page;
  String limit;

  Notification_params({
      this.userid, 
      this.page, 
      this.limit});

  Notification_params.fromJson(dynamic json) {
    userid = json["userid"];
    page = json["page"];
    limit = json["limit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userid"] = userid;
    map["page"] = page;
    map["limit"] = limit;
    return map;
  }

}