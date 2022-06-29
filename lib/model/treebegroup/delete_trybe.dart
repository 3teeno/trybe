class Delete_trybe {
  String uid;
  String id;

  Delete_trybe({
      this.uid, 
      this.id});

  Delete_trybe.fromJson(dynamic json) {
    uid = json["uid"];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["id"] = id;
    return map;
  }

}