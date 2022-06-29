class Send_otp_params {
  String emailPhone;
  String key;

  Send_otp_params({
      this.emailPhone,
  this.key});

  Send_otp_params.fromJson(dynamic json) {
    emailPhone = json["email_phone"];
    key=json["key"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email_phone"] = emailPhone;
    map["key"]=key;
    return map;
  }

}