import 'package:flutter/material.dart';

class Getplaylistparams {
  String uid;
  String other_uid;
  String sort_by;


  Getplaylistparams({
    this.other_uid,
    this.sort_by,
      this.uid});

  Getplaylistparams.fromJson(dynamic json) {
    uid = json["uid"];
    sort_by=json["sort_by"];
    other_uid = json["other_uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["sort_by"]=sort_by;
    map["other_uid"] = other_uid;
    return map;
  }

}