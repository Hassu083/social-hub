import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socialhub/common_widgets/button.dart';
import 'package:socialhub/common_widgets/design.dart';
import 'package:socialhub/common_widgets/input_field.dart';
import 'package:socialhub/common_widgets/logo.dart';
import 'package:socialhub/common_widgets/responsive.dart';
import 'package:socialhub/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../app_state.dart';
import '../../models/user/user.dart';
import '../../toast/toast.php.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userName = TextEditingController();
  List<User> users = [];
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool login = false;
  bool passwordTrue = true;
  bool usernameTrue = true;
  int admin_login = 0;

  Future<void> getUsersAndLogin() async {
    if (userName.text.isNotEmpty && password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      users = [];
      try {
        var response = await http
            .get(Uri.parse("${MyInheritedWidget.of(context)!.url}getUser.php"));
        List<dynamic> json = jsonDecode(response.body);
        for (var i in json) {
          if (i['userUsername'] == userName.text &&
              i['userPassword'] == password.text) {
            setState(() {
              passwordTrue = true;
              usernameTrue = true;
              login = true;
            });
            MyInheritedWidget.of(context)!.userLogin(User.fromJson(i));
            Navigator.pushNamed(context, "/home");
          } else if (i['userUsername'] == userName.text &&
              i['userPassword'] != password.text) {
            setState(() {
              passwordTrue = false;
            });
          } else if (i['userUsername'] != userName.text &&
              i['userPassword'] == password.text) {
            setState(() {
              usernameTrue = false;
            });
          } else {
            setState(() {
              passwordTrue = false;
              usernameTrue = false;
            });
          }
          users.add(User.fromJson(i));
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isLoading = false;
        });
        if (!login) {
          if (!passwordTrue && !usernameTrue) {
            HubToast.shToast(context, "Incorrect username or password.", 90);
          } else if (!passwordTrue) {
            HubToast.shToast(context, "Incorrect password.", 90);
          } else if (!usernameTrue) {
            HubToast.shToast(context, "Incorrect username.", 90);
          }
        }
        setState(() {
          passwordTrue = true;
          usernameTrue = true;
        });
      }
    } else {
      HubToast.shToast(
          context, "Dear User! kindly fill userName and password field.", 90);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          // Design(),
          SingleChildScrollView(
            child: Form(
              child: Builder(builder: (context) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      GestureDetector(
                        child: SocialHub(
                            factor: Responsive.isMobile(context) ? 1 : 1.35),
                        onTap: () {
                          admin_login++;
                          if (admin_login == 5) {
                            admin_login = 0;
                            Navigator.pushNamed(context, "/adminLogin");
                          }
                        },
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        direction: Axis.vertical,
                        spacing: 20,
                        children: [
                          InputField(
                            isPassword: false,
                            hintText: "Username",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            controller: userName,
                            validator: (value) {
                              value = value ?? "";
                              if (value.isEmpty) {
                                return "Username must not be empty";
                              }
                              return null;
                            },
                          ),
                          InputField(
                            isPassword: true,
                            hintText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            controller: password,
                            validator: (value) {
                              value = value ?? "";
                              if (value.isEmpty) {
                                return "Password must not be empty";
                              }
                              return null;
                            },
                          ),
                          GradientText(
                            "Forgot password ?",
                            colors: [Colors.black, Colors.black],
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF3797EF)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SocialHubButton(
                        onTap: () {
                          if (Form.of(context)!.validate()) {
                            getUsersAndLogin();
                          }
                        },
                        text: "Login",
                        width: Responsive.isMobile(context) ? 310 : 400,
                        loading: isLoading,
                        height: 40,
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: [
                          Text("Don’t have an account?",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .color)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/signUp");
                            },
                            child: GradientText(
                              "Sign up.",
                              colors: [Colors.black, Colors.black],
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF3797EF)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  online(String id) async {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      try {
        var response = await http.post(
            Uri.parse("${MyInheritedWidget.of(context)!.url}online.php"),
            body: {
              "userId": id,
            });
        print(response.body);
      } catch (e) {
        print(e);
      }
    }
  }
}
