class Full_detail_post_response {
  String status;
  FullPostData postData;
  UserData userData;
  bool loggedin;

  Full_detail_post_response({
      this.status, 
      this.postData, 
      this.userData, 
      this.loggedin});

  Full_detail_post_response.fromJson(dynamic json) {
    status = json["status"];
    postData = json["postData"] != null ? FullPostData.fromJson(json["postData"]) : null;
    userData = json["userData"] != null ? UserData.fromJson(json["userData"]) : null;
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

class UserData {
  int id;
  String fullName;
  String username;
  String email;
  String phoneNumber;
  String birthDate;
  String userImage;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  String socialId;
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
      this.userStory, 
      this.storyCreationDate, 
      this.loginType, 
      this.socialId, 
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

class FullPostData {
  int id;
  int uid;
  int postType;
  String postMediaUrl;
  String postCaption;
  dynamic privacyType;
  int isforkid;
  String status;
  String createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  UserInfo userInfo;
  int collectionId;
  int playlistId;
  int likes;
  int comment;
  bool isliked;
  int isFollowed;
  bool isSaved;
  bool isPlaylistSaved;
  String viewBy;
  bool isSelected=false;
  setMenuData(bool isSelected){
    this.isSelected=isSelected;
  }
  FullPostData({
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
    this.playlistId,
    this.likes,
    this.comment,
    this.isliked,
    this.isFollowed,
    this.isSaved,
    this.isPlaylistSaved,
    this.viewBy,
    this.isSelected,
  });

  FullPostData.fromJson(dynamic json) {
    id = json['id'];
    uid = json['uid'];
    postType = json['post_type'];
    postMediaUrl = json['post_media_url'];
    postCaption = json['post_caption'];
    privacyType = json['privacy_type'];
    isforkid = json['isforkid'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    userInfo = json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
    collectionId = json['collectionId'];
    playlistId = json['playlistId'];
    likes = json['likes'];
    comment = json['comment'];
    isliked = json['isliked'];
    isFollowed = json['isFollowed'];
    isSaved = json['isSaved'];
    isPlaylistSaved = json['isPlaylistSaved'];
    viewBy = json['view_by'];
    isSelected = json["isSelected"];

  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['uid'] = uid;
    map['post_type'] = postType;
    map['post_media_url'] = postMediaUrl;
    map['post_caption'] = postCaption;
    map['privacy_type'] = privacyType;
    map['isforkid'] = isforkid;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    if (userInfo != null) {
      map['userInfo'] = userInfo.toJson();
    }
    map['collectionId'] = collectionId;
    map['playlistId'] = playlistId;
    map['likes'] = likes;
    map['comment'] = comment;
    map['isliked'] = isliked;
    map['isFollowed'] = isFollowed;
    map['isSaved'] = isSaved;
    map['isPlaylistSaved'] = isPlaylistSaved;
    map['view_by'] = viewBy;
    map['isSelected'] = isSelected;
    return map;
  }

}

class UserInfo {
  int id;
  String fullName;
  String username;
  String email;
  String phoneNumber;
  String birthDate;
  String userImage;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  String socialId;
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