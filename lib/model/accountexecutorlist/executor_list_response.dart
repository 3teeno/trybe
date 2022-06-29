class ExecutorListResponse {
  String status;
  List<UserData> userData;

  ExecutorListResponse({
      this.status, 
      this.userData});

  ExecutorListResponse.fromJson(dynamic json) {
    status = json["status"];
    if (json["userData"] != null) {
      userData = [];
      json["userData"].forEach((v) {
        userData.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (userData != null) {
      map["userData"] = userData.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class UserData {
  int id;
  String username;
  String userImage;

  UserData({
      this.id, 
      this.username, 
      this.userImage});

  UserData.fromJson(dynamic json) {
    id = json["id"];
    username = json["username"];
    userImage = json["user_image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["username"] = username;
    map["user_image"] = userImage;
    return map;
  }

}