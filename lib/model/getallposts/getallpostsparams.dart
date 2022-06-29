class Getallpostsparams {
  String userid;
  String page;
  String limit;

  Getallpostsparams({
      this.userid, 
      this.page, 
      this.limit});

  Getallpostsparams.fromJson(dynamic json) {
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