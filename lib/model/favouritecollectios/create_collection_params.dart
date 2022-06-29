class Create_collection_params {
  String userid;
  String collectionName;

  Create_collection_params({
      this.userid, 
      this.collectionName});

  Create_collection_params.fromJson(dynamic json) {
    userid = json["userid"];
    collectionName = json["collection_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userid"] = userid;
    map["collection_name"] = collectionName;
    return map;
  }

}