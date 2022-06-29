class Rename_tree {
  String uid;
  String id;
  String treeName;

  Rename_tree({
      this.uid, 
      this.id, 
      this.treeName});

  Rename_tree.fromJson(dynamic json) {
    uid = json["uid"];
    id = json["id"];
    treeName = json["tree_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["id"] = id;
    map["tree_name"] = treeName;
    return map;
  }

}