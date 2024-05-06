class ReviewModel {
  String? userId;
  String? stars;
  String? review;

  ReviewModel(
      {this.stars,
        this.userId,
        this.review,
        });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    stars = json['stars'];
    review = json['review'];
  }

}