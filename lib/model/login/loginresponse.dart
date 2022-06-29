

class Loginresponse {
  String status;
  UserDatas userData;
  bool Isdeleted;
  CheckPrivateData checkPrivateData;
  String message;
  bool loggedin;

  Loginresponse({
      this.status, 
      this.userData,
      this.Isdeleted,
    this.checkPrivateData,
    this.loggedin,
    this.message});

  Loginresponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    Isdeleted = json["Isdeleted"];
    checkPrivateData = json["checkPrivateData"] != null ? CheckPrivateData.fromJson(json["checkPrivateData"]) : null;
    loggedin = json["loggedin"];
    userData = json["userData"] != null ? UserDatas.fromJson(json["userData"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    map["Isdeleted"] = Isdeleted;
    if (checkPrivateData != null) {
      map["checkPrivateData"] = checkPrivateData.toJson();
    }
    map["loggedin"] = loggedin;
    if (userData != null) {
      map["userData"] = userData.toJson();
    }
    return map;
  }

}

class UserDatas {
  int id;
  dynamic fullName;
  dynamic username;
  String email;
  String device_token;
  dynamic phoneNumber;
  dynamic password;
  dynamic about;
  dynamic confirmPassword;
  dynamic birthDate;
  dynamic userImage;
  dynamic cover_photo;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  int payment;
  dynamic socialId;
  String status;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  UserDatas({
      this.id, 
      this.fullName, 
      this.username, 
      this.device_token,
      this.email,
      this.phoneNumber, 
      this.about,
      this.password,
      this.confirmPassword,
      this.birthDate, 
      this.userImage, 
      this.userStory, 
      this.storyCreationDate, 
      this.loginType, 
      this.socialId, 
      this.status, 
      this.createdAt, 
      this.cover_photo,
      this.updatedAt,
      this.payment,
      this.deletedAt});

  UserDatas.fromJson(dynamic json) {
    id = json["id"];
    fullName = json["full_name"];
    username = json["username"];
    device_token = json["device_token"];
    about = json["about"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    password = json["password"];
    confirmPassword = json["confirm_password"];
    birthDate = json["birth_date"];
    userImage = json["user_image"];
    userStory = json["user_story"];
    cover_photo = json["cover_photo"];
    storyCreationDate = json["story_creation_date"];
    loginType = json["login_type"];
    socialId = json["social_id"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
    payment = json["payment"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["full_name"] = fullName;
    map["username"] = username;
    map["about"] = about;
    map["email"] = email;
    map["device_token"] = device_token;
    map["phone_number"] = phoneNumber;
    map["password"] = password;
    map["confirm_password"] = confirmPassword;
    map["birth_date"] = birthDate;
    map["user_image"] = userImage;
    map["user_story"] = userStory;
    map["story_creation_date"] = storyCreationDate;
    map["login_type"] = loginType;
    map["social_id"] = socialId;
    map["status"] = status;
    map["created_at"] = createdAt;
    map["cover_photo"] = cover_photo;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
    return map;
  }

}
class CheckPrivateData {
  int id;
  int uid;
  String isPlaylistPrivate;
  String isTreePrivate;
  String isGroupPrivate;
  String createdAt;
  String updatedAt;

  CheckPrivateData({
    this.id,
    this.uid,
    this.isPlaylistPrivate,
    this.isTreePrivate,
    this.isGroupPrivate,
    this.createdAt,
    this.updatedAt});

  CheckPrivateData.fromJson(dynamic json) {
    id = json["id"];
    uid = json["uid"];
    isPlaylistPrivate = json["isPlaylistPrivate"];
    isTreePrivate = json["isTreePrivate"];
    isGroupPrivate = json["isGroupPrivate"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uid"] = uid;
    map["isPlaylistPrivate"] = isPlaylistPrivate;
    map["isTreePrivate"] = isTreePrivate;
    map["isGroupPrivate"] = isGroupPrivate;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}