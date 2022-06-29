class Getrecentuserlistresponse {
  String status;
  PostData postData;
  UserDatas userData;
  bool loggedin;

  Getrecentuserlistresponse({
    this.status,
    this.postData,
    this.userData,
    this.loggedin});

  Getrecentuserlistresponse.fromJson(dynamic json) {
    status = json["status"];
    postData = json["postData"] != null ? PostData.fromJson(json["postData"]) : null;
    userData = json["userData"] != null ? UserDatas.fromJson(json["userData"]) : null;
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
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

class UserDatas {
  int id;
  String fullName;
  String username;
  String email;
  dynamic phoneNumber;
  dynamic birthDate;
  String userImage;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  String socialId;
  String status;
  String createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  UserDatas({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.phoneNumber,
    this.birthDate,
    this.userImage,
    this.userStory,
    this.storyCreationDate,
    this.loginType,
    this.socialId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt});

  UserDatas.fromJson(dynamic json) {
    id = json["id"];
    fullName = json["full_name"];
    username = json["username"];
    email = json["email"];
    phoneNumber = json["phone_number"];
    birthDate = json["birth_date"];
    userImage = json["user_image"];
    userStory = json["user_story"];
    storyCreationDate = json["story_creation_date"];
    loginType = json["login_type"];
    socialId = json["social_id"];
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
    map["user_story"] = userStory;
    map["story_creation_date"] = storyCreationDate;
    map["login_type"] = loginType;
    map["social_id"] = socialId;
    map["status"] = status;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
    return map;
  }

}

class PostData {
  PostUserData userData;

  PostData({
    this.userData});

  PostData.fromJson(dynamic json) {
    userData = json["userData"] != null ? PostUserData.fromJson(json["userData"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (userData != null) {
      map["userData"] = userData.toJson();
    }
    return map;
  }

}

class PostUserData {
  int currentPage;
  List<DataUsers> data;
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

  PostUserData({
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

  PostUserData.fromJson(dynamic json) {
    currentPage = json["current_page"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(DataUsers.fromJson(v));
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

class DataUsers {
  int id;
  String fullName;
  String device_token;
  String username;
  dynamic email;
  String phoneNumber;
  String about;
  String password;
  String confirmPassword;
  String birthDate;
  String userImage;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  dynamic socialId;
  String status;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  bool isuserselected;

  setselecteduser(bool isuserselected){
    this.isuserselected = isuserselected;
  }

  DataUsers({
    this.id,
    this.fullName,
    this.device_token,
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
    this.createdAt,
    this.updatedAt,
    this.isuserselected,
    this.deletedAt});

  DataUsers.fromJson(dynamic json) {
    id = json["id"];
    fullName = json["full_name"];
    device_token = json["device_token"];
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
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    isuserselected = json["isuserselected"];
    deletedAt = json["deleted_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["full_name"] = fullName;
    map["device_token"] = device_token;
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
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["isuserselected"] = isuserselected;
    map["deleted_at"] = deletedAt;
    return map;
  }

}