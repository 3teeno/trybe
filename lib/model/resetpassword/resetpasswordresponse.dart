class Resetpasswordresponse {
  String status;
  String message;
  bool loggedin;

  Resetpasswordresponse({
      this.status, 
      this.message, 
      this.loggedin});

  Resetpasswordresponse.fromJson(dynamic json) {
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