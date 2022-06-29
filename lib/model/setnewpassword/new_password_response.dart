class New_password_response {
  String status;
  String message;

  New_password_response({
      this.status, 
      this.message});

  New_password_response.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    return map;
  }

}