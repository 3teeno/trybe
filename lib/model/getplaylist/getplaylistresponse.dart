class Getplaylistresponse {
  String status;
  List<PlaylistData> playlistData;
  bool loggedin;

  Getplaylistresponse({
      this.status, 
      this.playlistData, 
      this.loggedin});

  Getplaylistresponse.fromJson(dynamic json) {
    status = json["status"];
    if (json["playlistData"] != null) {
      playlistData = [];
      json["playlistData"].forEach((v) {
        playlistData.add(PlaylistData.fromJson(v));
      });
    }
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (playlistData != null) {
      map["playlistData"] = playlistData.map((v) => v.toJson()).toList();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}

class PlaylistData {
  int id;
  int uid;
  String playlistName;
  int postType;
  String postMediaUrl;
  String createdAt;
  dynamic updatedAt;

  PlaylistData({
      this.id, 
      this.uid, 
      this.playlistName, 
      this.createdAt, 
      this.updatedAt});

  PlaylistData.fromJson(dynamic json) {
    id = json["id"];
    uid = json["uid"];
    playlistName = json["playlist_name"];
    postType = json["post_type"];
    postMediaUrl = json["post_media_url"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["uid"] = uid;
    map["playlist_name"] = playlistName;
    map["post_type"]=postType;
    map["post_media_url"]=postMediaUrl;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}