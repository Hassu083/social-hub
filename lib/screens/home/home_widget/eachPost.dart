import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socialhub/common_widgets/comment_element.dart';
import 'package:socialhub/models/post/comment.dart';
import 'package:socialhub/models/post/post.dart';
import 'package:socialhub/models/user/user.dart';
import 'package:socialhub/screens/home/home_widget/profile_image.dart';
import 'package:flutter/material.dart';
import '../../../app_state.dart';
import '../../../common_widgets/responsive.dart';
import '../../../constants.dart';
import '../../../toast/toast.php.dart';

class PostGUIItself extends StatefulWidget {
  int index;
  bool home;
  Color? color;
  User Function({String  id}) idtoUser;
  Future<bool?> Function(int index) likeOrDislike, saveOrUnsave;
  Function(Post post)  sharePost;
  Future<CommentModel?> Function(int index, String comment) comment;

   PostGUIItself({Key? key,
   required this.index,
   required this.idtoUser,
   required this.likeOrDislike,
   required this.sharePost,
   required this.home,
   required this.comment,
   required this.saveOrUnsave,
     this.color,
   }) : super(key: key);

  @override
  State<PostGUIItself> createState() => _PostGUIItselfState();
}

class _PostGUIItselfState extends State<PostGUIItself> {

  @override
  Widget build(BuildContext context) {
    User user = widget.idtoUser(id: MyInheritedWidget.of(context)!.allPosts![widget.index].userId!);
    return Column(
      children: [
        Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: constantPadding,
                  vertical: constantPadding * 0.5),
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.color ?? Theme
                    .of(context)
                    .primaryColor,
                borderRadius: const BorderRadius.all(
                    Radius.circular(20)),

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment
                    .start,
                children: [
                  ListTile(
                    leading: ProfileImage(user: user,),
                    dense: false,
                    contentPadding: EdgeInsets.zero,
                    title:  Text(user.userName ?? ""),
                    subtitle:  Text(MyInheritedWidget.of(context)!.allPosts![widget.index].date ?? ''),
                    trailing: PopupMenuButton(itemBuilder: (BuildContext context) {
                      return [
                        if(MyInheritedWidget.of(context)!.loggedInUser!.userId!= 'admin' && MyInheritedWidget.of(context)!.loggedInUser!.userId != null && MyInheritedWidget.of(context)!.allPosts![widget.index].userId! != MyInheritedWidget.of(context)!.loggedInUser!.userId)
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.report,color: Colors.red,),
                            title: Text("Report",style: Theme.of(context).textTheme.headline5,),
                            onTap: () async {
                              try {
                                var response = await http
                                    .post(
                                    Uri.parse(
                                        "${MyInheritedWidget
                                            .of(
                                            context)!
                                            .url}report.php"),
                                    body: {
                                      "post_id": MyInheritedWidget.of(context)!.allPosts![widget.index]
                                          .postId,
                                      "userId": MyInheritedWidget
                                          .of(context)!
                                          .loggedInUser!
                                          .userId,
                                    });
                                print(response.body);
                                HubToast.shToast(
                                    context, "Reported successfully.", 100);
                              } catch (e) {
                                print(e);
                                HubToast.shToast(
                                    context, "Already Reported.", 100);
                              }
                            },
                          ),
                        ),
                        if(MyInheritedWidget.of(context)!.loggedInUser!.userId!= 'admin' && MyInheritedWidget.of(context)!.allPosts![widget.index].userId! == MyInheritedWidget.of(context)!.loggedInUser!.userId)
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(Icons.delete,color: Colors.red,),
                              title: Text("Delete",style: Theme.of(context).textTheme.headline5,),
                              onTap: () async {
                                try {
                                  var response = await http
                                      .post(
                                      Uri.parse(
                                          "${MyInheritedWidget
                                              .of(
                                              context)!
                                              .url}deletepost.php"),
                                      body: {
                                        "post_id": MyInheritedWidget.of(context)!.allPosts![widget.index]
                                            .postId,
                                      });
                                  print(response.body);
                                  await HubToast.shToast(
                                      context, "Deleted successfully.", 100);
                                  Navigator.pushNamed(context, '/home');
                                } catch (e) {
                                  print(e);
                                  HubToast.shToast(
                                      context, "Some problem in deleting Post.", 100);
                                }
                              },
                            ),
                          ),
                        if(MyInheritedWidget.of(context)!.loggedInUser!.userId!= 'admin' && MyInheritedWidget.of(context)!.allPosts![widget.index].userId! == MyInheritedWidget.of(context)!.loggedInUser!.userId)
                          PopupMenuItem(
                            child: ListTile(
                              onTap:(){
                                if(MyInheritedWidget.of(context)!.allPosts![widget.index].isprofile == null) {
                                  String image;
                                  if (MyInheritedWidget.of(context)!
                                      .allPosts![widget.index].isprofile ==
                                      null || MyInheritedWidget.of(context)!
                                      .allPosts![widget.index].isprofile ==
                                      "") {
                                    image =
                                    "C:/xampp/againxamp/htdocs/dashboard/socialHub/posts/${MyInheritedWidget
                                        .of(context)!.allPosts![widget.index]
                                        .image}";
                                  } else {
                                    image =
                                    "C:/xampp/againxamp/htdocs/dashboard/socialHub/images/${MyInheritedWidget
                                        .of(context)!.allPosts![widget.index]
                                        .image}";
                                  }
                                  Navigator.pushNamed(
                                      context, "/post", arguments: {
                                    "post": MyInheritedWidget.of(context)!
                                        .allPosts![widget.index].postId,
                                    "isprofile": MyInheritedWidget.of(context)!
                                        .allPosts![widget.index].isprofile ??
                                        "0",
                                    'imageLink': image,
                                    'cap': MyInheritedWidget.of(context)!
                                        .allPosts![widget.index].caption ?? ""
                                  }
                                  );
                                }else{
                                  HubToast.shToast(
                                      context, "Dear User! you cannot edit this post.", 100);
                                }
                              },
                              leading: const Icon(Icons.edit,color: Colors.green,),
                              title: Text("Edit",style: Theme.of(context).textTheme.headline5,),
                            ),
                          ),
                        if(MyInheritedWidget.of(context)!.loggedInUser!.userId == 'admin')
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(Icons.delete,color: Colors.red,),
                              title: Text("Delete",style: Theme.of(context).textTheme.headline5,),
                              onTap: () async {
                                if(MyInheritedWidget.of(context)!.allPosts![widget.index].report!.isNotEmpty) {
                                  try {
                                    var response = await http
                                        .post(
                                        Uri.parse(
                                            "${MyInheritedWidget
                                                .of(
                                                context)!
                                                .url}adminDelete.php"),
                                        body: {
                                          "post_id": MyInheritedWidget.of(
                                              context)!.allPosts![widget.index]
                                              .postId,
                                        });
                                    print(response.body);
                                    await HubToast.shToast(
                                        context, "Deleted successfully.", 90);
                                    Navigator.pushNamed(context, '/home');
                                  } catch (e) {
                                    print(e);
                                    HubToast.shToast(
                                        context,
                                        "Some problem in deleting Post.", 90);
                                  }
                                }else{
                                  HubToast.shToast(
                                      context,
                                      "This post is not reported, so you cannot delete it.", 100);
                                }
                              },
                            ),
                          ),
                        if(MyInheritedWidget.of(context)!.loggedInUser!.userId == 'admin' && MyInheritedWidget.of(context)!.allPosts![widget.index].report!.isNotEmpty)
                          PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(Icons.report,color: Colors.red,),
                                title: Text("Reported by",style: Theme.of(context).textTheme.headline5,),
                                trailing: PopupMenuButton(itemBuilder: (BuildContext context) {
                                  return MyInheritedWidget.of(context)!.allPosts![widget.index].report!.map((e){
                                    User user = widget.idtoUser(id: e);
                                    return PopupMenuItem(child: ListTile(
                                      leading: ProfileImage(user: user,),
                                      title: Text(user.userName ?? '',style: Theme.of(context).textTheme.headline5,),
                                    ));
                                  }).toList();
                                },

                                ),
                              )
                          )
                      ];
                    },)
                  ),
                  const Divider(),
                  if(MyInheritedWidget.of(context)!.allPosts![widget.index].postOwner == null)
                  Text(
                      MyInheritedWidget.of(context)!.allPosts![widget.index].caption ?? ""),
                  if(MyInheritedWidget.of(context)!.allPosts![widget.index].postOwner == null)
                  const SizedBox(
                    height: constantPadding * 0.5,),
                  if (MyInheritedWidget.of(context)!.allPosts![widget.index].image != null && MyInheritedWidget.of(context)!.allPosts![widget.index].isprofile!='1' && MyInheritedWidget.of(context)!.allPosts![widget.index].postOwner==null)
                    GestureDetector(
                      onTap:(){
                        if(widget.home){
    Navigator.pushNamed(context, "/openpost",arguments: {"saveOrUnsave":widget.saveOrUnsave,"function":widget.idtoUser,"likes":widget.likeOrDislike,"index":widget.index,"share":widget.sharePost,"comment":widget.comment});
                        }
                      },
                      child: Container(
                        decoration:BoxDecoration(
                          borderRadius:  const BorderRadius.all(
                              Radius.circular(20)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Container(
                          height:Responsive.isMobile(context)? 350 : 400,
                          width:double.infinity,
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(2),
                          decoration:BoxDecoration(
                              borderRadius:  const BorderRadius.all(
                                  Radius.circular(20)),
                              color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20)),
                            child:
                            Image.memory(base64Decode(MyInheritedWidget.of(context)!.allPosts![widget.index].imageEncode ?? "")),
                          ),
                        ),
                      ),
                    ),
                  if(MyInheritedWidget.of(context)!.allPosts![widget.index].postOwner != null)
                    GestureDetector(
                      onTap:(){
                        if(widget.home){
    Navigator.pushNamed(context, "/openpost",arguments: {"saveOrUnsave":widget.saveOrUnsave,"function":widget.idtoUser,"likes":widget.likeOrDislike,"index":widget.index,"share":widget.sharePost,"comment":widget.comment});
                        }// openPost(post,index);

                      },
                      child: Container(
                        decoration:BoxDecoration(
                          borderRadius:  const BorderRadius.all(
                              Radius.circular(20)),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Container(
                          height:MyInheritedWidget.of(context)!.allPosts![widget.index].imageEncode != null && MyInheritedWidget.of(context)!.allPosts![widget.index].imageEncode != ""? Responsive.isMobile(context)? MyInheritedWidget.of(context)!.allPosts![widget.index].postOwner == null? 250 : 400 :400 :null,
                          width:double.infinity,
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(2),
                          decoration:BoxDecoration(
                              borderRadius:  const BorderRadius.all(
                                  Radius.circular(20)),
                              color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20)),
                            child:Column(
                              children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ListTile(
                                    leading: ProfileImage(user: widget.idtoUser(id: MyInheritedWidget.of(context)!.allPosts![widget.index].postOwner!),width: 40,height: 40,),
                                      dense: false,
                                    contentPadding: EdgeInsets.zero,
                                     title:  Text(widget.idtoUser(id: MyInheritedWidget.of(context)!.allPosts![widget.index].postOwner!).userName ?? "",style: Theme.of(context).textTheme.headline5,),
                                ),
                                  ),
                                const Divider(),
                                Text(
                                    MyInheritedWidget.of(context)!.allPosts![widget.index].caption ?? ""),
                              const SizedBox(
                             height: constantPadding * 0.5,),
                                if(MyInheritedWidget.of(context)!.allPosts![widget.index].imageEncode != null && MyInheritedWidget.of(context)!.allPosts![widget.index].imageEncode != "")
                                SizedBox(child: Image.memory(base64Decode(MyInheritedWidget.of(context)!.allPosts![widget.index].imageEncode ?? ""),),height: 250,),
            ],
            )

                          ),
                        ),
                      ),
                    ),
                  if (MyInheritedWidget.of(context)!.allPosts![widget.index].image != null && MyInheritedWidget.of(context)!.allPosts![widget.index].isprofile=='1'&& MyInheritedWidget.of(context)!.allPosts![widget.index].postOwner==null)
                    GestureDetector(
                      onTap:(){
                        if(widget.home){
    Navigator.pushNamed(context, "/openpost",arguments: {"saveOrUnsave":widget.saveOrUnsave,"function":widget.idtoUser,"likes":widget.likeOrDislike,"index":widget.index,"share":widget.sharePost,"comment":widget.comment});// openPost(post,index);

    }
                      },
                      child: Center(
                        child: Container(
                          decoration:BoxDecoration(
                              borderRadius:  const BorderRadius.all(
                                  Radius.circular(500)),
                              color: Theme.of(context).primaryColor
                          ),
                          child: Container(
                            height:Responsive.isMobile(context)?320:350,
                            width:Responsive.isMobile(context)?320:350,
                            margin: const EdgeInsets.all(3),
                            padding: const EdgeInsets.all(2),
                            decoration:BoxDecoration(
                                borderRadius:  const BorderRadius.all(
                                    Radius.circular(500)),
                                color: Theme.of(context).scaffoldBackgroundColor
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(500)),
                              child:
                              Image.memory(base64Decode(MyInheritedWidget.of(context)!.allPosts![widget.index].imageEncode ?? "")),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if(MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.isNotEmpty)
                    const SizedBox(
                      width: constantPadding * 0.5,),
                  if(MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.isNotEmpty)
                    GestureDetector(
                      onTap: (){
                        showDialog(context: context,
                          builder: (context) {
                            return AlertDialog(
                              scrollable: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              content: Container(
                                width: 300,
                                height: 200,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  color: Colors.white
                                ),
                                child: ListView.separated(
                                    itemBuilder: (context, index3){
                                      return ListTile(
                                        leading: ProfileImage(user: widget.idtoUser(id: MyInheritedWidget.of(context)!.allPosts![widget.index].personLike![index3]),),
                                        title: Text(widget.idtoUser(id: MyInheritedWidget.of(context)!.allPosts![widget.index].personLike![index3]).userName!,
                                          style: Theme.of(context).textTheme.headline5,
                                        ),
                                        trailing: Image.asset(heartfilled,scale: 1.4,),
                                      );
                                    },
                                    separatorBuilder: (context, index) => const SizedBox(height: constantPadding*0.5,),
                                    itemCount: MyInheritedWidget.of(context)!.allPosts![widget.index].personLike?.length ?? 0
                                ),
                              ),
                            );
                          }
                        );
                      },
                      child: Text(MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId) && MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.length>3?"yours & ${MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.length-1} others likes":
                      MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId) && MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.length==1? "only yours like":
                      MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId) && MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.length==2? "yours & 1 other likes":" ${MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.length} likes"),
                    ),
                  const SizedBox(
                    height: constantPadding * 0.5,),
                  Row(
                    children: [
                      GestureDetector(
                        child: SizedBox(width:30,height:30,child: Image.asset(MyInheritedWidget.of(context)!.allPosts![widget.index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId)?heartfilled:heart, scale: 1.4,)),
                        onTap: () async {
                          if(MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
                            bool? like = await widget.likeOrDislike(
                                widget.index);
                            if (like == true) {
                              setState(() {
                                MyInheritedWidget.of(context)!.allPosts![widget
                                    .index].personLike!.add(
                                    MyInheritedWidget.of(context)!.loggedInUser!
                                        .userId!);
                              });
                            } else if (like == false) {
                              setState(() {
                                MyInheritedWidget.of(context)!.allPosts![widget
                                    .index].personLike!.remove(
                                    MyInheritedWidget.of(context)!.loggedInUser!
                                        .userId!);
                              });
                            }
                          }


                      }
                      ),
                      const SizedBox(
                        width: constantPadding * 0.5,),
                      GestureDetector(
                          child: Image.asset(chat, scale: 1.4,),
                          onTap: (){
                            if(widget.home){
                              Navigator.pushNamed(context, "/openpost",arguments: {"saveOrUnsave":widget.saveOrUnsave,"function":widget.idtoUser,"likes":widget.likeOrDislike,"index":widget.index,"share":widget.sharePost,"comment":widget.comment});}// openPost(post,index);
                          },
                      ),
                      const SizedBox(
                        width: constantPadding * 0.5,),
                      GestureDetector(child: Image.asset(send, scale: 1.4,),
                      onTap: (){
    if(MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      widget.sharePost(MyInheritedWidget.of(context)!.allPosts![widget.index]);
    }
                      },),
                      Expanded(child: Container()),
                      GestureDetector(child: Container(child: MyInheritedWidget.of(context)!.loggedInUser!.savePosts!.contains(MyInheritedWidget.of(context)!.allPosts![widget.index].postId)?Image.asset(savefilled, scale: 1.4,):Image.asset(save, scale: 1.4,)),
                      onTap: () async {
    if(MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      bool? save = await widget.saveOrUnsave(widget.index);
      if (save == true) {
        setState(() {
          MyInheritedWidget.of(context)!.loggedInUser!.savePosts!.add(
            MyInheritedWidget.of(context)!.allPosts![widget.index]
                .postId!,);
        });
      } else if (save == false) {
        setState(() {
          MyInheritedWidget.of(context)!.loggedInUser!.savePosts!.remove(
            MyInheritedWidget.of(context)!.allPosts![widget.index]
                .postId!,);
        });
      }
    }
                      },),
                    ],
                  )
                ],
              ),
            ),
        if(MyInheritedWidget.of(context)!.allPosts![widget.index].comments!.map((e) => e.userId).toList().contains(MyInheritedWidget.of(context)!.loggedInUser!.userId) && widget.home)
        idToComment(MyInheritedWidget.of(context)!.loggedInUser!.userId!) ?? Container()
      ],
    );
  }

  Comment? idToComment(String id){
    for (var comment in MyInheritedWidget.of(context)!.allPosts![widget.index].comments!){
      if(comment.userId==id){
        return Comment(user: widget.idtoUser(id : id), comment: comment.comment!,color: widget.color,);
      }
    }
    return null;
  }
}

