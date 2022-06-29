class Createtreeberesponse {
  String status;
  List<TreeData> treeData;
  bool loggedin;

  Createtreeberesponse({
      this.status, 
      this.treeData, 
      this.loggedin});

  Createtreeberesponse.fromJson(dynamic json) {
    status = json["status"];
    if (json["treeData"] != null) {
      treeData = [];
      json["treeData"].forEach((v) {
        treeData.add(TreeData.fromJson(v));
      });
    }
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (treeData != null) {
      map["treeData"] = treeData.map((v) => v.toJson()).toList();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}

class TreeData {
  int id;
  int uid;
  String treeName;
  String status;
  String createdAt;
  dynamic updatedAt;
  UserInfo userInfo;

  TreeData({
      this.id, 
      this.uid, 
      this.treeName, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.userInfo});

  TreeData.fromJson(dynamic json) {
    id = json["id"];
    uid = json["uid"];
    treeName = json["tree_name"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    userInfo = json["userInfo"] != null ? UserInfo.fromJson(json["userInfo"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uid"] = uid;
    map["tree_name"] = treeName;
    map["status"] = status;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    if (userInfo != null) {
      map["userInfo"] = userInfo.toJson();
    }
    return map;
  }

}

class UserInfo {
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

  UserInfo({
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

  UserInfo.fromJson(dynamic json) {
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