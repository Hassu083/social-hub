import 'package:socialhub/models/notification/notification.dart';
import 'package:socialhub/models/post/post.dart';
import 'package:socialhub/models/user/user.dart';
import 'package:flutter/material.dart';

class MyInheritedWidget extends InheritedWidget{
  MyStatefulWidgetState state;
  MyInheritedWidget({Key? key, required Widget child,required this.state}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static MyStatefulWidgetState? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()?.state;

}

class MyStatefulWidget extends StatefulWidget {
  Widget child;
  MyStatefulWidget({Key? key,required this.child}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<User>? users;
  String url = "http://localhost/dashboard/socialHub/";
  User? loggedInUser;
  List<bool>? follow;
  List<MyNotification>? notifications;
  List<Post>? allPosts;

  getPosts(List<Post> posts)=> setState((){
    allPosts = posts;
  });

  userLogin(User currentUsers) => setState((){
    loggedInUser = currentUsers;
  });

  followNew(List<bool> newFollowers) => setState((){
    follow = newFollowers;
  });

  getNotification(List<MyNotification> notification) => setState((){
    notifications = notification;
  });

  allUsers(List<User> newUsers) => setState((){
    users = newUsers;
  });

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(child: widget.child, state: this);
  }
}

