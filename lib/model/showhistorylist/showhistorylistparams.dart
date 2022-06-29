class Showhistorylistparams {
  String uid;
  String limit;
  String page;

  Showhistorylistparams({
      this.uid, 
      this.limit, 
      this.page});

  Showhistorylistparams.fromJson(dynamic json) {
    uid = json["uid"];
    limit = json["limit"];
    page = json["page"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["limit"] = limit;
    map["page"] = page;
    return map;
  }

}