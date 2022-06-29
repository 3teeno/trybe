class SupportUsResponse {
  String status;
  List<Data> data;

  SupportUsResponse({
      this.status, 
      this.data});

  SupportUsResponse.fromJson(dynamic json) {
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
  String patreon;
  String patreonIcon;
  String bitcoin;
  String bitcoinIcon;
  String paypal;
  String paypalIcon;
  String createdAt;
  dynamic updatedAt;

  Data({
      this.id, 
      this.patreon, 
      this.patreonIcon, 
      this.bitcoin, 
      this.bitcoinIcon, 
      this.paypal, 
      this.paypalIcon, 
      this.createdAt, 
      this.updatedAt});

  Data.fromJson(dynamic json) {
    id = json["id"];
    patreon = json["patreon"];
    patreonIcon = json["patreonIcon"];
    bitcoin = json["bitcoin"];
    bitcoinIcon = json["bitcoinIcon"];
    paypal = json["paypal"];
    paypalIcon = json["paypalIcon"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["patreon"] = patreon;
    map["patreonIcon"] = patreonIcon;
    map["bitcoin"] = bitcoin;
    map["bitcoinIcon"] = bitcoinIcon;
    map["paypal"] = paypal;
    map["paypalIcon"] = paypalIcon;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    return map;
  }

}