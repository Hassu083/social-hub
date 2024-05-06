class Reel {
  String? reelId;
  String? userId;
  String? directory;
  String? video;

  Reel({this.reelId, this.userId, this.directory, this.video});

  Reel.fromJson(Map<String, dynamic> json) {
    reelId = json['reelId'];
    userId = json['userId'];
    directory = json['directory'];
    video = json['video'];
  }

}