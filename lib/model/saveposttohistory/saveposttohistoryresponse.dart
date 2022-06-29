class Saveposttohistoryresponse {
  String status;
  String message;
  UserData userData;
  bool loggedin;

  Saveposttohistoryresponse({
      this.status, 
      this.message, 
      this.userData, 
      this.loggedin});

  Saveposttohistoryresponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    userData = json["userData"] != null ? UserData.fromJson(json["userData"]) : null;
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (userData != null) {
      map["userData"] = userData.toJson();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}

class UserData {
  int id;
  String fullName;
  String username;
  dynamic email;
  String phoneNumber;
  String birthDate;
  String userImage;
  String coverPhoto;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  dynamic socialId;
  dynamic about;
  String deviceToken;
  dynamic isGroundedAccount;
  dynamic groundAccountCreator;
  int privacyType;
  String offNotificationUserList;
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
      this.birthDate, 
      this.userImage, 
      this.coverPhoto, 
      this.userStory, 
      this.storyCreationDate, 
      this.loginType, 
      this.socialId, 
      this.about, 
      this.deviceToken, 
      this.isGroundedAccount, 
      this.groundAccountCreator, 
      this.privacyType, 
      this.offNotificationUserList, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt});

  UserData.fromJson(dynamic json) {
    id = json["id"];
    fullName = json["full_name"];
    username = json["username"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    birthDate = json["birth_date"];
    userImage = json["user_image"];
    coverPhoto = json["cover_photo"];
    userStory = json["user_story"];
    storyCreationDate = json["story_creation_date"];
    loginType = json["login_type"];
    socialId = json["social_id"];
    about = json["about"];
    deviceToken = json["device_token"];
    isGroundedAccount = json["is_grounded_account"];
    groundAccountCreator = json["ground_account_creator"];
    privacyType = json["privacy_type"];
    offNotificationUserList = json["Off_notification_user_list"];
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
    map["birth_date"] = birthDate;
    map["user_image"] = userImage;
    map["cover_photo"] = coverPhoto;
    map["user_story"] = userStory;
    map["story_creation_date"] = storyCreationDate;
    map["login_type"] = loginType;
    map["social_id"] = socialId;
    map["about"] = about;
    map["device_token"] = deviceToken;
    map["is_grounded_account"] = isGroundedAccount;
    map["ground_account_creator"] = groundAccountCreator;
    map["privacy_type"] = privacyType;
    map["Off_notification_user_list"] = offNotificationUserList;
    map["status"] = status;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
    return map;
  }

}