import 'package:socialhub/app_state.dart';
import 'package:flutter/material.dart';
import '../../../common_widgets/logo.dart';
import '../../../constants.dart';
import '../../../models/notification/notification.dart';
import '../../../models/user/user.dart';
import '../home_widget/profile_image.dart';

class Notification1 extends StatefulWidget {
  User Function({String  id}) idtoUser;
   Notification1({Key? key, required this.idtoUser}) : super(key: key);

  @override
  State<Notification1> createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .primaryColor,
          ),
          child: MyInheritedWidget.of(context)!.notifications != null?
          ListView.separated(
              itemBuilder: (context, index){
                User user = widget.idtoUser(id :MyInheritedWidget.of(context)!.notifications![index].fromUser!);
                return Container(
                  decoration: BoxDecoration(
                    color: MyInheritedWidget.of(context)!.notifications![index].readOrnot=='0'? Colors.black12 : Theme
                        .of(context)
                        .primaryColor,
                  ),
                  child: ListTile(
                    title: Text(
                      user.userName ?? "", style: Theme
                        .of(context)
                        .textTheme
                        .headline5,),
                    subtitle: Text(MyInheritedWidget.of(context)!.notifications![index].message ?? "",
                      overflow: TextOverflow.ellipsis,),
                    leading: ProfileImage(user: user,),
                    trailing: MyInheritedWidget.of(context)!.loggedInUser!.userId == 'admin'?
                    ProfileImage(user: widget.idtoUser(id: MyInheritedWidget.of(context)!.notifications![index].toUser!),): null,
                    onTap: () {},
                  ),
                );
              },
              separatorBuilder: (context, index){
                return  const Divider();
              },
              itemCount: MyInheritedWidget.of(context)!.notifications!.length
          ): const Center(child: CircularProgressIndicator(),)
      ),
    );
  }
}