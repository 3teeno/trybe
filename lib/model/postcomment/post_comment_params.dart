class Post_comment_params {
  String key;
  String uid;
  String postId;
  String commentContent;

  Post_comment_params({
      this.key, 
      this.uid, 
      this.postId, 
      this.commentContent});

  Post_comment_params.fromJson(dynamic json) {
    key = json["key"];
    uid = json["uid"];
    postId = json["post_id"];
    commentContent = json["comment_content"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["key"] = key;
    map["uid"] = uid;
    map["post_id"] = postId;
    map["comment_content"] = commentContent;
    return map;
  }

}