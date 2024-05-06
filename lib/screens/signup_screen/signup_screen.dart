import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:socialhub/app_state.dart';
import 'package:socialhub/common_widgets/basic_information.dart';
import 'package:socialhub/common_widgets/design.dart';
import 'package:socialhub/common_widgets/upload_image.dart';
import 'package:http/http.dart' as http;
import 'package:socialhub/color.dart';
import 'package:socialhub/common_widgets/button.dart';
import 'package:socialhub/common_widgets/logo.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../common_widgets/input_field.dart';
import '../../common_widgets/responsive.dart';
import '../../toast/toast.php.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  XFile? profileImage;
  XFile? coverImage;
  var heading = [
    "Basic Information",
    "Upload Image",
    "Bio & Sign Up",
    "Follow",
    "Sign Up"
  ];
  TextEditingController name = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  int _index = 0;
  bool loading = false;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF292929),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: logoColor,
            )),
        title: GradientText(
          "Let's SignUp",
          colors: const [logoColor, Colors.white],
          style: GoogleFonts.poppins(
              fontSize: 35, fontWeight: FontWeight.bold, color: logoColor),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Design(),
          if (!Responsive.isMobile(context))
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  right: 0,
                  top: 30,
                  child: Transform.translate(
                    offset: Offset(
                        Responsive.isMobile(context)
                            ? -((MediaQuery.of(context).size.width - 85) / 2) *
                                controller.value
                            : -((MediaQuery.of(context).size.width -
                                        (_index == 0 ? 95 : 40)) /
                                    2) *
                                controller.value,
                        0),
                    child: Opacity(
                      child: Stack(
                        children: [
                          Text(
                            heading[_index],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    fontSize:
                                        Responsive.isMobile(context) ? 25 : 30,
                                    fontWeight: FontWeight.bold),
                          ),
                          Text(
                            heading[_index],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: logoColor,
                                    fontSize:
                                        Responsive.isMobile(context) ? 24 : 29,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      opacity: controller.value,
                    ),
                  ),
                );
              },
            ),
          if (!Responsive.isMobile(context))
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  bottom: 0,
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(
                          0,
                          ((MediaQuery.of(context).size.height -
                                      (_index == 0 ? 600 : 400)) /
                                  2) *
                              -1 *
                              controller.value),
                      child: Opacity(
                        child: function[_index],
                        opacity: controller.value,
                      ),
                    ),
                  ),
                );
              },
            ),
          if (Responsive.isMobile(context))
            Stepper(
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 200),
                );
              },
              margin: const EdgeInsets.only(top: 5),
              currentStep: _index,
              steps: [
                Step(
                    title: Text(
                      heading[0],
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: logoColor),
                    ),
                    content: function[0]),
                Step(
                    title: Text(heading[1],
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: logoColor)),
                    content: function[1]),
                Step(
                    title: Text(heading[2],
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: logoColor)),
                    content: function[2]),
                // Step(title: Text(heading[3],style: Theme.of(context).textTheme.subtitle1!.copyWith(color: logoColor)),
                //   content: function[3],
                // ),
                // Step(
                //   title: Text(heading[4],style: Theme.of(context).textTheme.subtitle1!.copyWith(color: logoColor)),
                //   content: SocialHubButton(text: 'Sign Up', onTap: signUp,width: Responsive.isMobile(context)?330:400,loading: loading,)
                // ),
              ],
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: SocialHub(
              factor: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signUp() async {
    if (userName.text.isNotEmpty) {
      setState(() {
        loading = true;
      });
      try {
        Map<String, dynamic> variable = {
          'userName': name.text,
          'userUsername': userName.text,
          'userEmail': email.text,
          'userPassword': password.text,
          'userPhone': number.text,
          'userProfileImageLink':
              base64Encode(File(profileImage!.path).readAsBytesSync()),
          'userProfileImageLinkName':
              File(profileImage!.path).uri.pathSegments.last,
          'userCoverPhotoLink':
              base64Encode(File(coverImage!.path).readAsBytesSync()),
          'userCoverPhotoLinkName':
              File(coverImage!.path).uri.pathSegments.last,
          'userBio': bio.text,
        };
        var response = await http.post(
            Uri.parse("${MyInheritedWidget.of(context)!.url}signUp.php"),
            body: variable);
        print(response.body);
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          loading = false;
        });
        HubToast.shToast(context, "Registered successfully", 80);
        name.text = '';
        userName.text = '';
        email.text = '';
        password.text = '';
        number.text = '';
        name.text = '';
        bio.text = '';
        profileImage = null;
        coverImage = null;
      }
    } else {
      HubToast.shToast(context, "You are registered.", 90);
    }
  }

  List<Widget> get function => [
        BasicInfo(
          name: name,
          userName: userName,
          password: password,
          email: email,
          number: number,
          confirmPassword: confirmPassword,
          function: animation,
        ),
        UploadImage(
            coverImage: coverImage,
            profileImage: profileImage,
            previous: backAnimation,
            next: animation,
            profilePhoto: () async {
              if (!Responsive.isMobile(context)) {
                final xtypegroup =
                    XTypeGroup(label: 'Image', extensions: ["png", "jpg"]);
                final file = await openFile(acceptedTypeGroups: [xtypegroup]);
                setState(() {
                  profileImage = file;
                });
              } else {
                final imagepicker = ImagePicker();
                final file =
                    await imagepicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  profileImage = file;
                });
              }
            },
            coverPhoto: () async {
              if (!Responsive.isMobile(context)) {
                final xtypegroup = XTypeGroup(
                    label: 'Image', extensions: ["png", "jpg", 'jpeg']);
                final file = await openFile(acceptedTypeGroups: [xtypegroup]);
                setState(() {
                  coverImage = file;
                });
              } else {
                final imagepicker = ImagePicker();
                final file =
                    await imagepicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  coverImage = file;
                });
              }
            }),
        Form(
          child: Builder(builder: (context) {
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              spacing: 40,
              children: [
                InputField(
                  isPassword: false,
                  hintText: "Bio",
                  maxLine: 6,
                  controller: bio,
                  validator: (value) {
                    value = value ?? "";
                    if (value.isEmpty) {
                      return "Bio must not be empty";
                    }
                    return null;
                  },
                ),
                Wrap(
                  spacing: 25,
                  direction: Axis.horizontal,
                  children: [
                    SocialHubButton(
                      onTap: () {
                        backAnimation();
                      },
                      text: "Previous",
                      width: Responsive.isMobile(context) ? 150 : 215,
                      height: 35,
                    ),
                    SocialHubButton(
                      onTap: () {
                        if (Form.of(context)?.validate() ?? false) {
                          animation();
                        }
                      },
                      text: "Next",
                      width: Responsive.isMobile(context) ? 150 : 215,
                      height: 35,
                    ),
                  ],
                ),
                SocialHubButton(
                  text: 'Sign Up',
                  onTap: signUp,
                  width: Responsive.isMobile(context) ? 330 : 400,
                  loading: loading,
                )
              ],
            );
          }),
        ),
        // FollowForm(next: animation,previous: backAnimation,function:(int index){
        //   print(follow);
        //     if(follow.contains(MyInheritedWidget.of(context)!.users![index].userId)){
        //       follow.remove(MyInheritedWidget.of(context)!.users![index].userId);
        //     }else{
        //       follow.add(MyInheritedWidget.of(context)!.users![index].userId ?? '');
        //     }
        // }),
      ];

  animation() {
    setState(() {
      controller.value = 0;
    });
    if (_index == 2) {
    } else {
      setState(() {
        ++_index;
      });
    }
    controller.forward();
  }

  backAnimation() {
    setState(() {
      controller.value = 0;
    });
    if (_index == 0) {
    } else {
      setState(() {
        --_index;
      });
    }
    controller.forward();
  }
}
