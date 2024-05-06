
import 'dart:io';

import 'package:socialhub/common_widgets/responsive.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'button.dart';

class UploadImage extends StatelessWidget {
  Function() previous,next;
  XFile? profileImage;
  XFile? coverImage;
  Function() profilePhoto,coverPhoto;
  UploadImage({Key? key,
    this.profileImage,
    this.coverImage,
    required this.profilePhoto,
  required this.coverPhoto,
    required this.previous,
    required this.next
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: coverImage==null? Image.asset(avatar,width: Responsive.isMobile(context)?330:500,height: Responsive.isMobile(context)?150:250,fit: BoxFit.fill,):
                Image.file(File(coverImage!.path),width: Responsive.isMobile(context)?330:500,height: Responsive.isMobile(context)?150:250,fit: BoxFit.fill,)
            ),
             Positioned(
               bottom: -80,
               child: Container(
                   padding: const EdgeInsets.all(1),
                   decoration: const BoxDecoration(
                     borderRadius:  BorderRadius.all(Radius.circular(500)),
                     color:Colors.white,
                   ),
                   child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(500)),
                          child: profileImage==null? Image.asset(avatar,height: Responsive.isMobile(context)?100:150,width: Responsive.isMobile(context)?100:150,):
                          Image.file(File(profileImage!.path),height: Responsive.isMobile(context)?100:150,width: Responsive.isMobile(context)?100:150,)
                      ),
               ),
             ),
          ],
        ),
        const SizedBox(height: 100,),
        Wrap(
          spacing: 25,
          direction: Axis.horizontal,
          children: [
            SocialHubButton(
              onTap: profilePhoto
              , text: "Select Profile Photo",
              width:Responsive.isMobile(context)?150:240,
              height: 35,),
            SocialHubButton(
              onTap: coverPhoto
              , text: "Select Cover Photo",
              width:Responsive.isMobile(context)?150:240,
              height: 35,),
          ],
        ),
        const SizedBox(height: constantPadding,),
        Wrap(
          spacing: 25,
          direction: Axis.horizontal,
          children: [
            SocialHubButton(
              onTap: (){
                previous();
              }
              , text: "Previous",
              width:Responsive.isMobile(context)?150:240,
              height: 35,),
            SocialHubButton(
              onTap: (){
                if(profileImage!=null && coverImage!=null){
                  next();
                }
              }
              , text: "Next",
              width:Responsive.isMobile(context)?150:240,
              height: 35,),
          ],
        )
      ],
    );
  }
}
