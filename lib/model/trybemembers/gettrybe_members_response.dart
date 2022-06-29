class Gettrybe_members_response {
  String status;
  List<MemberData> memberData;
  bool loggedin;
  dynamic userId;

  Gettrybe_members_response({
      this.status, 
      this.memberData, 
      this.loggedin});

  Gettrybe_members_response.fromJson(dynamic json) {
    status = json["status"];
    if (json["memberData"] != null) {
      memberData = [];
      json["memberData"].forEach((v) {
        memberData.add(MemberData.fromJson(v));
      });
    }
    loggedin = json["loggedin"];
    userId = json["treeOwner"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (memberData != null) {
      map["memberData"] = memberData.map((v) => v.toJson()).toList();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}

class MemberData {
  int id;
  int treeId;
  int treeRelation;
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  String birthPlace;
  String deathDate;
  String deathPlace;
  String notes;
  String livingStatus;
  String relation;
  dynamic suffix;
  String createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  dynamic relationArray;

  MemberData({
      this.id, 
      this.treeId, 
      this.treeRelation, 
      this.relationArray,
      this.firstName, 
      this.lastName, 
      this.gender, 
      this.birthDate, 
      this.birthPlace, 
      this.deathDate, 
      this.deathPlace, 
      this.notes, 
      this.relation, 
      this.suffix, 
      this.createdAt, 
      this.updatedAt, 
      this.livingStatus,
      this.deletedAt});

  MemberData.fromJson(dynamic json) {
    id = json["id"];
    treeId = json["tree_id"];
    treeRelation = json["tree_relation"];
    relationArray = json["relation_array"];
    firstName = json["first_name"];
    lastName = json["last_name"];
    gender = json["gender"];
    birthDate = json["birth_date"];
    birthPlace = json["birth_place"];
    deathDate = json["death_date"];
    deathPlace = json["death_place"];
    notes = json["notes"];
    relation = json["relation"];
    livingStatus = json["living_status"];
    suffix = json["suffix"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["tree_id"] = treeId;
    map["tree_relation"] = treeRelation;
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["gender"] = gender;
    map["birth_date"] = birthDate;
    map["birth_place"] = birthPlace;
    map["death_date"] = deathDate;
    map["death_place"] = deathPlace;
    map["notes"] = notes;
    map["relation"] = relation;
    map["suffix"] = suffix;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["deleted_at"] = deletedAt;
    map["living_status"] = livingStatus;
    return map;
  }

}