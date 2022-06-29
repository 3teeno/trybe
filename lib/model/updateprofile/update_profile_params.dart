class Update_profile_params {
  String userid;
  String key;
  String fullName;
  String username;
  String birthDate;
  String email;
  String phoneNumber;
  String password;
  String confirmPassword;
  String filename;
  String privacy_type;
  String about;

  Update_profile_params({
      this.userid, 
      this.key,
      this.fullName,
      this.username, 
      this.birthDate, 
      this.email, 
      this.phoneNumber, 
      this.password, 
      this.confirmPassword,
    this.privacy_type,
      this.about,
      this.filename});

  Update_profile_params.fromJson(dynamic json) {
    userid = json["userid"];
    key = json["key"];
    fullName = json["full_name"];
    username = json["username"];
    birthDate = json["birth_date"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    password = json["password"];
    privacy_type = json["privacy_type"];
    confirmPassword = json["confirm_password"];
    filename = json["filename"];
    about = json["about"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userid"] = userid;
    map["key"] = key;
    map["full_name"] = fullName;
    map["username"] = username;
    map["birth_date"] = birthDate;
    map["email"] = email;
    map["phone_number"] = phoneNumber;
    map["password"] = password;
    map["privacy_type"] = privacy_type;
    map["confirm_password"] = confirmPassword;
    map["filename"] = filename;
    map["about"] = about;
    return map;
  }

}