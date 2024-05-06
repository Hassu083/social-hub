class User {
  String? userId;
  String? userName;
  String? userUsername;
  String? userEmail;
  String? userPassword;
  String? userPhone;
  String? userProfileImageLinkName;
  String? userCoverPhotoLinkName;
  String? userBio;
  String? profileImage;
  String? coverImage;
  String? numOfPost;
  String? online;
  String? numOffollowers;
  String? numOffollowing;
  String? msg;
  List<String>? following,savePosts;

  User(
      {this.userId,
        this.userName,
        this.userUsername,
        this.userEmail,
        this.userPassword,
        this.userPhone,
        this.userProfileImageLinkName,
        this.userCoverPhotoLinkName,
        this.userBio,
        this.online,
        this.profileImage,
        this.coverImage,
        this.following,
        this.savePosts,
        this.numOffollowers,
        this.numOffollowing,
        this.numOfPost,
        this.msg
        });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userUsername = json['userUsername'];
    userEmail = json['userEmail'];
    online = json['online'];
    userPassword = json['userPassword'];
    userPhone = json['userPhone'];
    userProfileImageLinkName = json['userProfileImageLinkName'];
    userCoverPhotoLinkName = json['userCoverPhotoLinkName'];
    userBio = json['userBio'];
    profileImage = json['profileImage'];//UPDATE `post` SET `userId` = '6' WHERE `post`.`post_id` = 10; UPDATE `post` SET `userId` = '5' WHERE `post`.`post_id` = 11; UPDATE `post` SET `userId` = '5' WHERE `post`.`post_id` = 12;
    coverImage = json['coverImage'];
    numOffollowing = json['0']['following'];
    numOffollowers = json['1']['follower'];
    numOfPost = json['2']['posts'];
    following = List<String>.from(json['following']);
    savePosts = List<String>.from(json['savePosts']);
  }
}