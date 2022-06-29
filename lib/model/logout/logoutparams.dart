class Logoutparams {
  String uid;

  Logoutparams({
      this.uid});

  Logoutparams.fromJson(dynamic json) {
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    return map;
  }

}