class Getrecentuserlistparams {
  String uid;
  String page;
  String limit;
  String sort_by;
  String key;

  Getrecentuserlistparams({
      this.uid, 
      this.page, 
      this.key ,
    this.sort_by,
      this.limit});

  Getrecentuserlistparams.fromJson(dynamic json) {
    uid = json["uid"];
    page = json["page"];
    key  = json["key"];
    sort_by = json["sort_by"];
    limit = json["limit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["page"] = page;
    map["limit"] = limit;
    map["sort_by"] = sort_by;
    map["key"] = key;
    return map;
  }

}