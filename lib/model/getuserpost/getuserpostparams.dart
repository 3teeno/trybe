class Getuserpostparams {
  String uid;
  String page;
  String limit;
  String other_uid;

  Getuserpostparams({
      this.uid, 
      this.page, 
      this.limit,
     this.other_uid});

  Getuserpostparams.fromJson(dynamic json) {
    uid = json["uid"];
    page = json["page"];
    limit = json["limit"];
    other_uid = json["other_uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["page"] = page;
    map["limit"] = limit;
    map["other_uid"] = other_uid;
    return map;
  }

}