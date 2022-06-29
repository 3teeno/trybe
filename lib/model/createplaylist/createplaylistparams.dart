class Createplaylistparams {
  String uid;
  String playlistName;

  Createplaylistparams({
      this.uid, 
      this.playlistName});

  Createplaylistparams.fromJson(dynamic json) {
    uid = json["uid"];
    playlistName = json["playlist_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["playlist_name"] = playlistName;
    return map;
  }

}