class GroundedAccountlistResponse {
  String status;
  AccountsData accountsData;
  String message;
  bool loggedin;

  GroundedAccountlistResponse({
      this.status, 
      this.accountsData, 
      this.message, 
      this.loggedin});

  GroundedAccountlistResponse.fromJson(dynamic json) {
    status = json["status"];
    accountsData = json["accountsData"] != null ? AccountsData.fromJson(json["accountsData"]) : null;
    message = json["message"];
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (accountsData != null) {
      map["accountsData"] = accountsData.toJson();
    }
    map["message"] = message;
    map["loggedin"] = loggedin;
    return map;
  }

}

class AccountsData {
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

  AccountsData({
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

  AccountsData.fromJson(dynamic json) {
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
  dynamic fullName;
  String username;
  dynamic email;
  dynamic phoneNumber;
  dynamic password;
  dynamic confirmPassword;
  dynamic birthDate;
  String userImage;
  dynamic coverPhoto;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  dynamic socialId;
  dynamic about;
  String deviceToken;
  int isGroundedAccount;
  int groundAccountCreator;
  String status;
  int privacy_type;
  String createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  Data({
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
    this.privacy_type,
    this.storyCreationDate,
      this.loginType, 
      this.socialId, 
      this.about, 
      this.deviceToken, 
      this.isGroundedAccount, 
      this.groundAccountCreator, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt});

  Data.fromJson(dynamic json) {
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
    privacy_type=json["privacy_type"];
    storyCreationDate = json["story_creation_date"];
    loginType = json["login_type"];
    socialId = json["social_id"];
    about = json["about"];
    deviceToken = json["device_token"];
    isGroundedAccount = json["is_grounded_account"];
    groundAccountCreator = json["ground_account_creator"];
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
    map["password"] = password;
    map["confirm_password"] = confirmPassword;
    map["birth_date"] = birthDate;
    map["user_image"] = userImage;
    map["cover_photo"] = coverPhoto;
    map["user_story"] = userStory;
    map["privacy_type"]=privacy_type;
    map["story_creation_date"] = storyCreationDate;
    map["login_type"] = loginType;
    map["social_id"] = socialId;
    map["about"] = about;
    map["device_token"] = deviceToken;
    map["is_grounded_account"] = isGroundedAccount;
    map["ground_account_creator"] = groundAccountCreator;
    map["status"] = status;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
    return map;
  }

}