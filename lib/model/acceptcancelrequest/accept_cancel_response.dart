class AcceptCancelResponse {
  String status;
  String message;

  AcceptCancelResponse({this.status, this.message});

  AcceptCancelResponse.fromJson(dynamic json) {
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
