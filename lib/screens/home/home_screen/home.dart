import 'dart:convert';
import 'dart:io';
import 'package:socialhub/models/notification/notification.dart';
import 'package:socialhub/models/post/comment.dart';
import 'package:socialhub/models/post/post.dart';
import 'package:socialhub/models/reel/reels.dart';
import 'package:socialhub/screens/home/home_widget/eachPost.dart';
import 'package:socialhub/screens/profile/profile.dart';
import 'package:socialhub/toast/toast.php.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:socialhub/color.dart';
import 'package:socialhub/common_widgets/logo.dart';
import 'package:socialhub/common_widgets/responsive.dart';
import 'package:socialhub/constants.dart';
import 'package:socialhub/screens/home/home_widget/home_input.dart';
import 'package:socialhub/screens/home/home_widget/menu.dart';
import 'package:socialhub/screens/home/home_widget/profile_image.dart';
import 'package:socialhub/screens/home/home_widget/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../app_state.dart';
import '../../../common_widgets/button.dart';
import '../../../models/status/status.dart';
import '../../../models/user/user.dart';
import '../../save/save.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  List<bool> follow = [];
  bool isLoading = true;
  bool isPostLoading = true;
  bool isNotificationLoading = true;
  TextEditingController controller = TextEditingController();
  List<MyNotification> notifications = [];
  bool openNotification = false;
  bool followRequest = false;
  bool profile = false;
  bool save = false;
  bool isStatusLoading = true;
  bool isReelsLoading = true;
  String? statusImage;
  List<Status> status = [];
  List<Reel> reel = [];
  List<User> search = [];
  bool reels = false;

  uploadStatus() async {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      try {
        var response = await http.post(
            Uri.parse("${MyInheritedWidget.of(context)!.url}uploadStatus.php"),
            body: {
              "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
              "image": base64Encode(File(statusImage!).readAsBytesSync()),
            });
        print(response.body);
        if (jsonDecode(response.body)['sucess']) {
          getStatus();
          HubToast.shToast(
              context, "Dear User! your status is successfully uploaded.", 100);
        } else {
          HubToast.shToast(
              context, "Dear User! your status image size is so large.", 100);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getStatus() async {
    setState(() {
      isStatusLoading = true;
      status = [];
    });
    try {
      var response = await http
          .get(Uri.parse("${MyInheritedWidget.of(context)!.url}getStatus.php"));
      List<dynamic> json = jsonDecode(response.body);
      for (var i in json) {
        if (MyInheritedWidget.of(context)!
                .loggedInUser!
                .following!
                .contains(Status.fromJson(i).userId) ||
            MyInheritedWidget.of(context)!.loggedInUser!.userId! ==
                Status.fromJson(i).userId) {
          setState(() {
            status.add(Status.fromJson(i));
          });
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isStatusLoading = false;
      });
    }
  }

  Future<void> getReels() async {
    setState(() {
      isReelsLoading = true;
      reel = [];
    });
    try {
      var response = await http
          .get(Uri.parse("${MyInheritedWidget.of(context)!.url}getreels.php"));
      List<dynamic> json = jsonDecode(response.body);
      for (var i in json) {
        setState(() {
          reel.add(Reel.fromJson(i));
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isReelsLoading = false;
      });
    }
  }

  Future<void> getUsers() async {
    setState(() {
      isLoading = true;
      users = [];
      MyInheritedWidget.of(context)!.loggedInUser!.online = "1";
    });
    try {
      var response = await http
          .get(Uri.parse("${MyInheritedWidget.of(context)!.url}getUser.php"));
      List<dynamic> json = jsonDecode(response.body);
      for (var i in json) {
        User user = User.fromJson(i);
        if (user.userId !=
            MyInheritedWidget.of(context)!.loggedInUser!.userId) {
          if (MyInheritedWidget.of(context)!
              .loggedInUser!
              .following!
              .contains(user.userId)) {
            follow.add(true);
          } else {
            follow.add(false);
          }
          users.add(User.fromJson(i));
        }
      }
    } catch (e) {
      print(e);
    } finally {
      MyInheritedWidget.of(context)!.allUsers(users);
      MyInheritedWidget.of(context)!.followNew(follow);
      setState(() {
        search = users;
        isLoading = false;
      });
    }
  }

  Future<void> getPosts() async {
    setState(() {
      isPostLoading = true;
      MyInheritedWidget.of(context)!.getPosts([]);
    });
    try {
      var response = await http
          .get(Uri.parse("${MyInheritedWidget.of(context)!.url}getpost.php"));
      List<dynamic> json = jsonDecode(response.body);
      for (var i in json) {
        setState(() {
          MyInheritedWidget.of(context)!.allPosts!.add(Post.fromJson(i));
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isPostLoading = false;
      });
    }
  }

  Future<void> getNotification() async {
    setState(() {
      isNotificationLoading = true;
      notifications = [];
    });
    try {
      var response = await http.get(Uri.parse(
          "${MyInheritedWidget.of(context)!.url}getNotification.php"));
      List<dynamic> json = jsonDecode(response.body);
      for (var i in json) {
        MyNotification notification = MyNotification.fromJson(i);
        if (MyInheritedWidget.of(context)!.loggedInUser!.userId! ==
                notification.toUser ||
            MyInheritedWidget.of(context)!.loggedInUser!.userId! == 'admin') {
          setState(() {
            notifications.add(notification);
          });
        }
      }
    } catch (e) {
      print(e);
    } finally {
      MyInheritedWidget.of(context)!.getNotification(notifications);
      setState(() {
        isNotificationLoading = false;
      });
    }
  }

  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      online();
      getUsers();
      getPosts();
      getNotification();
      getStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width < 1200
          ? SafeArea(
              child: Drawer(
                child: Menu(
                  functions: [
                    () {
                      setState(() {
                        openNotification = false;
                        followRequest = false;
                        profile = false;
                        save = false;
                      });
                    },
                    () {
                      setState(() {
                        openNotification = false;
                        followRequest = false;
                        profile = true;
                        save = false;
                      });
                    },
                    () {
                      setState(() {
                        openNotification = true;
                        followRequest = false;
                        profile = false;
                        save = false;
                      });
                      if (Responsive.isMobile(context)) {
                        Navigator.pushNamed(context, "/Notification",
                            arguments: {'idtoUser': idToUser});
                      }
                    },
                    () {
                      setState(() {
                        followRequest = true;
                        openNotification = false;
                        profile = false;
                        save = false;
                      });
                      if (Responsive.isMobile(context)) {
                        Navigator.pushNamed(context, "/request", arguments: {
                          "saveOrUnsave": saveOrUnsave,
                          "openPost": openPost,
                          "likeOrDislike": likesOrDisLike,
                          "comment": comment,
                          "sharePost": sharePost,
                          "idtoUser": idToUser
                        });
                      }
                    },
                    () {
                      setState(() {
                        openNotification = false;
                        followRequest = false;
                        profile = false;
                        save = true;
                      });
                    },
                    () {
                      setState(() {
                        openNotification = false;
                        followRequest = false;
                        profile = false;
                        save = false;
                        if (MyInheritedWidget.of(context)!
                                .loggedInUser!
                                .userId! ==
                            'admin') {
                          Navigator.pushNamed(context, "/adminDashboard");
                        } else {
                          offline();
                          Navigator.pushNamed(context, "/login");
                        }
                      });
                    },
                    () {
                      setState(() {
                        openNotification = false;
                        followRequest = false;
                        profile = false;
                        save = false;
                        Navigator.pushNamed(context, '/reviews',
                            arguments: {'idtoUser': idToUser});
                      });
                    }
                  ],
                ),
              ),
            )
          : null,
      backgroundColor:
          context.isDarkMode ? logoColor : const Color(0xFFFFF9EA), //FFFFF9EA
      body: Column(
        children: [
          SafeArea(
            child: Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(
                  horizontal: constantPadding, vertical: constantPadding * 0.5),
              child: Row(
                children: [
                  if (MediaQuery.of(context).size.width > 500)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.115,
                    ),
                  if (MediaQuery.of(context).size.width < 1200)
                    Builder(builder: (context) {
                      return GestureDetector(
                        child: const Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    }),
                  if (MediaQuery.of(context).size.width < 1200)
                    const SizedBox(
                      width: constantPadding * 0.5,
                    ),
                  SocialHub(factor: 0.6),
                  Expanded(child: Container()),
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 3,
                      child: HomeInput(
                          hinttext: 'Search',
                          controller: controller,
                          onchange: (str) {
                            List<User> search = [];
                            for (var i in users) {
                              if (i.userName!
                                  .toLowerCase()
                                  .contains(str.toLowerCase())) {
                                search.add(i);
                              }
                            }
                            setState(() {
                              this.search = search;
                            });
                            if (str.isEmpty) {
                              setState(() {
                                this.search =
                                    MyInheritedWidget.of(context)!.users!;
                              });
                            }
                          },
                          suffix: Container(
                            child: const Icon(Icons.search),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(500)),
                                color: Theme.of(context).primaryColor),
                          )),
                    ),
                  Expanded(child: Container()),
                  if (Responsive.isMobile(context))
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {},
                    ),
                  const SizedBox(
                    width: constantPadding * 0.5,
                  ),
                  ProfileImage(
                    user: MyInheritedWidget.of(context)!.loggedInUser!,
                  ),
                  if (MediaQuery.of(context).size.width > 500)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.115,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: constantPadding,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container()),
                if (MediaQuery.of(context).size.width >= 1200)
                  const SizedBox(
                    width: constantPadding,
                  ),
                if (MediaQuery.of(context).size.width >= 1200)
                  Container(
                      width: 280,
                      decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? logoColor.withOpacity(0.5)
                              : const Color(0xFFFFF9EA),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Menu(
                        functions: [
                          () {
                            setState(() {
                              openNotification = false;
                              followRequest = false;
                              profile = false;
                              save = false;
                            });
                          },
                          () {
                            setState(() {
                              openNotification = false;
                              followRequest = false;
                              profile = true;
                              save = false;
                            });
                          },
                          () {
                            setState(() {
                              openNotification = true;
                              followRequest = false;
                              profile = false;
                              save = false;
                            });
                            if (Responsive.isMobile(context)) {
                              Navigator.pushNamed(context, "/Notification",
                                  arguments: {'idtoUser': idToUser});
                            }
                          },
                          () {
                            setState(() {
                              followRequest = true;
                              openNotification = false;
                              profile = false;
                              save = false;
                            });
                            if (Responsive.isMobile(context)) {
                              Navigator.pushNamed(context, "/request",
                                  arguments: {
                                    "saveOrUnsave": saveOrUnsave,
                                    "openPost": openPost,
                                    "likeOrDislike": likesOrDisLike,
                                    "comment": comment,
                                    "sharePost": sharePost,
                                    "idtoUser": idToUser
                                  });
                            }
                          },
                          () {
                            setState(() {
                              openNotification = false;
                              followRequest = false;
                              profile = false;
                              save = true;
                            });
                          },
                          () {
                            setState(() {
                              openNotification = false;
                              followRequest = false;
                              profile = false;
                              save = false;
                              if (MyInheritedWidget.of(context)!
                                      .loggedInUser!
                                      .userId! ==
                                  'admin') {
                                Navigator.pushNamed(context, "/adminDashboard");
                              } else {
                                offline();
                                Navigator.pushNamed(context, "/login");
                              }
                            });
                          },
                          () {
                            setState(() {
                              openNotification = false;
                              followRequest = false;
                              profile = false;
                              save = false;
                              Navigator.pushNamed(context, '/reviews',
                                  arguments: {'idtoUser': idToUser});
                              openNotification = false;
                              followRequest = false;
                              profile = false;
                              save = false;
                            });
                          }
                        ],
                      )),
                if (!profile && !save)
                  Container(
                    width: Responsive.isMobile(context) ? 325 : 450,
                    height: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: constantPadding),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (MyInheritedWidget.of(context)!
                                        .loggedInUser!
                                        .userId !=
                                    'admin') {
                                  Navigator.pushNamed(context, "/post",
                                      arguments: {
                                        "post": null,
                                        "isprofile": "0",
                                        'imageLink': null,
                                        'cap': ""
                                      });
                                } else {
                                  HubToast.shToast(
                                      context, 'Admin cannot post', 90);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: const Text("What's in your mind...?"),
                              )),
                          const SizedBox(
                            height: constantPadding,
                          ),
                          SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      reels = false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: !reels
                                            ? logoColor
                                            : const Color(0xFFFFF9EA),
                                        border: reels
                                            ? Border.all(color: logoColor)
                                            : null),
                                    child: Center(
                                      child: Text(
                                        'Status',
                                        style: GoogleFonts.content(
                                            color: !reels
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )),
                                const SizedBox(
                                  width: constantPadding / 2,
                                ),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      getReels();
                                      reels = true;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: reels
                                            ? logoColor
                                            : const Color(0xFFFFF9EA),
                                        border: !reels
                                            ? Border.all(color: logoColor)
                                            : null),
                                    child: Center(
                                      child: Text(
                                        'Reels',
                                        style: GoogleFonts.content(
                                            color: reels
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: constantPadding,
                          ),
                          if (!reels)
                            SizedBox(
                              height: 160,
                              child: !isStatusLoading
                                  ? ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return index == 0
                                            ? StatusItem(
                                                profile: GestureDetector(
                                                  onTap: () async {
                                                    if (MyInheritedWidget.of(
                                                                context)!
                                                            .loggedInUser!
                                                            .userId !=
                                                        'admin') {
                                                      if (!(status
                                                              .map((e) =>
                                                                  e.userId)
                                                              .toList())
                                                          .contains(
                                                              MyInheritedWidget.of(
                                                                      context)!
                                                                  .loggedInUser!
                                                                  .userId)) {
                                                        final xtypegroup =
                                                            XTypeGroup(
                                                                label: 'Image',
                                                                extensions: [
                                                              "png",
                                                              "jpg"
                                                            ]);
                                                        final file = await openFile(
                                                            acceptedTypeGroups: [
                                                              xtypegroup
                                                            ]);

                                                        statusImage =
                                                            file?.path;
                                                        if (statusImage !=
                                                            null) {
                                                          uploadStatus();
                                                        }
                                                      } else {
                                                        HubToast.shToast(
                                                            context,
                                                            "Dear User! your status is already uploaded kindly wait for day.",
                                                            90);
                                                      }
                                                    } else {
                                                      HubToast.shToast(
                                                          context,
                                                          'Admin cannot put status',
                                                          90);
                                                    }
                                                  },
                                                  child: Container(
                                                    child:
                                                        const Icon(Icons.add),
                                                    color: logoColor,
                                                  ),
                                                ),
                                                status: Image.memory(
                                                  base64Decode(
                                                      MyInheritedWidget.of(
                                                              context)!
                                                          .loggedInUser!
                                                          .profileImage!),
                                                  fit: BoxFit.fitHeight,
                                                ))
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, "/status",
                                                      arguments: {
                                                        "status": status,
                                                        "index": index - 1,
                                                        "idtoUser": idToUser
                                                      });
                                                },
                                                child: StatusItem(
                                                    profile: Image.memory(
                                                      base64Decode(idToUser(
                                                              id: status[
                                                                      index - 1]
                                                                  .userId!)
                                                          .profileImage!),
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                    status: Image.memory(
                                                      base64Decode(
                                                          status[index - 1]
                                                                  .image ??
                                                              ""),
                                                      fit: BoxFit.fitHeight,
                                                    )),
                                              );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          width: constantPadding * 0.5,
                                        );
                                      },
                                      itemCount: status.length + 1)
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ),
                          if (reels)
                            SizedBox(
                              height: 160,
                              child: !isReelsLoading
                                  ? ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return index == 0
                                            ? StatusItem(
                                                profile: GestureDetector(
                                                  onTap: () async {
                                                    if (MyInheritedWidget.of(
                                                                context)!
                                                            .loggedInUser!
                                                            .userId !=
                                                        'admin') {
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        type: FileType.video,
                                                      );
                                                      if (result != null) {
                                                        PlatformFile file =
                                                            result.files.first;
                                                        try {
                                                          var response =
                                                              await http.post(
                                                                  Uri.parse(
                                                                      "${MyInheritedWidget.of(context)!.url}postreels.php"),
                                                                  body: {
                                                                "userId": MyInheritedWidget.of(
                                                                        context)!
                                                                    .loggedInUser!
                                                                    .userId,
                                                                "video": base64Encode(File(file
                                                                        .path
                                                                        .toString())
                                                                    .readAsBytesSync()),
                                                                "directory":
                                                                    file.name,
                                                              });
                                                          print(response.body);
                                                          HubToast.shToast(
                                                              context,
                                                              "Dear User! your reel is posted.",
                                                              100);
                                                        } catch (e) {
                                                          print(e);
                                                          HubToast.shToast(
                                                              context,
                                                              "Dear User! we face some problem.",
                                                              100);
                                                        }
                                                      }
                                                    } else {
                                                      HubToast.shToast(
                                                          context,
                                                          'Admin cannot put reels',
                                                          90);
                                                    }
                                                  },
                                                  child: Container(
                                                    child: const Icon(Icons
                                                        .video_call_outlined),
                                                    color: logoColor,
                                                  ),
                                                ),
                                                status: Image.memory(
                                                  base64Decode(
                                                      MyInheritedWidget.of(
                                                              context)!
                                                          .loggedInUser!
                                                          .profileImage!),
                                                  fit: BoxFit.fitHeight,
                                                ))
                                            : GestureDetector(
                                                onTap: () {
                                                  if (Responsive.isMobile(
                                                      context)) {
                                                    Navigator.pushNamed(
                                                        context, "/reel",
                                                        arguments: {
                                                          "status": reel,
                                                          "index": index - 1,
                                                          "idtoUser": idToUser
                                                        });
                                                  }
                                                },
                                                child: StatusItem(
                                                  profile: Image.memory(
                                                    base64Decode(idToUser(
                                                            id: reel[index - 1]
                                                                .userId!)
                                                        .profileImage!),
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                  status: Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Colors.black,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.video_call,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          width: constantPadding * 0.5,
                                        );
                                      },
                                      itemCount: reel.length + 1)
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ),
                          if (!Responsive.isMobile(context))
                            const SizedBox(
                              height: constantPadding,
                            ),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: 5,
                            ),
                          !isPostLoading &&
                                  MyInheritedWidget.of(context)!
                                      .allPosts!
                                      .isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return MyInheritedWidget.of(context)!
                                                .loggedInUser!
                                                .following!
                                                .contains(MyInheritedWidget.of(
                                                        context)!
                                                    .allPosts![index]
                                                    .userId) ||
                                            MyInheritedWidget.of(context)!
                                                    .allPosts![index]
                                                    .userId ==
                                                MyInheritedWidget.of(context)!
                                                    .loggedInUser!
                                                    .userId
                                        ? PostGUIItself(
                                            index: index,
                                            home: true,
                                            idtoUser: idToUser,
                                            likeOrDislike: likesOrDisLike,
                                            saveOrUnsave: saveOrUnsave,
                                            sharePost: sharePost,
                                            comment: comment,
                                          )
                                        : Container();
                                  },
                                  separatorBuilder: (context, index) {
                                    return MyInheritedWidget.of(context)!
                                                .loggedInUser!
                                                .following!
                                                .contains(MyInheritedWidget.of(
                                                        context)!
                                                    .allPosts![index]
                                                    .userId) ||
                                            MyInheritedWidget.of(context)!
                                                    .allPosts![index]
                                                    .userId ==
                                                MyInheritedWidget.of(context)!
                                                    .loggedInUser!
                                                    .userId
                                        ? const SizedBox(
                                            height: constantPadding,
                                          )
                                        : Container();
                                  },
                                  itemCount: MyInheritedWidget.of(context)!
                                          .allPosts
                                          ?.length ??
                                      0)
                              : isPostLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Center(
                                      child: Text("No Posts yet..!"),
                                    ),
                        ],
                      ),
                    ),
                  ),
                if (MediaQuery.of(context).size.width > 830)
                  if (!profile && !save)
                    Container(
                      color: context.isDarkMode
                          ? logoColor
                          : const Color(0xFFFFF9EA),
                      width: 330,
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                            clipBehavior: Clip.antiAlias,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              boxShadow: followRequest
                                  ? gradient(context)
                                      .map((e) =>
                                          BoxShadow(color: e, blurRadius: 0.9))
                                      .toList()
                                  : null,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                            ),
                            child: !isLoading
                                ? ListView.separated(
                                    itemBuilder: (context, index) {
                                      int index1 = users.indexOf(search[index]);
                                      return ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/openprofile",
                                              arguments: {
                                                "saveOrUnsave": saveOrUnsave,
                                                "id": users[index].userId,
                                                "openPost": openPost,
                                                "likeOrDislike": likesOrDisLike,
                                                "comment": comment,
                                                "sharePost": sharePost,
                                                "idtoUser": idToUser
                                              });
                                        },
                                        title: Text(
                                          search[index].userName ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                        subtitle: Text(
                                          search[index].userBio ?? "",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        leading: ProfileImage(
                                          user: search[index],
                                        ),
                                        trailing: SocialHubButton(
                                          onTap: () async {
                                            if (MyInheritedWidget.of(context)!
                                                    .loggedInUser!
                                                    .userId !=
                                                'admin') {
                                              setState(() {
                                                follow[index1] =
                                                    !follow[index1];
                                              });
                                              MyInheritedWidget.of(context)!
                                                  .followNew(follow);
                                              if (follow[index1]) {
                                                try {
                                                  var response = await http.post(
                                                      Uri.parse(
                                                          "${MyInheritedWidget.of(context)!.url}follow.php"),
                                                      body: {
                                                        "follower":
                                                            MyInheritedWidget.of(
                                                                    context)!
                                                                .loggedInUser!
                                                                .userId,
                                                        "following":
                                                            users[index1].userId
                                                      });
                                                  MyInheritedWidget.of(context)!
                                                      .loggedInUser!
                                                      .following!
                                                      .add(users[index1]
                                                          .userId!);
                                                  getUsers();
                                                  getPosts();
                                                  getStatus();
                                                  print(response.body);
                                                } catch (e) {
                                                  print(e);
                                                }
                                              } else {
                                                try {
                                                  var response = await http.post(
                                                      Uri.parse(
                                                          "${MyInheritedWidget.of(context)!.url}unfollow.php"),
                                                      body: {
                                                        "follower":
                                                            MyInheritedWidget.of(
                                                                    context)!
                                                                .loggedInUser!
                                                                .userId,
                                                        "following":
                                                            users[index1].userId
                                                      });
                                                  print(response.body);
                                                } catch (e) {
                                                  print(e);
                                                }
                                              }
                                            } else {
                                              HubToast.shToast(context,
                                                  'Admin cannot follow', 90);
                                            }
                                          },
                                          color: follow[index1]
                                              ? Colors.black
                                              : null,
                                          text: follow[index1]
                                              ? "Following"
                                              : "Follow",
                                          height: 30,
                                          width: 80,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider();
                                    },
                                    itemCount: search.length)
                                : const Center(
                                    child: CircularProgressIndicator(
                                      color: logoColor,
                                    ),
                                  ),
                          )),
                          const SizedBox(
                            height: constantPadding,
                          ),
                          Expanded(
                              child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: openNotification
                                        ? gradient(context)
                                            .map((e) => BoxShadow(
                                                color: e, blurRadius: 0.9))
                                            .toList()
                                        : null,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                  child: !isNotificationLoading
                                      ? ListView.separated(
                                          itemBuilder: (context, index) {
                                            User user = idToUser(
                                                id: notifications[index]
                                                    .fromUser!);
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: notifications[index]
                                                            .readOrnot ==
                                                        '0'
                                                    ? Colors.black12
                                                    : Theme.of(context)
                                                        .primaryColor,
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  user.userName ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                                subtitle: Text(
                                                  notifications[index]
                                                          .message ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                leading: ProfileImage(
                                                  user: user,
                                                ),
                                                trailing: MyInheritedWidget.of(
                                                                context)!
                                                            .loggedInUser!
                                                            .userId ==
                                                        'admin'
                                                    ? ProfileImage(
                                                        user: idToUser(
                                                            id: notifications[
                                                                    index]
                                                                .toUser!),
                                                      )
                                                    : null,
                                                onTap: () async {
                                                  if (MyInheritedWidget.of(
                                                              context)!
                                                          .loggedInUser!
                                                          .userId !=
                                                      'admin') {
                                                    try {
                                                      var response = await http
                                                          .post(
                                                              Uri.parse(
                                                                  "${MyInheritedWidget.of(context)!.url}readNotification.php"),
                                                              body: {
                                                            "notificationId":
                                                                notifications[
                                                                        index]
                                                                    .notificationid
                                                          });
                                                      print(response.body);
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                    setState(() {
                                                      notifications[index]
                                                          .readOrnot = "1";
                                                    });
                                                    MyInheritedWidget.of(
                                                            context)!
                                                        .getNotification(
                                                            notifications);
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider();
                                          },
                                          itemCount: notifications.length)
                                      : const Center(
                                          child: CircularProgressIndicator(
                                            color: logoColor,
                                          ),
                                        ))),
                        ],
                      ),
                    ),
                if (profile || save)
                  const SizedBox(
                    width: constantPadding,
                  ),
                if (profile)
                  Profile(
                      saveOrUnsave: saveOrUnsave,
                      userId:
                          MyInheritedWidget.of(context)!.loggedInUser!.userId!,
                      likeOrDislike: likesOrDisLike,
                      openPost: openPost,
                      sharePost: sharePost,
                      idtoUser: idToUser,
                      comment: comment),
                if (save)
                  SavePost(
                      saveOrUnsave: saveOrUnsave,
                      userId:
                          MyInheritedWidget.of(context)!.loggedInUser!.userId!,
                      likeOrDislike: likesOrDisLike,
                      openPost: openPost,
                      sharePost: sharePost,
                      idtoUser: idToUser,
                      comment: comment),
                if (MediaQuery.of(context).size.width > 500)
                  const SizedBox(
                    width: constantPadding,
                  ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
          ),
          const SizedBox(
            height: constantPadding,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/messanger',
                arguments: {'idtoUser': idToUser});
          },
          heroTag: 'messanger',
          child: const Center(
            child: Icon(
              Icons.message,
              color: Colors.white,
            ),
          )),
    );
  }

  bool isDarkMode(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  User idToUser({String id = "0"}) {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId == id) {
      return MyInheritedWidget.of(context)!.loggedInUser!;
    } else {
      for (User user in users) {
        if (user.userId == id) {
          return user;
        }
      }
    }
    return User();
  }

  openPost(int index) {
    Navigator.pushNamed(context, "/openpost", arguments: {
      "function": idToUser,
      "likes": likesOrDisLike,
      "index": index,
      "share": sharePost,
      "comment": comment
    });
  }

  Future<CommentModel?> comment(int index, String comment) async {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      String id;
      try {
        var response = await http.post(
            Uri.parse("${MyInheritedWidget.of(context)!.url}writeComment.php"),
            body: {
              "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
              "post_id": MyInheritedWidget.of(context)!.allPosts![index].postId,
              "person": MyInheritedWidget.of(context)!.allPosts![index].userId,
              "comment": comment
            });
        print(response.body);
        id = jsonDecode(response.body)["id"];
        return CommentModel(
            comment_id: id,
            userId: MyInheritedWidget.of(context)!.loggedInUser!.userId,
            post_id: MyInheritedWidget.of(context)!.allPosts![index].postId,
            comment: comment);
        setState(() {
          MyInheritedWidget.of(context)!.allPosts![index].comments!.add(
              CommentModel(
                  comment_id: id,
                  userId: MyInheritedWidget.of(context)!.loggedInUser!.userId,
                  post_id:
                      MyInheritedWidget.of(context)!.allPosts![index].postId,
                  comment: comment));
        });
      } catch (e) {
        print(e);
      }
    }
  }

  sharePost(Post post) async {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      try {
        var response = await http.post(
            Uri.parse("${MyInheritedWidget.of(context)!.url}sharePost.php"),
            body: {
              "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
              "caption": post.caption ?? "",
              "image": post.image ?? "",
              "postOwner": post.userId,
              'post_id': post.postId
            });
        print(response.body);
        if (jsonDecode(response.body)['success']) {
          getPosts();
          HubToast.shToast(context, "Shared successfully", 80);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool?> likesOrDisLike(int index) async {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      if (MyInheritedWidget.of(context)!
          .allPosts![index]
          .personLike!
          .contains(MyInheritedWidget.of(context)!.loggedInUser!.userId)) {
        try {
          var response = await http.post(
              Uri.parse("${MyInheritedWidget.of(context)!.url}dislike.php"),
              body: {
                "post": MyInheritedWidget.of(context)!.allPosts![index].postId,
                "person": MyInheritedWidget.of(context)!.loggedInUser!.userId,
                "toUser": MyInheritedWidget.of(context)!.allPosts![index].userId
              });
          print(response.body);
          return false;
          setState(() {
            MyInheritedWidget.of(context)!.allPosts![index].personLike!.remove(
                  MyInheritedWidget.of(context)!.loggedInUser!.userId,
                );
          });
        } catch (e) {
          print(e);
        }
      } else {
        try {
          var response = await http.post(
              Uri.parse("${MyInheritedWidget.of(context)!.url}like.php"),
              body: {
                "post": MyInheritedWidget.of(context)!.allPosts![index].postId,
                "person": MyInheritedWidget.of(context)!.loggedInUser!.userId,
                "toUser": MyInheritedWidget.of(context)!.allPosts![index].userId
              });
          print(response.body);
          return true;
          setState(() {
            MyInheritedWidget.of(context)!.allPosts![index].personLike!.add(
                  MyInheritedWidget.of(context)!.loggedInUser!.userId!,
                );
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<bool?> saveOrUnsave(int index) async {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      if (MyInheritedWidget.of(context)!
          .loggedInUser!
          .savePosts!
          .contains(MyInheritedWidget.of(context)!.allPosts![index].postId)) {
        try {
          var response = await http.post(
              Uri.parse("${MyInheritedWidget.of(context)!.url}unsave.php"),
              body: {
                "post_id":
                    MyInheritedWidget.of(context)!.allPosts![index].postId,
                "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
                "toUser": MyInheritedWidget.of(context)!.allPosts![index].userId
              });
          print(response.body);
          return false;
          setState(() {
            MyInheritedWidget.of(context)!.loggedInUser!.savePosts!.remove(
                  MyInheritedWidget.of(context)!.allPosts![index].postId,
                );
          });
        } catch (e) {
          print(e);
        }
      } else {
        try {
          var response = await http.post(
              Uri.parse("${MyInheritedWidget.of(context)!.url}save.php"),
              body: {
                "post_id":
                    MyInheritedWidget.of(context)!.allPosts![index].postId,
                "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
                "toUser": MyInheritedWidget.of(context)!.allPosts![index].userId
              });
          print(response.body);
          return true;
          setState(() {
            MyInheritedWidget.of(context)!.loggedInUser!.savePosts!.add(
                  MyInheritedWidget.of(context)!.allPosts![index].postId!,
                );
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }

  online() async {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      try {
        var response = await http.post(
            Uri.parse("${MyInheritedWidget.of(context)!.url}online.php"),
            body: {
              "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
            });
        print(response.body);
      } catch (e) {
        print(e);
      }
    }
  }

  offline() async {
    if (MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
      try {
        var response = await http.post(
            Uri.parse("${MyInheritedWidget.of(context)!.url}offline.php"),
            body: {
              "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
            });
        print(response.body);
      } catch (e) {
        print(e);
      }
    }
  }
}
