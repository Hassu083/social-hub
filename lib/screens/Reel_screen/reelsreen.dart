import 'dart:convert';
import 'dart:io';
import 'package:socialhub/screens/home/home_widget/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import '../../common_widgets/logo.dart';
import '../../common_widgets/responsive.dart';
import '../../constants.dart';
import '../../models/reel/reels.dart';
import '../../models/user/user.dart';

class ReelScreen extends StatefulWidget {
  List<Reel> reel;
  int index;
  User Function({String  id}) idtoUser;

  ReelScreen({Key? key,
    required this.reel,
    required this.index,
    required this.idtoUser
  }) : super(key: key);

  @override
  State<ReelScreen> createState() => _ReelScreen();
}

class _ReelScreen extends State<ReelScreen> {
  int index = 0;
  late BetterPlayerController _controller;


  @override
  void initState()  {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.memory,'',
      bytes: base64Decode(widget.reel[widget.index].video!).toList()    );
    _controller = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          fit: BoxFit.fitHeight,
          aspectRatio: 9/16
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width:double.infinity,
                                height: double.infinity,
                                child: AspectRatio(
                                  aspectRatio: 9/16,
                                  child: BetterPlayer(
                                        controller: _controller,
                                    ),
                                ),
                              ),
                              Positioned(child: ProfileImage(user: widget.idtoUser(id: widget.reel[index].userId!),),right: 0,top: 0,),
                            ],
                          ),
                ),
                const SizedBox(width: constantPadding*0.5,),
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