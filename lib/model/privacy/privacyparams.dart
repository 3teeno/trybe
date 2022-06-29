class Privacyparams {
  String uid;
  bool istrybelistprivate;
  // bool istrybetreeprivate;
  bool istrybegroupprivate;

  Privacyparams({
      this.uid, 
      this.istrybelistprivate,
      // this.istrybetreeprivate,
      this.istrybegroupprivate});
  //
  Privacyparams.fromJson(dynamic json) {
    uid = json["uid"];
    istrybelistprivate = json["istrybelistprivate"];
    // istrybetreeprivate = json["istrybetreeprivate"];
    // istrybegroupprivate = json["istrybegroupprivate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uid"] = uid;
    map["istrybelistprivate"] = istrybelistprivate;
    // map["istrybetreeprivate"] = istrybetreeprivate;
    map["istrybegroupprivate"] = istrybegroupprivate;
    return map;
  }

}