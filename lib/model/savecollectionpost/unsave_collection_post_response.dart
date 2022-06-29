class Unsave_collection_post_response {
  String status;
  String message;
  bool loggedin;

  Unsave_collection_post_response({
      this.status, 
      this.message, 
      this.loggedin});

  Unsave_collection_post_response.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    map["loggedin"] = loggedin;
    return map;
  }

}