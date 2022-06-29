class Get_post_collection_params {
  String page;
  String limit;
  String collectionId;
  String sort_by;
  String uid;

  Get_post_collection_params({
      this.page, 
      this.limit, 
      this.uid,
    this.sort_by,
      this.collectionId});

  Get_post_collection_params.fromJson(dynamic json) {
    page = json["page"];
    limit = json["limit"];
    sort_by = json["sort_by"];
    collectionId = json["collection_id"];
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["page"] = page;
    map["limit"] = limit;
    map["sort_by"]=sort_by;
    map["collection_id"] = collectionId;
    map["uid"] = uid;
    return map;
  }

}