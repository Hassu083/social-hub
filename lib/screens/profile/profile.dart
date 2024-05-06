import 'dart:convert';

import 'package:socialhub/models/post/post.dart';
import 'package:socialhub/screens/home/home_widget/menu.dart';
import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../color.dart';
import '../../common_widgets/responsive.dart';
import '../../constants.dart';
import '../../models/post/comment.dart';
import '../../models/user/user.dart';
import '../home/home_widget/eachPost.dart';
import '../home/home_widget/profile_image.dart';

class Profile extends StatelessWidget {
  User Function({String  id}) idtoUser;
  Future<bool?> Function(int index) likeOrDislike,saveOrUnsave;
  Function(Post post) sharePost;
  String userId;
  Future<CommentModel?> Function(int index, String comment) comment;
  Function(int index)  openPost;
   Profile({Key? key,
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
      color: context.isDarkMode ? logoColor : Colors.white, width: Responsive.isMobile(context)? 325 : 790,
      height: double.infinity,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  SizedBox(child: ClipRRect(child: Image.memory(base64Decode(idtoUser(id: userId).coverImage!),fit: BoxFit.fitWidth,),borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30) ),),
                      width: double.infinity,height: Responsive.isMobile(context)? 200 : 300),
                  Positioned(
                      bottom: Responsive.isMobile(context)? -50 : -80,
                      child: ProfileImage(width: Responsive.isMobile(context)? 100 :180,height: Responsive.isMobile(context)? 100 : 180,user: idtoUser(id: userId),)
                  )
                ],
              ),
            ),
             SizedBox(height: Responsive.isMobile(context)?50:80,),
            //2nd
            Text(idtoUser(id: userId).userName!,style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: constantPadding*0.5,),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: Responsive.isMobile(context)?325:400,
                child: Center(child: Text(idtoUser(id: userId).userBio!))
            ),
            const SizedBox(height: constantPadding,),
            const Divider(),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              spacing: Responsive.isMobile(context)?20: 60,
              children: [
                Text("${MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin'?MyInheritedWidget.of(context)!.loggedInUser!.numOfPost!:0} posts"),
                Container(width: 2,height: 30,color: Colors.black38,),
                Text("${MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin'?idtoUser(id: userId).following?.length ?? 0:0} following"),
                Container(width: 2,height: 30,color: Colors.black38,),
                Text("${MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin'?MyInheritedWidget.of(context)!.loggedInUser!.numOffollowers!:0} followers"),
              ],
            ),
            const Divider(),
            Row(
              children: [
                if(!Responsive.isMobile(context))
                Expanded(child: Container()),
                SizedBox(
                  width: Responsive.isMobile(context)?325:450,
                  child: Column(
                    children: [
                      const SizedBox(height: constantPadding,),
                      ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MyInheritedWidget.of(context)!.allPosts![index].userId == userId? PostGUIItself(
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
                            return MyInheritedWidget.of(context)!.allPosts![index].userId == userId?const SizedBox(height: constantPadding,):
                            const SizedBox(height: 0,);
                          },
                          itemCount: MyInheritedWidget.of(context)!.allPosts?.length ?? 0
                      ),
                      const SizedBox(height: constantPadding,)
                    ],
                  ),
                ),
                if(!Responsive.isMobile(context))
                Expanded(child: Container()),
              ],
            )
          ],
        ),
      ),

    );
  }
}
