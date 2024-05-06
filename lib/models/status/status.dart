class Status {
  String? userId;
  String? image;

  Status(
      {this.userId, this.image});

  Status.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    image = json['image'];
  }
}