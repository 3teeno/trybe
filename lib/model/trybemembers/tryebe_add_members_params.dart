class Tryebe_add_members_params {
  String treeId;
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  String birthPlace;
  String deathDate;
  String deathPlace;
  String notes;
  String relation;
  String suffix;
  int tree_relation;
  int id;
  String livingStatus;


  Tryebe_add_members_params({
      this.treeId, 
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
      this.tree_relation,
      this.id,
      this.livingStatus

  });

  Tryebe_add_members_params.fromJson(dynamic json) {
    treeId = json["tree_id"];
    firstName = json["first_name"];
    lastName = json["last_name"];
    gender = json["gender"];
    birthDate = json["birth_date"];
    birthPlace = json["birth_place"];
    deathDate = json["death_date"];
    deathPlace = json["death_place"];
    notes = json["notes"];
    relation = json["relation"];
    suffix = json["suffix"];
    livingStatus = json["living_status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tree_id"] = treeId;
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
    map["id"] = id;
    map["tree_relation"] = tree_relation;
    map["living_status"] = livingStatus;
    return map;
  }

}