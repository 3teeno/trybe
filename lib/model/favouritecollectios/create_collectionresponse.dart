import 'collection_list_response.dart';

class Create_collectionresponse {
  String status;
  String message;
  List<CollectionData> collectionData;
  bool loggedin;

  Create_collectionresponse({
      this.status, 
      this.message, 
      this.collectionData, 
      this.loggedin});

  Create_collectionresponse.fromJson(dynamic json) {
    status = json["status"];
    message = json["message"];
    if (json["collectionData"] != null) {
      collectionData = [];
      json["collectionData"].forEach((v) {
        collectionData.add(CollectionData.fromJson(v));
      });
    }
    loggedin = json["loggedin"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["message"] = message;
    if (collectionData != null) {
      map["collectionData"] = collectionData.map((v) => v.toJson()).toList();
    }
    map["loggedin"] = loggedin;
    return map;
  }

}
