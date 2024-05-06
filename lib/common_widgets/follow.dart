import 'dart:convert';
import 'dart:ui';
import 'package:socialhub/app_state.dart';
import 'package:socialhub/common_widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../color.dart';
import '../constants.dart';
import '../models/user/user.dart';
import 'button.dart';
import 'package:http/http.dart' as http;

class FollowForm extends StatefulWidget {
  var next,previous,function;
  FollowForm({Key? key,
  required this.previous,
  required this.next,
  required this.function
  }) : super(key: key);

  @override
  State<FollowForm> createState() => _FollowFormState();
}

class _FollowFormState extends State<FollowForm> {
  List<User> users = [];
  List<bool> follow = [];
  bool isLoading = true;

  Future<void> getUsers() async{
    setState(() {
      isLoading = true;
    });
    try{
      var response = await http.get(Uri.parse("${MyInheritedWidget.of(context)!.url}getUser.php"));
      List<dynamic> json = jsonDecode(response.body);
      for(var i in json){
        follow.add(false);
        users.add(User.fromJson(i));
      }
    }catch(e){
      print(e);
    }finally{
      MyInheritedWidget.of(context)!.allUsers(users);
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  initState(){
    super.initState();
    Future.delayed(Duration(seconds: 0),
            (){
              getUsers();
            });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isMobile(context)?350:650,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        spacing: 30,
        children: [
          Container(
            width: Responsive.isMobile(context)?350:650,
            height: 300,
            padding: const EdgeInsets.all(10),
            decoration:  BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Theme.of(context).primaryColor,
                boxShadow: gradient(context).map((e) => BoxShadow(color: e,blurRadius: 0.9)).toList()
            ),
            child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Suggestion for you",
                          style:GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.subtitle1!.color),
                        ),
                        Expanded(child: Container()),
                        Text("See all",
                          style:GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: logoColor),
                        ),
                      ],
                    ),
                    Expanded(
                      child: !isLoading? ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          }),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: users.length,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemBuilder: (context, index){
                              return Container(
                                width: 180,
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                decoration:  BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    boxShadow: gradient(context).map((e) => BoxShadow(color: e,blurRadius: 0.9)).toList()
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          child: users[index].coverImage!= null? Image.memory(base64Decode(users[index].coverImage ?? ""),height: 100,width: double.infinity,fit: BoxFit.contain,):Image.asset(avatar,height: 100,width: double.infinity,fit: BoxFit.fill,),
                                        ),
                                        Positioned(
                                          top:6,
                                          right:6,
                                          child: GestureDetector(
                                              onTap:(){},
                                              child: GestureDetector(child: const Icon(Icons.cancel_outlined,color: Colors.black,),
                                              onTap: (){
                                                setState(() {
                                                  users.removeAt(index);
                                                  widget.function();
                                                });
                                              },
                                              )
                                          ),
                                        )
                                      ],
                                    ),
                                    ListTile(
                                      leading:Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(500)),
                                          color: Colors.white
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(500)),
                                          child: Container(color:Colors.white.withOpacity(0.021),
                                              child: users[index].profileImage!=null? Image.memory(base64Decode(users[index].profileImage ?? ""),height: 50,width: 50,) : Image.asset(avatar,height: 50,width: 50,)
                                          ),
                                        ),
                                      ),
                                      title:Text(users[index].userName ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.arimo(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                            color: Colors.black
                                        ),
                                      ) ,
                                      subtitle:Text(users[index].userBio ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.arimo(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                        ),
                                      ) ,
                                    ),
                                    Expanded(child: Container()),
                                    SocialHubButton(
                                      onTap: (){
                                        setState(() {
                                          follow[index] = true;
                                        });
                                      },
                                      text: follow[index]?"Following":"Follow",
                                      height: 30,
                                      width: 80,),
                                    Expanded(flex:2,child: Container())
                                  ],
                                ),
                              );
                            }, separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 10,);
                          },
                          ),
                        ):
                      Container(
                        color: Colors.white,
                        child: const Center(child:  CircularProgressIndicator(color: logoColor,)),
                      ),
                    ),
                  ],
                ),

          ),
          Wrap(
            spacing: 25,
            direction: Axis.horizontal,
            children: [
              SocialHubButton(
                onTap: (){
                  widget.previous();
                }
                , text: "Previous",
                width:Responsive.isMobile(context)?150:190,
                height: 35,),
              SocialHubButton(
                onTap: (){
                  widget.next();

                }
                , text: "Next",
                width:Responsive.isMobile(context)?150:190,
                height: 35,),
            ],
          ),
        ],
      ),
    );
  }
}