// class Waqti extends StatelessWidget {
//   const Waqti({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//           horizontal: constantPadding,
//           vertical: constantPadding * 0.5),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Theme
//             .of(context)
//             .primaryColor,
//         borderRadius: const BorderRadius.all(
//             Radius.circular(20)),
//
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment
//             .start,
//         children: [
//           ListTile(
//             leading: ProfileImage(user: user,),
//             dense: false,
//             contentPadding: EdgeInsets.zero,
//             title:  Text(user.userName ?? ""),
//             subtitle:  Text(posts[index].date ?? ''),
//             trailing: Image.asset(
//               dots, scale: 1.4,),
//           ),
//           const Divider(),
//           Text(
//               posts[index].caption ?? ""),
//           const SizedBox(
//             height: constantPadding * 0.5,),
//           if (posts[index].image != null && posts[index].isprofile!='1')
//             GestureDetector(
//               onTap:(){
//                 Navigator.pushNamed(context, "/openpost",arguments: {"post":posts[index],"function":idToUser});
//               },
//               child: Container(
//                 decoration:BoxDecoration(
//                   borderRadius:  const BorderRadius.all(
//                       Radius.circular(20)),
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 child: Container(
//                   height:400,
//                   width:double.infinity,
//                   margin: const EdgeInsets.all(3),
//                   padding: const EdgeInsets.all(2),
//                   decoration:BoxDecoration(
//                       borderRadius:  const BorderRadius.all(
//                           Radius.circular(20)),
//                       color: Theme.of(context).scaffoldBackgroundColor
//                   ),
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.all(
//                         Radius.circular(20)),
//                     child:
//                     Image.memory(base64Decode(posts[index].imageEncode ?? "")),
//                   ),
//                 ),
//               ),
//             ),
//           if (posts[index].image != null && posts[index].isprofile=='1')
//             GestureDetector(
//               onTap:(){
//                 Navigator.pushNamed(context, "/openpost",arguments: {"post":posts[index],"function":idToUser});
//               },
//               child: Center(
//                 child: Container(
//                   decoration:BoxDecoration(
//                       borderRadius:  const BorderRadius.all(
//                           Radius.circular(500)),
//                       color: Theme.of(context).primaryColor
//                   ),
//                   child: Container(
//                     height:350,
//                     width:350,
//                     margin: const EdgeInsets.all(3),
//                     padding: const EdgeInsets.all(2),
//                     decoration:BoxDecoration(
//                         borderRadius:  const BorderRadius.all(
//                             Radius.circular(500)),
//                         color: Theme.of(context).scaffoldBackgroundColor
//                     ),
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.all(
//                           Radius.circular(500)),
//                       child:
//                       Image.memory(base64Decode(posts[index].imageEncode ?? "")),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           if(posts[index].personLike!.isNotEmpty)
//             const SizedBox(
//               width: constantPadding * 0.5,),
//           if(posts[index].personLike!.isNotEmpty)
//             Text(posts[index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId) && posts[index].personLike!.length>3?"yours & ${posts[index].personLike!.length-1} others likes":
//             posts[index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId) && posts[index].personLike!.length==1? "only yours like":
//             posts[index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId) && posts[index].personLike!.length==2? "yours & 1 other likes":" ${posts[index].personLike!.length} likes"),
//           const SizedBox(
//             height: constantPadding * 0.5,),
//           Row(
//             children: [
//               GestureDetector(
//                 child: Image.asset(posts[index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId)?heartfilled:heart, scale: 1.4,),
//                 onTap: () async {
//                   if(posts[index].personLike!.contains(MyInheritedWidget.of(context)!.loggedInUser!.userId)) {
//                     try {
//                       var response = await http
//                           .post(
//                           Uri.parse(
//                               "${MyInheritedWidget
//                                   .of(
//                                   context)!
//                                   .url}dislike.php"),
//                           body: {
//                             "post": posts[index]
//                                 .postId,
//                             "person": MyInheritedWidget
//                                 .of(context)!
//                                 .loggedInUser!
//                                 .userId,
//                             "toUser": posts[index]
//                                 .userId
//                           });
//                       print(response.body);
//                     } catch (e) {
//                       print(e);
//                     }finally{
//                       setState(() {
//                         posts[index].personLike!.remove(MyInheritedWidget.of(context)!.loggedInUser!.userId);
//                       });
//                       MyInheritedWidget.of(context)!.getPosts(posts);
//                     }
//                   }else{
//                     try {
//                       var response = await http
//                           .post(
//                           Uri.parse(
//                               "${MyInheritedWidget
//                                   .of(
//                                   context)!
//                                   .url}like.php"),
//                           body: {
//                             "post": posts[index]
//                                 .postId,
//                             "person": MyInheritedWidget
//                                 .of(context)!
//                                 .loggedInUser!
//                                 .userId,
//                             "toUser": posts[index]
//                                 .userId
//                           });
//                       print(response.body);
//                     } catch (e) {
//                       print(e);
//                     }finally{
//                       setState(() {
//                         posts[index].personLike!.add(MyInheritedWidget.of(context)!.loggedInUser!.userId!);
//                       });
//                       MyInheritedWidget.of(context)!.getPosts(posts);
//                     }
//                   }
//                 },
//               ),
//               const SizedBox(
//                 width: constantPadding * 0.5,),
//               Image.asset(chat, scale: 1.4,),
//               const SizedBox(
//                 width: constantPadding * 0.5,),
//               Image.asset(send, scale: 1.4,),
//               Expanded(child: Container()),
//               Image.asset(save, scale: 1.4,),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

