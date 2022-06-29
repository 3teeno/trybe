class Privacyclass {
  String iscreativejournal;
  String privacy;
  String istrybelist;
  String trybelistid;
  String isfavorites;
  String favoritesid;
  String istrybegroup;
  String trybegroupid;
  String selectaudience;

  Privacyclass(
      {this.iscreativejournal,
      this.privacy,
      this.istrybelist,
      this.trybelistid,
      this.isfavorites,
      this.favoritesid,
      this.istrybegroup,
      this.trybegroupid,
      this.selectaudience});

  Privacyclass.fromJson(dynamic json) {
    iscreativejournal = json["isCreativeJournal"];
    privacy = json["privacy"];
    istrybelist = json["istrybelist"];
    trybelistid = json["trybelistid"];
    isfavorites = json["isfavorites"];
    favoritesid = json["favoritesid"];
    istrybegroup = json["istrybegroup"];
    trybegroupid = json["trybegroupid"];
    selectaudience = json["selectaudience"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["isCreativeJournal"] = iscreativejournal;
    map["istrybelist"] = istrybelist;
    map["trybelistid"] = trybelistid;
    map["isfavorites"] = isfavorites;
    map["favoritesid"] = favoritesid;
    map["istrybegroup"] = istrybegroup;
    map["trybegroupid"] = trybegroupid;
    map["privacy"] = privacy;
    map["selectaudience"] = selectaudience;
    return map;
  }
}
