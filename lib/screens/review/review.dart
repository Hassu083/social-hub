import 'dart:convert';

import 'package:socialhub/color.dart';
import 'package:socialhub/common_widgets/button.dart';
import 'package:socialhub/models/review_model/review_model.dart';
import 'package:socialhub/screens/home/home_widget/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../app_state.dart';
import '../../common_widgets/logo.dart';
import '../../constants.dart';
import '../../models/post/comment.dart';
import '../../models/post/post.dart';
import '../../models/user/user.dart';
import '../../toast/toast.php.dart';
import '../home/home_widget/home_input.dart';

class Reviews extends StatefulWidget {
  User Function({String  id}) idtoUser;
  Reviews({Key? key,required this.idtoUser,
  }) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  TextEditingController review = TextEditingController();
  int star = 0;
  bool loading = true;
  List<ReviewModel> reviews = [];

  getReviews() async {
    setState(() {
      loading = true;
      reviews = [];
    });
    try {
      var response = await http.get(
          Uri.parse("${MyInheritedWidget.of(context)!
              .url}getreview.php"),
      );
      print(response.body);
      for(var json in jsonDecode(response.body)){
        setState(() {
          reviews.add(ReviewModel.fromJson(json));
        });
      }
    } catch (e) {
      print(e);
    }finally{
      setState(() {
        loading = false;
      });
    }
  }
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0),(){
      getReviews();
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
              children: [
                Expanded(child: Container()),
                Container(
                  width: MediaQuery.of(context).size.width<500? 325 :  450,
                  height: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(height: constantPadding,),
                      SizedBox(
                        width: 440,
                        child: Row(
                          children: [
                            const SizedBox(height: constantPadding,),
                            Text('Give Star Rating',style: GoogleFonts.arimo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                            Expanded(child: Container()),
                        Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(child: Icon(Icons.star,
                                color: star+1 < index+1 ? Colors.black : logoColor),
                                onTap: () {
                                  setState(() {
                                    star = index;
                                  });
                                });
                          }),
                        ),
                            const SizedBox(height: constantPadding,),
                          ],
                        ),
                      ),
                      const SizedBox(height: constantPadding,),
                      SizedBox(width:440,child: HomeInput(controller: review, hinttext: 'write review...',color: Colors.white,preffix: const Icon(Icons.comment),maxline: 5,)),
                      const SizedBox(height: constantPadding,),
                      SocialHubButton(onTap: () async {
                        if(MyInheritedWidget.of(context)!.loggedInUser!.userId != 'admin') {
                          if(review.text.isNotEmpty) {
                            try {
                              var response = await http
                                  .post(
                                  Uri.parse(
                                      "${MyInheritedWidget
                                          .of(
                                          context)!
                                          .url}review.php"),
                                  body: {
                                    "stars": (star).toString(),
                                    "userId": MyInheritedWidget
                                        .of(context)!
                                        .loggedInUser!
                                        .userId,
                                    "review": review.text
                                  });
                              print(response.body);
                              setState(() {
                                reviews.add(ReviewModel(stars: star.toString(),
                                    userId: MyInheritedWidget
                                        .of(context)!
                                        .loggedInUser!
                                        .userId,
                                    review: review.text)
                                );
                                review.text = '';
                                star = 0;
                              });
                              HubToast.shToast(
                                  context, "Review submitted successfully.",
                                  90);
                            } catch (e) {
                              print(e);
                              HubToast.shToast(context, "Some problem", 90);
                            }
                          }else{
                            HubToast.shToast(context, "Kindly review first.", 90);
                          }
                        }else{
                          HubToast.shToast(context, "Admin cannot review", 90);
                        }
                      }, text: 'Submit',color: Colors.black38,width: 250,),
                      const SizedBox(height: constantPadding,),
                      Container(
                        width: double.infinity,
                        height: 380,
                        decoration: const BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                         child: !loading? ListWheelScrollView(
                           itemExtent: 80,
                           diameterRatio: 1.5,
                           children: reviews.map((e){
                             User user = widget.idtoUser(id: e.userId!);
                             return Container(
                               margin: const EdgeInsets.symmetric(vertical: 10),
                               padding: const EdgeInsets.all(8.0),
                               child: ListTile(
                                 leading: ProfileImage(user: user,),
                                 trailing: Rating(e.stars),
                                 title: Text(user.userName ?? "",style: Theme.of(context).textTheme.headline5,),
                                 subtitle:Text(e.review ?? "",style: Theme.of(context).textTheme.subtitle2,) ,
                               ),
                             );
                           }).toList()
                         ):
                        const Center(child: CircularProgressIndicator(),),
                      ),
                      const SizedBox(height: constantPadding,),
                    ],
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

  Widget Rating(String? star){
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(child: Icon(Icons.star,
            color: int.parse(star ?? '0')+1 < index+1 ? Colors.black : logoColor),
            );
      }),
    );
  }
}
