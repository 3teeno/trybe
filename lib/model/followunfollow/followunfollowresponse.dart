class Followunfollowresponse {
  String status;
  String message;

  Followunfollowresponse({
      this.status, 
      this.message});

  Followunfollowresponse.fromJson(dynamic json) {
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