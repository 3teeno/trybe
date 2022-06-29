class ViewByStatusParams {
  String viewBy;
  dynamic userId;

  ViewByStatusParams({
      this.viewBy, 
      this.userId});

  ViewByStatusParams.fromJson(dynamic json) {
    viewBy = json['view_by'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['view_by'] = viewBy;
    map['user_id'] = userId;
    return map;
  }

}