import 'package:socialhub/color.dart';
import 'package:socialhub/common_widgets/comment_element.dart';
import 'package:socialhub/models/post/comment.dart';
import 'package:socialhub/models/post/post.dart';
import 'package:socialhub/screens/home/home_widget/eachPost.dart';
import 'package:socialhub/screens/home/home_widget/home_input.dart';
import 'package:socialhub/toast/toast.php.dart';
import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../common_widgets/logo.dart';
import '../../common_widgets/responsive.dart';
import '../../constants.dart';
import '../../models/user/user.dart';

class PostWidget extends StatefulWidget {
  int index;
  Function(Post post) sharePost;
  Future<bool?> Function(int index) likes, saveOrUnsave;
  Future<CommentModel?> Function(int index, String comment) comment;
  User Function({String id}) function;

  PostWidget({Key? key,
    required this.function,
    required this.index,
    required this.likes,
    required this.sharePost,
    required this.comment,
    required this.saveOrUnsave
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  TextEditingController commentText = TextEditingController();


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
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container()),
                Container(
                  width: Responsive.isMobile(context)? 325 : 450,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Expanded(child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                              PostGUIItself(index: widget.index,
                                  home: false,
                                  idtoUser: widget.function,
                                  likeOrDislike: widget.likes,
                                  saveOrUnsave: widget.saveOrUnsave,
                                  sharePost: widget.sharePost,
                                  comment: widget.comment,
                              ),
                              const SizedBox(height: constantPadding*0.5,),
                              ListView.separated(
                                      itemBuilder: (context, index1){
                                        return Comment(user: widget.function(id: MyInheritedWidget.of(context)!.allPosts![widget.index].comments![index1].userId!), comment: MyInheritedWidget.of(context)!.allPosts![widget.index].comments![index1].comment!);
                                      },
                                      separatorBuilder: (context,index) => const SizedBox(height: 4,),
                                      itemCount: MyInheritedWidget.of(context)!.allPosts?[widget.index].comments?.length ?? 0,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                  )
                          ],
                        ),
                      )),
                      const SizedBox(height: constantPadding*0.5,),
                      Container(
                            padding: const EdgeInsets.all(1.5),
                            width: double.infinity,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: logoColor,
                              borderRadius: BorderRadius.all(Radius.circular(-500))
                            ),
                            child: HomeInput(controller: commentText, hinttext: 'write comment...',color: Colors.white,preffix: const Icon(Icons.comment),
                            suffix: GestureDetector(
                              onTap: () async {
                               if(MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
                                 if (commentText.text.isNotEmpty) {
                                   var comm = await widget.comment(
                                       widget.index, commentText.text);
                                   setState(() {
                                     MyInheritedWidget.of(context)!
                                         .allPosts![widget.index].comments!.add(
                                         comm!);
                                   });
                                 }else{
                                   HubToast.shToast(context, 'First write comment', 90);
                                 }
                               }else{
                                 HubToast.shToast(context, 'Admin cannot comment', 90);
                               }
                                commentText.text = '';
                              },
                              child: const Icon(Icons.send,color: logoColor,),
                            ),),
                          ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          const SizedBox(height: constantPadding,),
        ],
      ),
    );
  }
}
