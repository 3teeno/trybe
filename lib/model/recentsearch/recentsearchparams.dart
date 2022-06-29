class Recentsearchparams {
  String uid;

  Recentsearchparams({
      this.uid});

  Recentsearchparams.fromJson(dynamic json) {
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    return map;
  }

}