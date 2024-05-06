class CommentModel {
  String? comment_id;
  String? userId;
  String? post_id;
  String? comment;

  CommentModel(
      {this.comment_id,
        this.userId,
        this.post_id,
        this.comment,});

  CommentModel.fromJson(Map<String, dynamic> json) {
    comment_id = json['comment_id'];
    userId = json['userId'];
    post_id = json['post_id'];
    comment = json['comment'];
  }

}