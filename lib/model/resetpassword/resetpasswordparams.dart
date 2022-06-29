class Resetpasswordparams {
  String uid;
  String currentPassword;
  String newPassword;
  String confirmPassword;

  Resetpasswordparams({
      this.uid, 
      this.currentPassword, 
      this.newPassword, 
      this.confirmPassword});

  Resetpasswordparams.fromJson(dynamic json) {
    uid = json["uid"];
    currentPassword = json["current_password"];
    newPassword = json["new_password"];
    confirmPassword = json["confirm_password"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["current_password"] = currentPassword;
    map["new_password"] = newPassword;
    map["confirm_password"] = confirmPassword;
    return map;
  }

}