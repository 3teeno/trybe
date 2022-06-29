class RegistrationParams {
  String emailPhone;
  String device_token;

  RegistrationParams({
      this.emailPhone,this.device_token});

  RegistrationParams.fromJson(dynamic json) {
    emailPhone = json["email_phone"];
    device_token = json["device_token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email_phone"] = emailPhone;
    map["device_token"] = device_token;
    return map;
  }

}