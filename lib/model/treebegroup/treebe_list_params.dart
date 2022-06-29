class Treebe_list_params {
  String uid;

  Treebe_list_params({
      this.uid});

  Treebe_list_params.fromJson(dynamic json) {
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    return map;
  }

}