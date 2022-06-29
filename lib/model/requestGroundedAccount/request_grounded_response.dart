class RequestGroundedResponse {
  String status;
  String message;

  RequestGroundedResponse({
      this.status, 
      this.message});

  RequestGroundedResponse.fromJson(dynamic json) {
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