class DeleteuseraccResponse {
  String status;
  String message;

  DeleteuseraccResponse({
      this.status, 
      this.message});

  DeleteuseraccResponse.fromJson(dynamic json) {
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