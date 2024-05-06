class Chat {
  String? id;
  String? userId;
  String? toUser;
  String? time;
  String? message;

  Chat({this.id, this.userId, this.toUser, this.time, this.message});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    toUser = json['toUser'];
    time = json['time'];
    message = json['message'];
  }

}