

import 'package:socialhub/models/post/comment.dart';

class Post {
  String? postId;
  String? userId;
  String? caption;
  String? image;
  String? date;
  String? isprofile;
  String? imageEncode;
  List<String>? personLike;
  List<String>? report;
  String? postOwner;
  List<CommentModel>? comments;

  Post(
      {this.postId,
        this.userId,
        this.caption,
        this.image,
        this.date,
        this.isprofile,
        this.imageEncode,
        this.personLike,
        this.postOwner,
        this.comments,
        this.report});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['userId'];
    caption = json['caption'];
    image = json['image'];
    date = json['date'];
    isprofile = json['profile'];
    imageEncode = json['imageEncode'];
    postOwner = json['postOwner'];
    personLike = List<String>.from(json['personLike']);
    report = List<String>.from(json['report']);
    comments = [];
    for (var commentJson in json['comments']){
      comments!.add(CommentModel.fromJson(commentJson));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = postId;
    data['userId'] = userId;
    data['caption'] = caption;
    data['image'] = image;
    data['date'] = date;
    data['isprofile'] = isprofile;
    data['imageEncode'] = imageEncode;
    return data;
  }
}