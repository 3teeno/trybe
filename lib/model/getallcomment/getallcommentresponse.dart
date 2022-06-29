class Getallcommentresponse {
  String status;
  PostData postData;
  bool loggedin;

  Getallcommentresponse({
      this.status, 
      this.postData, 
      this.loggedin});

  Getallcommentresponse.fromJson(dynamic json) {
    status = json["status"];
    postData = json["postData"] != null ? PostData.fromJson(json["postData"]) : null;
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (postData != null) {
      map["postData"] = postData.toJson();
    }
    map["loggedin"] = loggedin;
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
  int postId;
  int like;
  dynamic dislike;
  dynamic favorite;
  dynamic view;
  String commentContent;
  String createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  UserInfo userInfo;

  Data({
      this.id, 
      this.uid, 
      this.postId, 
      this.like, 
      this.dislike, 
      this.favorite, 
      this.view, 
      this.commentContent, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt, 
      this.userInfo});

  Data.fromJson(dynamic json) {
    id = json["id"];
    uid = json["uid"];
    postId = json["post_id"];
    like = json["like"];
    dislike = json["dislike"];
    favorite = json["favorite"];
    view = json["view"];
    commentContent = json["comment_content"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
    userInfo = json["userInfo"] != null ? UserInfo.fromJson(json["userInfo"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uid"] = uid;
    map["post_id"] = postId;
    map["like"] = like;
    map["dislike"] = dislike;
    map["favorite"] = favorite;
    map["view"] = view;
    map["comment_content"] = commentContent;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
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