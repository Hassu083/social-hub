import 'package:socialhub/Admin_site/admin_dashboard/admindashboard.dart';
import 'package:socialhub/app_state.dart';
import 'package:socialhub/models/post/post.dart';
import 'package:socialhub/screens/Reel_screen/reelsreen.dart';
import 'package:socialhub/screens/Status_screen/status_screen.dart';
import 'package:socialhub/screens/admin_login.dart';
import 'package:socialhub/screens/home/home_screen/home.dart';
import 'package:socialhub/screens/home/home_screen/notification.dart';
import 'package:socialhub/screens/home/home_screen/request.dart';
import 'package:socialhub/screens/login_screen/login_screen.dart';
import 'package:socialhub/screens/messanger/messagePerson.dart';
import 'package:socialhub/screens/messanger/messanger.dart';
import 'package:socialhub/screens/post/open_post.dart';
import 'package:socialhub/screens/postScreen/post_screen.dart';
import 'package:socialhub/screens/profile/open_profile.dart';
import 'package:socialhub/screens/review/review.dart';
import 'package:socialhub/screens/signup_screen/signup_screen.dart';
import 'package:socialhub/screens/splash_screen/splash_screen.dart';
import 'package:socialhub/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: InstaTheme.light,
        darkTheme: InstaTheme.dark,
        themeMode: ThemeMode.system,
        onGenerateRoute: (setting){
          var screen = {
            "/login":LoginScreen(),
            "/signUp":SignUpScreen(),
            "/adminLogin":AdminLogin(),
            "/adminDashboard":AdminDashboard(),
          "/home":HomeScreen(),
          };
          if(setting.name == "/message"){
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>MessagePerson(idtoUser: arguments['idtoUser']));
          }
          if(setting.name == "/request"){
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>FriendRequest(idtoUser: arguments['idtoUser'],saveOrUnsave: arguments['saveOrUnsave'], likeOrDislike: arguments['likeOrDislike'], openPost: arguments['openPost'], sharePost: arguments['sharePost'], comment: arguments['comment']));
          }
          if(setting.name == "/messanger"){
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>Messanger(idtoUser: arguments['idtoUser']));
          }
          if(setting.name == "/Notification"){
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>Notification1(idtoUser: arguments['idtoUser']));
          }
          if(setting.name == "/reviews"){
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>Reviews(idtoUser: arguments['idtoUser']));
          }
          if(setting.name == "/openprofile"){
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>OpenProfile(saveOrUnsave: arguments['saveOrUnsave'],id: arguments['id'], likeOrDislike: arguments['likeOrDislike'], openPost: arguments['openPost'], sharePost: arguments['sharePost'], idtoUser: arguments['idtoUser'], comment: arguments['comment']));
          }
          if(setting.name == "/status"){
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>StatusScreen(status: arguments['status'], index: arguments['index'], idtoUser: arguments['idtoUser']));
          }if(setting.name == "/reel"){
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>ReelScreen(reel: arguments['status'], index: arguments['index'], idtoUser: arguments['idtoUser']));
          }if(setting.name == "/openpost") {
            Map<String, dynamic> arguments = setting.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_)=>PostWidget(saveOrUnsave: arguments['saveOrUnsave'], function: arguments['function'],likes: arguments['likes'],index: arguments['index'],sharePost: arguments['share'],comment: arguments['comment'],));
          }else if(setting.name=="/post"){
            Map<String, String?> arguments = setting.arguments as Map<String, String?>;
            return MaterialPageRoute(builder: (_)=>PostScreen(isprofile: arguments["isprofile"]! ,
            imageLink: arguments['imageLink'],cap: arguments['cap'],post_id:arguments['post']));
          }
          return MaterialPageRoute(builder: (_)=>screen[setting.name] ?? SplashScreen());
        },
      ),
    );
  }
}