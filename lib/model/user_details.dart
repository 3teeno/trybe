class UserDetails {
  List<UserDetail> userDetails;


  UserDetails({
      this.userDetails});

  UserDetails.fromJson(dynamic json) {
    if (json["UserDetails"] != null) {
      userDetails = [];
      json["UserDetails"].forEach((v) {
        userDetails.add(UserDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (userDetails != null) {
      map["UserDetails"] = userDetails.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class UserDetail {
  String email;
  String password;
  String phonenumber;
  String userimage;
  String userid;
  String username;
  String birthdate;
  String about;
  String logintype;

  UserDetail({
      this.email,
      this.userimage,
      this.phonenumber,
      this.userid,
      this.username,this.birthdate,
      this.about,
    this.logintype,
      this.password});

  UserDetail.fromJson(dynamic json) {
    email = json["email"];
    userimage = json["userimage"];
    phonenumber = json["phonenumber"];
    password = json["password"];
    userid = json["userid"];
    birthdate = json["birthday"];
    username = json["username"];
    logintype = json["logintype"];
    about = json["about"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email"] = email;
    map["password"] = password;
    map["phonenumber"] = phonenumber;
    map["userimage"] = userimage;
    map["userid"] = userid;
    map["username"] = username;
    map["birthday"] = birthdate;
    map["logintype"]=logintype;
    map["about"] = about;
    return map;
  }

}