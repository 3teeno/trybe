class Savepostcollectionresponse {
  String status;
  String message;
  bool loggedin;

  Savepostcollectionresponse({
      this.status, 
      this.message, 
      this.loggedin});

  Savepostcollectionresponse.fromJson(dynamic json) {
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