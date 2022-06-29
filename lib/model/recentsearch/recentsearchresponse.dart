class Recentsearchresponse {
  String status;
  List<SearchData> searchData;
  bool loggedin;

  Recentsearchresponse({
      this.status, 
      this.searchData, 
      this.loggedin});

  Recentsearchresponse.fromJson(dynamic json) {
    status = json["status"];
    if (json["searchData"] != null) {
      searchData = [];
      json["searchData"].forEach((v) {
        searchData.add(SearchData.fromJson(v));
      });
    }
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (searchData != null) {
      map["searchData"] = searchData.map((v) => v.toJson()).toList();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}

class SearchData {
  int id;
  int uid;
  String recentSearch;
  String createdAt;
  dynamic updatedAt;

  SearchData({
      this.id, 
      this.uid, 
      this.recentSearch, 
      this.createdAt, 
      this.updatedAt});

  SearchData.fromJson(dynamic json) {
    id = json["id"];
    uid = json["uid"];
    recentSearch = json["recent_search"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uid"] = uid;
    map["recent_search"] = recentSearch;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}