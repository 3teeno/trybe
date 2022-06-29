class Getallvideosparams {
  String uid;
  String postType;
  String page;
  String other_uid;
  String limit;
  String sort_by;

  Getallvideosparams({
      this.uid, 
      this.postType, 
      this.page,
    this.sort_by,
    this.other_uid,
      this.limit});

  Getallvideosparams.fromJson(dynamic json) {
    uid = json["uid"];
    postType = json["post_type"];
    page = json["page"];
    sort_by = json["sort_by"];
    other_uid = json["other_uid"];
    limit = json["limit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["post_type"] = postType;
    map["page"] = page;
    map["other_uid"]=other_uid;
    map["sort_by"]=sort_by;
    map["limit"] = limit;
    return map;
  }

}