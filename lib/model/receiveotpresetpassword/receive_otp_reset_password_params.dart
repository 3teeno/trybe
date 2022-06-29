class Receiveotpresetpasswordparams {
  String emailPhone;
  String otp;
  String key;

  Receiveotpresetpasswordparams({
      this.emailPhone,
    this.key,
      this.otp});

  Receiveotpresetpasswordparams.fromJson(dynamic json) {
    emailPhone = json["email_phone"];
    key=json["key"];
    otp = json["otp"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email_phone"] = emailPhone;
    map["key"]=key;
    map["otp"] = otp;
    return map;
  }

}