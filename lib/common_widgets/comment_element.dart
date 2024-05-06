import 'package:flutter/material.dart';

import '../models/user/user.dart';
import '../screens/home/home_widget/profile_image.dart';

class Comment extends StatelessWidget {
  User user;
  String comment;
  Color? color;
   Comment({Key? key,
     required this.user,
     required this.comment,
     this.color
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileImage(user: user,),
      title: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
            width: 200,
            decoration:  BoxDecoration(
                color: color ?? Colors.white,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(15),bottomLeft:  Radius.circular(15),bottomRight: Radius.circular(15))
            ),
            child: Text(
              comment,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
