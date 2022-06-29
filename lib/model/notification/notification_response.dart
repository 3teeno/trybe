class Notification_response {
  String status;
  PostData postData;
  List<FollowRequests> followRequests;
  List<executorRequests> executorRequest;
  List<transferGroundedRequests> transferGroundedRequest;

  bool loggedin;

  Notification_response(
      {this.status,
      this.postData,
      this.followRequests,
      this.executorRequest,
        this.transferGroundedRequest,
      this.loggedin});

  Notification_response.fromJson(dynamic json) {
    status = json["status"];
    postData =
        json["postData"] != null ? PostData.fromJson(json["postData"]) : null;
    if (json["followRequests"] != null) {
      followRequests = [];
      json["followRequests"].forEach((v) {
        followRequests.add(FollowRequests.fromJson(v));
      });
    }
    if (json["executorRequests"] != null) {
      executorRequest = [];
      json["executorRequests"].forEach((v) {
        executorRequest.add(executorRequests.fromJson(v));
      });
    }

    if (json["transferGroundedRequests"] != null) {
      transferGroundedRequest = [];
      json["transferGroundedRequests"].forEach((v) {
        transferGroundedRequest.add(transferGroundedRequests.fromJson(v));
      });
    }

    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (postData != null) {
      map["postData"] = postData.toJson();
    }
    if (followRequests != null) {
      map["followRequests"] = followRequests.map((v) => v.toJson()).toList();
    }
    map["loggedin"] = loggedin;
    return map;
  }
}


class transferGroundedRequests {
  dynamic id;
  dynamic uid;
  dynamic groundedId;
  dynamic requestedUid;
  dynamic accept;
  UserInfo userInfo;
  String message;

  transferGroundedRequests(
      {this.id,
        this.uid,
        this.groundedId,
        this.requestedUid,
        this.accept,
        this.userInfo,
        this.message});

  transferGroundedRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    groundedId = json['grounded_id'];
    requestedUid = json['requested_uid'];
    accept = json['accept'];
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['grounded_id'] = this.groundedId;
    data['requested_uid'] = this.requestedUid;
    data['accept'] = this.accept;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class executorRequests {
  dynamic id;
  dynamic uid;
  dynamic requestedUid;
  dynamic accept;
  UserInfo userInfo;
  String message;

  executorRequests(
      {this.id,
      this.uid,
      this.requestedUid,
      this.accept,
      this.userInfo,
      this.message});

  executorRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    requestedUid = json['requested_uid'];
    accept = json['accept'];
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['requested_uid'] = this.requestedUid;
    data['accept'] = this.accept;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class FollowRequests {
  int id;
  int followRequestBy;
  int followRequestTo;
  String createdAt;
  String updatedAt;
  UserInfos userInfo;
  String message;

  FollowRequests(
      {this.id,
      this.followRequestBy,
      this.followRequestTo,
      this.createdAt,
      this.updatedAt,
      this.userInfo,
      this.message});

  FollowRequests.fromJson(dynamic json) {
    id = json["id"];
    followRequestBy = json["follow_request_by"];
    followRequestTo = json["follow_request_to"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    userInfo =
        json["userInfo"] != null ? UserInfos.fromJson(json["userInfo"]) : null;
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["follow_request_by"] = followRequestBy;
    map["follow_request_to"] = followRequestTo;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    if (userInfo != null) {
      map["userInfo"] = userInfo.toJson();
    }
    map["message"] = message;
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
  String coverPhoto;
  dynamic userStory;
  dynamic storyCreationDate;
  int loginType;
  String socialId;
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

  UserInfo(
      {this.id,
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

class PostData {
  int currentPage;
  List<Data> data;
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

  PostData(
      {this.currentPage,
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
  UserInfo userInfo;
  String message;

  Data({this.userInfo, this.message});

  Data.fromJson(dynamic json) {
    userInfo =
        json["userInfo"] != null ? UserInfo.fromJson(json["userInfo"]) : null;
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (userInfo != null) {
      map["userInfo"] = userInfo.toJson();
    }
    map["message"] = message;
    return map;
  }
}

class UserInfos {
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

  UserInfos(
      {this.id,
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

  UserInfos.fromJson(dynamic json) {
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
