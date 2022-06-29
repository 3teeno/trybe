class Createpostresponse {
  String status;
  String message;

  Createpostresponse({
      this.status, 
      this.message});

  Createpostresponse.fromJson(dynamic json) {
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