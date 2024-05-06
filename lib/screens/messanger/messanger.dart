import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../app_state.dart';
import '../../color.dart';
import '../../common_widgets/logo.dart';
import '../../models/user/user.dart';
import '../home/home_widget/home_input.dart';
import '../home/home_widget/profile_image.dart';
import 'package:http/http.dart' as http;

class Messanger extends StatefulWidget {
  User Function({String  id}) idtoUser;

   Messanger({Key? key,required this.idtoUser}) : super(key: key);

  @override
  State<Messanger> createState() => _MessangerState();
}

class _MessangerState extends State<Messanger> {
  TextEditingController controller = TextEditingController();
  List<User> search = [];
  Timer? timer;

  getWhoMessage() async {
    try {
      var response = await http.post(
          Uri.parse("${MyInheritedWidget.of(context)!.url}userforchat.php"),
          body: {
            "userId": MyInheritedWidget.of(context)!.loggedInUser!
                .userId,
          }
      );
      List<dynamic> json = jsonDecode(response.body);
        for (User j in search) {
          for (var i in json) {
            if (j.userId == i['userId']) {
              setState(() {
                search[search.indexOf(j)].msg = i['msg'];
              });
            } else {
              setState(() {
                search[search.indexOf(j)].msg = null;
              });
            }
          }
        }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0),
        (){
          setState(() {
            search = MyInheritedWidget.of(context)!.users!;
          });
          timer = Timer.periodic(Duration(seconds: 5), (timer) {
            getWhoMessage();
          });
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'messanger',
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF9EA),
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
                timer!.cancel();
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
                return ListTile(
                  onTap: (){
                    timer!.cancel();
                    Navigator.pushNamed(context, '/message',arguments: {'idtoUser':search[index]}).then((value){
                      timer = Timer.periodic(Duration(seconds: 5), (timer) {
                        getWhoMessage();
                      });
                    });
                    setState(() {
                      search[index].msg = null;
                    });
                    // timer = Timer.periodic(Duration(seconds: 5), (timer) {
                    //   getWhoMessage();
                    // });
                  },
                  title: Text(
                    search[index].userName ?? "", style: Theme
                      .of(context)
                      .textTheme
                      .headline5,),
                  subtitle: Text(search[index].userBio ?? "",
                    overflow: TextOverflow.ellipsis,),
                  leading: ProfileImage(user: search[index],),
                  trailing: search[index].msg != null?
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 14),
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.green
                    ),
                    child: Center(child: Text(search[index].msg ?? '',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10),),),
                  ):null,
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
      ),
    );
  }
}
