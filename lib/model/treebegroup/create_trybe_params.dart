class Create_trybe_params {
  String uid;
  String treeName;

  Create_trybe_params({
      this.uid, 
      this.treeName});

  Create_trybe_params.fromJson(dynamic json) {
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