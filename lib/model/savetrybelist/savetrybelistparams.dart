class Savetrybelistparams {
  String key;
  String playlistId;
  String postId;

  Savetrybelistparams({
      this.key, 
      this.playlistId, 
      this.postId});

  Savetrybelistparams.fromJson(dynamic json) {
    key = json["key"];
    playlistId = json["playlist_id"];
    postId = json["post_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["key"] = key;
    map["playlist_id"] = playlistId;
    map["post_id"] = postId;
    return map;
  }

}