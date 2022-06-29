class Trybe_add_members_response {
  String status;
  int node_id;
  String message;

  bool loggedin;

  Trybe_add_members_response({
      this.status,
    this.node_id,
      this.message,
      this.loggedin,

  });

  Trybe_add_members_response.fromJson(dynamic json) {
    status = json["status"];
    node_id = json["node_id"];
    message = json["message"];
    loggedin = json["loggedin"];

  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["node_id"] = node_id;
    map["message"] = message;
    map["loggedin"] = loggedin;

    return map;
  }

}