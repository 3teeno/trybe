class Getallcommentparams {
  String postId;
  String page;
  String limit;

  Getallcommentparams({
      this.postId, 
      this.page, 
      this.limit});

  Getallcommentparams.fromJson(dynamic json) {
    postId = json["post_id"];
    page = json["page"];
    limit = json["limit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["post_id"] = postId;
    map["page"] = page;
    map["limit"] = limit;
    return map;
  }

}