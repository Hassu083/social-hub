import 'dart:convert';

import 'package:socialhub/common_widgets/responsive.dart';
import 'package:socialhub/screens/home/home_widget/menu.dart';
import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../color.dart';
import '../../constants.dart';
import '../../models/post/comment.dart';
import '../../models/post/post.dart';
import '../../models/user/user.dart';
import '../home/home_widget/eachPost.dart';
import '../home/home_widget/profile_image.dart';

class SavePost extends StatelessWidget {
  User Function({String  id}) idtoUser;
  Future<bool?> Function(int index) likeOrDislike,saveOrUnsave;
  Function(Post post) sharePost;
  String userId;
  Future<CommentModel?> Function(int index, String comment) comment;
  Function(int index)  openPost;
  SavePost({Key? key,
    required this.likeOrDislike,
    required this.openPost,
    required this.sharePost,
    required this.idtoUser,
    required this.comment,
    required this.userId,
    required this.saveOrUnsave
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
        width: Responsive.isMobile(context)?325:790,
      height: double.infinity,
      decoration: BoxDecoration(
          color: context.isDarkMode ? logoColor : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(30))
        ),
      child: Row(
              children: [
                Expanded(child: Container()),
                SizedBox(
                  width: Responsive.isMobile(context)?310:450,
                  height: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: constantPadding,),
                      Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MyInheritedWidget.of(context)!.loggedInUser!.savePosts!.contains(MyInheritedWidget.of(context)!.allPosts![index].postId)? PostGUIItself(
                                color: const Color(0xFFFFF9EA) ,
                                index: index,
                                idtoUser: idtoUser,
                                saveOrUnsave: saveOrUnsave,
                                likeOrDislike: likeOrDislike,
                                home: true,
                                sharePost: sharePost, comment: comment,
                              ):const SizedBox(height: 0,);
                            },
                            separatorBuilder: (context, index) {
                              return MyInheritedWidget.of(context)!.loggedInUser!.savePosts!.contains(MyInheritedWidget.of(context)!.allPosts![index].postId)?const SizedBox(height: constantPadding,):
                              const SizedBox(height: 0,);
                            },
                            itemCount: MyInheritedWidget.of(context)!.allPosts?.length ?? 0
                        ),
                      ),
                      const SizedBox(height: constantPadding,)
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            )
    );
  }
}
