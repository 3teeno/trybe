class UpdateProfileResponse {
  String status;
  UserData userData;
  String message;

  UpdateProfileResponse({
      this.status, 
      this.userData, 
      this.message});

  UpdateProfileResponse.fromJson(dynamic json) {
    status = json["status"];
    userData = json["userData"] != null ? UserData.fromJson(json["userData"]) : null;
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (userData != null) {
      map["userData"] = userData.toJson();
    }
    map["message"] = message;
    return map;
  }

}

class UserData {
  int id;
  String fullName;
  String username;
  String email;
  dynamic phoneNumber;
  String password;
  String about;
  String confirmPassword;
  String birthDate;
  String userImage;
  String cover_photo;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  dynamic socialId;
  String status;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  UserData({
      this.id, 
      this.fullName, 
      this.username, 
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
      this.cover_photo,
      this.createdAt,
      this.updatedAt, 
      this.deletedAt});

  UserData.fromJson(dynamic json) {
    id = json["id"];
    fullName = json["full_name"];
    username = json["username"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    about = json["about"];
    password = json["password"];
    confirmPassword = json["confirm_password"];
    birthDate = json["birth_date"];
    userImage = json["user_image"];
    userStory = json["user_story"];
    storyCreationDate = json["story_creation_date"];
    loginType = json["login_type"];
    socialId = json["social_id"];
    cover_photo = json["cover_photo"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["full_name"] = fullName;
    map["username"] = username;
    map["email"] = email;
    map["phone_number"] = phoneNumber;
    map["about"] = about;
    map["password"] = password;
    map["confirm_password"] = confirmPassword;
    map["birth_date"] = birthDate;
    map["user_image"] = userImage;
    map["user_story"] = userStory;
    map["story_creation_date"] = storyCreationDate;
    map["login_type"] = loginType;
    map["social_id"] = socialId;
    map["status"] = status;
    map["cover_photo"] = cover_photo;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
    return map;
  }

}