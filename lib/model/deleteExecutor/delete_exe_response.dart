class DeleteExeResponse {
  String status;
  String message;

  DeleteExeResponse({
      this.status, 
      this.message});

  DeleteExeResponse.fromJson(dynamic json) {
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