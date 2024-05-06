import 'dart:convert';

import 'package:socialhub/color.dart';
import 'package:socialhub/screens/home/home_widget/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common_widgets/logo.dart';
import '../../common_widgets/responsive.dart';
import '../../constants.dart';
import '../../models/status/status.dart';
import '../../models/user/user.dart';

class StatusScreen extends StatefulWidget {
  List<Status> status;
  int index;
  User Function({String  id}) idtoUser;

  StatusScreen({Key? key,
    required this.status,
    required this.index,
    required this.idtoUser
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  int index = 0;
  @override
  void initState() {
    setState(() {
      index = widget.index;
    });
    super.initState();
  }
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                if(!Responsive.isMobile(context))
                GestureDetector(
                  onTap: (){
                    if(index==0){
                      setState(() {
                        index = widget.status.length -1;
                      });
                    }else{
                      setState(() {
                        index--;
                      });
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(500)),
                      color: Colors.black
                    ),
                      child: const Icon(Icons.arrow_back_ios_outlined,color: Colors.white,)
                  ),
                ),
                const SizedBox(width: constantPadding*0.5,),
                Container(
                  width: Responsive.isMobile(context)?325:450,
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.all(constantPadding),
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white
                  ),
                  child:
                    IndexedStack(
                      index: index,
                      children: widget.status.map((e){
                        User user = widget.idtoUser(id:e.userId!);
                        return SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                              children: [
                                Image.memory(base64Decode(e.image!),fit: BoxFit.fitHeight,),
                                Positioned(child: ProfileImage(user: user,),right: 0,top: 0,),
                                if(Responsive.isMobile(context))
                                Positioned(
                                  left:-10,
                                  child: GestureDetector(
                                    onTap: (){
                                      if(index==0){
                                        setState(() {
                                          index = widget.status.length -1;
                                        });
                                      }else{
                                        setState(() {
                                          index--;
                                        });
                                      }
                                    },
                                    child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(500)),
                                            color: Colors.black
                                        ),
                                        child: const Icon(Icons.arrow_back_ios_outlined,color: Colors.white,)
                                    ),
                                  ),
                                ),
                                if(Responsive.isMobile(context))
                                Positioned(
                                  right: -10,
                                  child: GestureDetector(
                                    onTap: (){
                                      if(index==widget.status.length -1){
                                        setState(() {
                                          index = 0;
                                        });
                                      }else{
                                        setState(() {
                                          index++;
                                        });
                                      }
                                    },
                                    child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(500)),
                                            color: Colors.black
                                        ),
                                        child: const Icon(Icons.arrow_forward_ios,color: Colors.white,)
                                    ),
                                  ),
                                )
                              ],
                          ),
                        );
                      }).toList(),
                    )
                ),
                const SizedBox(width: constantPadding*0.5,),
                if(!Responsive.isMobile(context))
                GestureDetector(
                  onTap: (){
                    if(index==widget.status.length -1){
                      setState(() {
                        index = 0;
                      });
                    }else{
                      setState(() {
                        index++;
                      });
                    }
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(500)),
                          color: Colors.black
                      ),
                      child: const Icon(Icons.arrow_forward_ios,color: Colors.white,)
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
