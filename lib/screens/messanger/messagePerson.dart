import 'dart:convert';
import 'dart:async';
import 'package:socialhub/color.dart';
import 'package:socialhub/models/chat/chat.dart';
import 'package:socialhub/screens/home/home_widget/profile_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:socialhub/toast/toast.php.dart';
import '../../app_state.dart';
import '../../models/user/user.dart';
import '../home/home_widget/home_input.dart';

class MessagePerson extends StatefulWidget {
  User idtoUser;
  MessagePerson({Key? key, required this.idtoUser}) : super(key: key);

  @override
  State<MessagePerson> createState() => _MessagePersonState();
}

class _MessagePersonState extends State<MessagePerson> {
  List<Chat> chat = [];
  Timer? timer;
  TextEditingController msg = TextEditingController();

  postChat() async {
    if (msg.text.isNotEmpty) {
      try {
        var response = await http.post(
            Uri.parse("${MyInheritedWidget.of(context)!.url}sendMsg.php"),
            body: {
              "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
              "toUser": widget.idtoUser.userId,
              'message': msg.text
            });
        print(jsonDecode(response.body));
      } catch (e) {
        print(e);
      } finally {
        msg.text = '';
        getChat();
      }
    }else{
      HubToast.shToast(context, 'First write something', 70);
    }
  }

  Future<void> getChat() async {
    List<Chat> chat = [];
    try {
      var response = await http.post(
          Uri.parse("${MyInheritedWidget.of(context)!.url}getchat.php"),
          body: {
            "userId": MyInheritedWidget.of(context)!.loggedInUser!.userId,
            "toUser": widget.idtoUser.userId
          });
      List<dynamic> json = jsonDecode(response.body);
      for (var i in json) {
        Chat mychat = Chat.fromJson(i);
        chat.add(mychat);
      }
    } catch (e) {
      print('im getting');
    } finally {
      if (this.chat.isEmpty) {
        setState(() {
          this.chat = chat;
        });
      } else {
        for (int i=0; i<chat.length; i++) {
          if (i>=this.chat.length) {
            setState(() {
              this.chat.add(chat[i]);
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () {
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        getChat();
      });
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
        title: Row(
          children: [
            Hero(
              child: ProfileImage(user: widget.idtoUser),
              tag: 'profile',
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              widget.idtoUser.userName!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              timer!.cancel();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: Theme.of(context).textTheme.headline5!.color,
            )),
      ),
      body: Column(
        children: [
          chat.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    dragStartBehavior: DragStartBehavior.down,
                    reverse: true,
                    child: ListView.separated(
                        dragStartBehavior: DragStartBehavior.down,
                        shrinkWrap: true,
                        itemBuilder: (widget, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            child: Row(
                              children: [
                                if (chat[index].toUser !=
                                    MyInheritedWidget.of(context)!
                                        .loggedInUser!
                                        .userId)
                                  Expanded(child: Container()),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      width: 180,
                                      decoration: BoxDecoration(
                                          color: chat[index].toUser ==
                                                  MyInheritedWidget.of(context)!
                                                      .loggedInUser!
                                                      .userId
                                              ? logoColor
                                              : Colors.green,
                                          borderRadius: BorderRadius.only(
                                              topLeft: chat[index].toUser ==
                                                      MyInheritedWidget.of(context)!
                                                          .loggedInUser!
                                                          .userId
                                                  ? Radius.zero
                                                  : const Radius.circular(10),
                                              bottomRight: const Radius.circular(10),
                                              bottomLeft: const Radius.circular(10),
                                              topRight: chat[index].toUser !=
                                                      MyInheritedWidget.of(context)!
                                                          .loggedInUser!
                                                          .userId
                                                  ? Radius.zero
                                                  : const Radius.circular(10))),
                                      child: Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chat[index].message!,
                                            style: GoogleFonts.arimo(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(child: Container()),
                                                Text(
                                                  chat[index].time!,
                                                  style: GoogleFonts.arimo(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (widget, index) {
                          return Container();
                        },
                        itemCount: chat.length),
                  ),
                )
              : const Expanded(
                  child: Center(child: CircularProgressIndicator())),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(1.5),
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(
                color: logoColor,
                borderRadius: BorderRadius.all(Radius.circular(-500))),
            child: HomeInput(
              controller: msg,
              hinttext: 'lets talk...',
              color: Colors.white,
              preffix: const Icon(Icons.comment),
              suffix: GestureDetector(
                onTap: postChat,
                child: const Icon(
                  Icons.send,
                  color: logoColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
