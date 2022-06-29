class Deleteuseraccparams {
  String uid;

  Deleteuseraccparams({
      this.uid});

  Deleteuseraccparams.fromJson(dynamic json) {
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    return map;
  }

}