class ExecutorListParam {
  String uid;

  ExecutorListParam({
      this.uid});

  ExecutorListParam.fromJson(dynamic json) {
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    return map;
  }

}