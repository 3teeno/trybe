class Getpostplaylistparams {
  String uid;
  String playlistId;
  String page;
  String limit;

  Getpostplaylistparams({
      this.uid, 
      this.playlistId, 
      this.page, 
      this.limit});

  Getpostplaylistparams.fromJson(dynamic json) {
    uid = json["uid"];
    playlistId = json["playlist_id"];
    page = json["page"];
    limit = json["limit"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["playlist_id"] = playlistId;
    map["page"] = page;
    map["limit"] = limit;
    return map;
  }

}