class GroundedAccountListparams {
  String uid;
  String page;
  String limit;

  GroundedAccountListparams({
      this.uid, 
      this.page, 
      this.limit});

  GroundedAccountListparams.fromJson(dynamic json) {
    uid = json["uid"];
    page = json["page"];
    limit = json["limit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["page"] = page;
    map["limit"] = limit;
    return map;
  }

}