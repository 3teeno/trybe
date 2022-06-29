class RegistrationResponse {
  String status;
  String message;
  int otp;

  RegistrationResponse({this.status, this.message, this.otp});

  RegistrationResponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    otp = json["otp"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    map["otp"] = otp;
    return map;
  }
}
