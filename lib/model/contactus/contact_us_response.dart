class ContactUsResponse {
  String status;
  List<Data> data;

  ContactUsResponse({
      this.status, 
      this.data});

  ContactUsResponse.fromJson(dynamic json) {
    status = json["status"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  int id;
  String title;
  String description;
  String createdAt;
  String updatedAt;

  Data({
      this.id, 
      this.title, 
      this.description, 
      this.createdAt, 
      this.updatedAt});

  Data.fromJson(dynamic json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["description"] = description;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}