import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:socialhub/app_state.dart';
import 'package:socialhub/common_widgets/button.dart';
import 'package:socialhub/common_widgets/logo.dart';
import 'package:socialhub/constants.dart';
import 'package:socialhub/screens/home/home_widget/home_input.dart';
import 'package:socialhub/screens/home/home_widget/profile_image.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common_widgets/responsive.dart';
import '../../toast/toast.php.dart';

class PostScreen extends StatefulWidget {
  String?  imageLink, cap;
  String  isprofile;
  String? post_id;
  PostScreen({Key? key, required this.isprofile,this.cap,this.imageLink, this.post_id}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
with SingleTickerProviderStateMixin{
  bool loading = false;
  TextEditingController caption = TextEditingController();
  String? imageLink;
  AnimationController? controller;
  @override
  void initState() {
    controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 500));
    if(widget.post_id  != null){
      caption.text=widget.cap ?? "";
      imageLink = widget.imageLink;
      if(imageLink != null && imageLink != "" && !imageLink!.contains('null')){
        controller!.value = 1;
      }
    }
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
            Navigator.pushNamed(context, "/home");
          },
            child: Icon(Icons.arrow_back_ios_outlined,color: Theme.of(context).textTheme.headline5!.color,)
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
            child: SocialHubButton(onTap: () async {
              if(widget.post_id == null) {
                if (imageLink != null || caption.text.isNotEmpty) {
                  setState(() {
                    loading = true;
                  });
                  try {
                    var response = await http.post(
                        Uri.parse("${MyInheritedWidget.of(context)!
                            .url}dopost.php"),
                        body: {
                          "userId": MyInheritedWidget.of(context)!.loggedInUser!
                              .userId,
                          "caption": caption.text,
                          "image": imageLink != null ? File(imageLink!).uri
                              .pathSegments.last : "",
                          "imageDecode": imageLink != null ? base64Encode(File(
                              imageLink!).readAsBytesSync()) : "",
                        });
                    print(response.body);
                    HubToast.shToast(
                        context, "Dear User! your post is just posted.", 100);
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      loading = false;
                      caption.text = "";
                      imageLink = null;
                    });
                    if (controller!.isCompleted) {
                      controller!.reverse();
                    }
                  }
                } else {
                  HubToast.shToast(
                      context, "Dear User! your post is incomplete.", 100);
                }
              }else{
                setState(() {
                  loading = true;
                });
                try {
                  var response = await http.post(
                      Uri.parse("${MyInheritedWidget.of(context)!
                          .url}updatepost.php"),
                      body: {
                        "post_id":widget.post_id,
                        "userId": MyInheritedWidget.of(context)!.loggedInUser!
                            .userId,
                        "caption": caption.text,
                        "image": imageLink != null && !imageLink!.contains('null')? File(imageLink!).uri
                            .pathSegments.last : "",
                        "imageDecode": imageLink != null ? base64Encode(File(
                            imageLink!).readAsBytesSync()) : "",
                      });
                  print(response.body);
                  HubToast.shToast(
                      context, "Dear User! your post is updated.", 100);
                } catch (e) {
                  print(e);
                  HubToast.shToast(
                      context, "Dear User! we face some problem.", 100);
                } finally {
                  setState(() {
                    loading = false;
                    caption.text = "";
                    imageLink = null;
                  });
                  if (controller!.isCompleted) {
                    controller!.reverse();
                  }
                }
              }
            }, text: widget.post_id == null? 'Post':'Upload',width: 100,height: 40,loading: loading,),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: constantPadding,),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container()),
                SizedBox(
                  width: Responsive.isMobile(context)?325:450,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: ProfileImage(user: MyInheritedWidget.of(context)!.loggedInUser!),
                          title: Text(MyInheritedWidget.of(context)!.loggedInUser!.userName!),
                        ),
                        const Divider(),
                        HomeInput(hinttext: "What's in your mind...?", controller: caption,maxline:5,),
                        AnimatedBuilder(
                          animation: controller!,
                          builder: (context,child) {
                            return Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                      decoration:BoxDecoration(
                                        borderRadius:   BorderRadius.all(
                                            Radius.circular(widget.isprofile!='1'?20:500)),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Container(
                                        height:300,
                                        width:widget.isprofile!='1'?double.infinity:300,
                                        margin:  EdgeInsets.all(widget.isprofile!='1'?20:500),
                                        padding:  EdgeInsets.all(widget.isprofile!='1'?20:500),
                                        decoration:BoxDecoration(
                                            borderRadius:  const BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Theme.of(context).scaffoldBackgroundColor
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          child: imageLink==null || imageLink == "" || imageLink!.contains("null") ?
                                              null:
                                          Image.memory(base64Decode(base64Encode(File(imageLink ?? "").readAsBytesSync()))),
                                        ),
                                      ),
                                    ),
                            Transform.translate(
                            offset: Offset(230*controller!.value,150*controller!.value),
                            child: GestureDetector(
                                  child:  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration:  BoxDecoration(
                                      color: Colors.white,
                                      boxShadow:gradient(context).map((e) => BoxShadow(color: e,blurRadius: 0.9)).toList(),
                                      borderRadius: const BorderRadius.all( Radius.circular(500))
                                    ),
                                    child: const Icon(Icons.image,
                                      color: Colors.black,),
                                  ),
                                  onTap: () async {
                                    if(controller!.isDismissed){
                                      controller!.forward();
                                    }
                                    if(!Responsive.isMobile(context)) {
                                      final xtypegroup = XTypeGroup(
                                          label: 'Image',
                                          extensions: ["png", "jpg"]
                                      );
                                      final file = await openFile(
                                          acceptedTypeGroups: [xtypegroup]);
                                      setState(() {
                                        imageLink = file?.path;
                                      });
                                    }else{
                                      final imagepicker = ImagePicker();
                                      final file = await imagepicker.pickImage(source: ImageSource.gallery);
                                      setState(() {
                                        imageLink = file?.path;
                                      });

                                    }
                                    if(imageLink==null){
                                      controller!.reverse();
                                    }
                                  },
                                ),
                            ),
                                if(imageLink!=null && imageLink!='' && !imageLink!.contains('null'))
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        imageLink = null;
                                      });
                                      controller!.reverse();
                                    },
                                    child: const Icon(Icons.cancel, color: Colors.black,
                                      ),
                                  ),
                                )
                              ]
                            );
                          }
                        )
                      ],
                    ),
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
