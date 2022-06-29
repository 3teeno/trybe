class Get_trybe_members_params {
  String treeId;

  Get_trybe_members_params({
      this.treeId});

  Get_trybe_members_params.fromJson(dynamic json) {
    treeId = json["tree_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tree_id"] = treeId;
    return map;
  }

}