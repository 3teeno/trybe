class Showhistorylistresponse {
  String status;
  String message;
  PostData postData;
  UserData userData;
  bool loggedin;

  Showhistorylistresponse({
      this.status, 
      this.message, 
      this.postData, 
      this.userData, 
      this.loggedin});

  Showhistorylistresponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    postData = json["postData"] != null ? PostData.fromJson(json["postData"]) : null;
    userData = json["userData"] != null ? UserData.fromJson(json["userData"]) : null;
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (postData != null) {
      map["postData"] = postData.toJson();
    }
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
  dynamic deviceToken;
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

class PostData {
  int currentPage;
  List<Data> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  PostData({
      this.currentPage, 
      this.data, 
      this.firstPageUrl, 
      this.from, 
      this.lastPage, 
      this.lastPageUrl, 
      this.nextPageUrl, 
      this.path, 
      this.perPage, 
      this.prevPageUrl, 
      this.to, 
      this.total});

  PostData.fromJson(dynamic json) {
    currentPage = json["current_page"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
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
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["current_page"] = currentPage;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
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
    return map;
  }

}

class Data {
  int id;
  int uid;
  int postType;
  String postMediaUrl;
  String postCaption;
  int privacyType;
  int isforkid;
  String status;
  String createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  UserInfo userInfo;
  int collectionId;
  int views;
  int likes;
  int comment;
  bool isliked;
  bool isSaved;
  bool isPlaylistSaved;

  Data({
      this.id, 
      this.uid, 
      this.postType, 
      this.postMediaUrl, 
      this.postCaption, 
      this.privacyType, 
      this.isforkid, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt, 
      this.userInfo, 
      this.collectionId, 
      this.views, 
      this.likes, 
      this.comment, 
      this.isliked, 
      this.isSaved, 
      this.isPlaylistSaved});

  Data.fromJson(dynamic json) {
    id = json["id"];
    uid = json["uid"];
    postType = json["post_type"];
    postMediaUrl = json["post_media_url"];
    postCaption = json["post_caption"];
    privacyType = json["privacy_type"];
    isforkid = json["isforkid"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
    userInfo = json["userInfo"] != null ? UserInfo.fromJson(json["userInfo"]) : null;
    collectionId = json["collectionId"];
    views = json["views"];
    likes = json["likes"];
    comment = json["comment"];
    isliked = json["isliked"];
    isSaved = json["isSaved"];
    isPlaylistSaved = json["isPlaylistSaved"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uid"] = uid;
    map["post_type"] = postType;
    map["post_media_url"] = postMediaUrl;
    map["post_caption"] = postCaption;
    map["privacy_type"] = privacyType;
    map["isforkid"] = isforkid;
    map["status"] = status;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
    if (userInfo != null) {
      map["userInfo"] = userInfo.toJson();
    }
    map["collectionId"] = collectionId;
    map["views"] = views;
    map["likes"] = likes;
    map["comment"] = comment;
    map["isliked"] = isliked;
    map["isSaved"] = isSaved;
    map["isPlaylistSaved"] = isPlaylistSaved;
    return map;
  }

}

class UserInfo {
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
  dynamic deviceToken;
  dynamic isGroundedAccount;
  dynamic groundAccountCreator;
  int privacyType;
  String offNotificationUserList;
  String status;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  UserInfo({
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

  UserInfo.fromJson(dynamic json) {
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