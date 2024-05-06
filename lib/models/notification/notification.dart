class MyNotification {
  String? notificationid;
  String? fromUser;
  String? toUser;
  String? readOrnot;
  String? message;

  MyNotification(
      {this.notificationid, this.fromUser, this.toUser, this.readOrnot, this.message});

  MyNotification.fromJson(Map<String, dynamic> json) {
    notificationid = json['notificationid'];
    fromUser = json['fromUser'];
    toUser = json['toUser'];
    readOrnot = json['readOrnot'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationid'] = this.notificationid;
    data['fromUser'] = this.fromUser;
    data['readOrnot'] = this.readOrnot;
    data['message'] = this.message;
    return data;
  }
}