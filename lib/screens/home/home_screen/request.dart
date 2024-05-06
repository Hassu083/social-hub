import 'package:socialhub/app_state.dart';
import 'package:flutter/material.dart';

import '../../../color.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/logo.dart';
import '../../../constants.dart';
import '../../../models/post/comment.dart';
import '../../../models/post/post.dart';
import '../../../models/user/user.dart';
import '../home_widget/home_input.dart';
import '../home_widget/profile_image.dart';

class FriendRequest extends StatefulWidget {
  User Function({String  id}) idtoUser;
  Future<bool?> Function(int index) likeOrDislike, saveOrUnsave;
  Function(Post post) sharePost;
  Future<CommentModel?> Function(int index, String comment) comment;
  Function(int index)  openPost;
   FriendRequest({Key? key, required this.idtoUser,
     required this.comment,
     required this.saveOrUnsave,
     required this.likeOrDislike,
     required this.openPost,
     required this.sharePost}) : super(key: key);

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  TextEditingController controller = TextEditingController();
  List<User> search = [];
  List<bool> follow = [];

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0),
            (){
          setState(() {
            search = MyInheritedWidget.of(context)!.users!;
            follow = MyInheritedWidget.of(context)!.follow!;
          });
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 2),
            child: SocialHub(factor: 0.4),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: HomeInput(hinttext: 'Search',
            controller: controller,
            onchange: (str){
          print(str);
              List<User> search = [];
              for(var i in MyInheritedWidget.of(context)!.users!){
                if(i.userName!.toLowerCase().contains(str.toLowerCase())){
                  search.add(i);
                }
              }
              setState(() {
                this.search = search;
              });
              if(str.isEmpty){
                setState(() {
                  this.search = MyInheritedWidget.of(context)!.users!;
                });
              }
            },
            suffix: Container(child: const Icon(Icons.search),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(500)),
                  color: Theme
                      .of(context)
                      .primaryColor
              ),)
        ),
        centerTitle: false,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_outlined,color: Theme.of(context).textTheme.headline5!.color,)
        ),
      ),
      body: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .primaryColor,
        ),
        child: search != null ? ListView.separated(
            itemBuilder: (context, index) {
              int index1 = MyInheritedWidget.of(context)!.users!.indexOf(search[index]);
              return ListTile(
                onTap: (){
                  Navigator.pushNamed(context, "/openprofile",arguments: {"saveOrUnsave":widget.saveOrUnsave,"id": search[index].userId,"openPost":widget.openPost,"likeOrDislike":widget.likeOrDislike,"comment":widget.comment,"sharePost":widget.sharePost,"idtoUser":widget.idtoUser});
                },
                title: Text(
                  search[index].userName ?? "", style: Theme
                    .of(context)
                    .textTheme
                    .headline5,),
                subtitle: Text(search[index].userBio ?? "",
                  overflow: TextOverflow.ellipsis,),
                leading: ProfileImage(user: search[index],),
                trailing: SocialHubButton(
                  onTap: ()  {  },
                  color: follow[index1]
                      ? Colors.black
                      : null,
                  text: follow[index1]
                      ? "Following"
                      : "Follow",
                  height: 30,
                  width: 80,),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: search.length
        ) :
        const Center(
          child: CircularProgressIndicator(
            color: logoColor,),
        ),
      ),
    );
  }
}
