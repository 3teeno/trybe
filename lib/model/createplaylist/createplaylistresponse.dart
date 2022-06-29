import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';

class Createplaylistresponse {
  String status;
  List<PlaylistData> playlistData;
  String message;
  bool loggedin;

  Createplaylistresponse({
      this.status, 
      this.playlistData, 
      this.message, 
      this.loggedin});

  Createplaylistresponse.fromJson(dynamic json) {
    status = json["status"];
    if (json["playlistData"] != null) {
      playlistData = [];
      json["playlistData"].forEach((v) {
        playlistData.add(PlaylistData.fromJson(v));
      });
    }
    message = json["message"];
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (playlistData != null) {
      map["playlistData"] = playlistData.map((v) => v.toJson()).toList();
    }
    map["message"] = message;
    map["loggedin"] = loggedin;
    return map;
  }

}
