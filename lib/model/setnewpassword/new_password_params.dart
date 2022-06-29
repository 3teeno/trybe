class New_passsword_params {
  String emailPhone;
  String password;
  String confirmPassword;

  New_passsword_params({
      this.emailPhone, 
      this.password, 
      this.confirmPassword});

  New_passsword_params.fromJson(dynamic json) {
    emailPhone = json["email_phone"];
    password = json["password"];
    confirmPassword = json["confirm_password"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email_phone"] = emailPhone;
    map["password"] = password;
    map["confirm_password"] = confirmPassword;
    return map;
  }

}