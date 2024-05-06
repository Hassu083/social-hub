import 'dart:convert';
import 'dart:io';
import 'package:socialhub/app_state.dart';
import 'package:socialhub/models/user/user.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';


class ProfileImage extends StatelessWidget {
  User user;
  double? width, height;
   ProfileImage({Key? key,required this.user,this.width,this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          height: height ?? 50,
          width: width ?? 50,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(500)),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            height: height ?? 50,
            width: width ?? 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(500)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(500)),
              child: Image.memory(base64Decode(user.profileImage ?? MyInheritedWidget.of(context)!.loggedInUser?.profileImage ?? "")),
            ),
          ),
        ),
        if(height == null && user.online == '1')
        Positioned(
          bottom: 6,
          right: -3,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(50))
              ),
            ),
          ),
        )
      ],
    );
  }
}
