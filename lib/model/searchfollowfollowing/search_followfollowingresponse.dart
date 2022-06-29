class Search_followfollowingresponse {
  String status;
  UserData userData;
  bool loggedin;

  Search_followfollowingresponse({
      this.status, 
      this.userData, 
      this.loggedin});

  Search_followfollowingresponse.fromJson(dynamic json) {
    status = json["status"];
    userData = json["userData"] != null ? UserData.fromJson(json["userData"]) : null;
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (userData != null) {
      map["userData"] = userData.toJson();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}

class UserData {
  int currentPage;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  int to;
  int total;
  List<Users> users;

  UserData({
      this.currentPage, 
      this.firstPageUrl, 
      this.from, 
      this.lastPage, 
      this.lastPageUrl, 
      this.nextPageUrl, 
      this.path, 
      this.perPage, 
      this.prevPageUrl, 
      this.to, 
      this.total, 
      this.users});

  UserData.fromJson(dynamic json) {
    currentPage = json["current_page"];
    firstPageUrl = json["first_page_url"];
    from = json["from"];
    lastPage = json["last_page"];
    lastPageUrl = json["last_page_url"];
    nextPageUrl = json["next_page_url"];
    path = json["path"];
    perPage = json["per_page"];
    prevPageUrl = json["prev_page_url"];
    to = json["to"];
    total = json["total"];
    if (json["users"] != null) {
      users = [];
      json["users"].forEach((v) {
        users.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["current_page"] = currentPage;
    map["first_page_url"] = firstPageUrl;
    map["from"] = from;
    map["last_page"] = lastPage;
    map["last_page_url"] = lastPageUrl;
    map["next_page_url"] = nextPageUrl;
    map["path"] = path;
    map["per_page"] = perPage;
    map["prev_page_url"] = prevPageUrl;
    map["to"] = to;
    map["total"] = total;
    if (users != null) {
      map["users"] = users.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Users {
  int id;
  String fullName;
  String username;
  dynamic email;
  String phoneNumber;
  String password;
  String confirmPassword;
  String birthDate;
  String userImage;
  String coverPhoto;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  dynamic socialId;
  String about;
  String deviceToken;
  dynamic isGroundedAccount;
  dynamic groundAccountCreator;
  int privacyType;
  String offNotificationUserList;
  String status;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  int isFollowed;
  int isFollowing;

  Users({
      this.id, 
      this.fullName, 
      this.username, 
      this.email, 
      this.phoneNumber, 
      this.password, 
      this.confirmPassword, 
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
      this.deletedAt, 
      this.isFollowed, 
      this.isFollowing});

  Users.fromJson(dynamic json) {
    id = json["id"];
    fullName = json["full_name"];
    username = json["username"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    password = json["password"];
    confirmPassword = json["confirm_password"];
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
    isFollowed = json["isFollowed"];
    isFollowing = json["isFollowing"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["full_name"] = fullName;
    map["username"] = username;
    map["email"] = email;
    map["phone_number"] = phoneNumber;
    map["password"] = password;
    map["confirm_password"] = confirmPassword;
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
    map["isFollowed"] = isFollowed;
    map["isFollowing"] = isFollowing;
    return map;
  }

}