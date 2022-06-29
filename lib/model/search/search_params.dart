class Search_params {
  String searchValue;
  String page;
  String uid;
  String limit;

  Search_params({
      this.searchValue, 
      this.page, 
      this.uid,
      this.limit});

  Search_params.fromJson(dynamic json) {
    searchValue = json["search_value"];
    page = json["page"];
    uid = json["uid"];
    limit = json["limit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["search_value"] = searchValue;
    map["page"] = page;
    map["uid"] = uid;
    map["limit"] = limit;
    return map;
  }

}