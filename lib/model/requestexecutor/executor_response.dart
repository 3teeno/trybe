class ExecutorResponse {
  String status;
  String message;

  ExecutorResponse({
      this.status, 
      this.message});

  ExecutorResponse.fromJson(dynamic json) {
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