class Collection_list_params {
  String userid;

  Collection_list_params({
      this.userid});

  Collection_list_params.fromJson(dynamic json) {
    userid = json["userid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userid"] = userid;
    return map;
  }

}