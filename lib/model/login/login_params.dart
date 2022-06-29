class LoginParams {
  String key;
  String emailPhone;
  String otp;
  String password;
  String device_token;

  LoginParams({
      this.key, 
      this.emailPhone, 
      this.otp,
      this.device_token,
  this.password});

  LoginParams.fromJson(dynamic json) {
    key = json["key"];
    emailPhone = json["email_phone"];
    otp = json["otp"];
    device_token = json["device_token"];
    password = json["password"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["key"] = key;
    map["email_phone"] = emailPhone;
    map["otp"] = otp;
    map["device_token"] = device_token;
    map["password"] = password;
    return map;
  }

}