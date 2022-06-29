class Send_otp_response {
  String status;
  String message;
  int otp;

  Send_otp_response({
      this.status, 
      this.message,
    this.otp});

  Send_otp_response.fromJson(dynamic json) {
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