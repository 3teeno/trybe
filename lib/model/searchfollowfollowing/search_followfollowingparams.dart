class Search_followfollowing {
  String uid;
  String searchValue;
  String page;
  String limit;

  Search_followfollowing({
      this.uid, 
      this.searchValue, 
      this.page, 
      this.limit});

  Search_followfollowing.fromJson(dynamic json) {
    uid = json["uid"];
    searchValue = json["search_value"];
    page = json["page"];
    limit = json["limit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["search_value"] = searchValue;
    map["page"] = page;
    map["limit"] = limit;
    return map;
  }

}