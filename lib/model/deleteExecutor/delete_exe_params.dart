class DeleteExeParams {
  String uid;
  int executorId;

  DeleteExeParams({
      this.uid, 
      this.executorId});

  DeleteExeParams.fromJson(dynamic json) {
    uid = json["uid"];
    executorId = json["executor_Id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["executor_Id"] = executorId;
    return map;
  }

}