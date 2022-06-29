class Create_treebe_group {
  String uid;
  String treeName;

  Create_treebe_group({
      this.uid, 
      this.treeName});

  Create_treebe_group.fromJson(dynamic json) {
    uid = json["uid"];
    treeName = json["tree_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["tree_name"] = treeName;
    return map;
  }

}