import 'dart:ffi';

import 'package:socialhub/app_state.dart';
import 'package:socialhub/common_widgets/responsive.dart';
import 'package:socialhub/models/post/comment.dart';
import 'package:socialhub/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/logo.dart';
import '../../constants.dart';
import '../../models/post/post.dart';
import '../../models/user/user.dart';

class OpenProfile extends StatefulWidget {
  String id;
  User Function({String  id}) idtoUser;
  Future<bool?> Function(int index) likeOrDislike, saveOrUnsave;
  Function(Post post) sharePost;
  Future<CommentModel?> Function(int index, String comment) comment;
  Function(int index)  openPost;
   OpenProfile({Key? key,
     required this.id,
     required this.likeOrDislike,
     required this.openPost,
     required this.sharePost,
     required this.idtoUser,
     required this.comment,
     required this.saveOrUnsave
   }) : super(key: key);

  @override
  State<OpenProfile> createState() => _OpenProfileState();
}

class _OpenProfileState extends State<OpenProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: SocialHub(factor: 0.6),
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_outlined,color: Theme.of(context).textTheme.headline5!.color,)
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: constantPadding,),
          Builder(
            builder: (context) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    if(MyInheritedWidget.of(context)!.allPosts!.isNotEmpty)
                    Profile(saveOrUnsave: widget.saveOrUnsave , likeOrDislike: widget.likeOrDislike, openPost: widget.openPost, sharePost: widget.sharePost, idtoUser: widget.idtoUser, comment: widget.comment, userId: widget.id,),
                    if(MyInheritedWidget.of(context)!.allPosts!.isEmpty)
                    const Expanded(child: Center(child: Text("Network problem"),)),
                    Expanded(child: Container()),
                  ],
                ),
              );
            }
          ),
          const SizedBox(height: constantPadding,),
        ],
      ),
    );
  }
}
