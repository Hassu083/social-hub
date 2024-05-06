import 'package:socialhub/common_widgets/logo.dart';
import 'package:flutter/material.dart';
import 'Profile_card.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(child: SocialHub(factor: 1,color: const Color(0xFF2697FF)),onTap: (){
          Navigator.pushNamed(context,'/adminLogin');
        },),
        const Spacer(flex: 2,),
        const ProfileCard(),
      ],
    );
  }
}