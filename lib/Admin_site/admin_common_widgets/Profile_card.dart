
import 'package:socialhub/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      decoration:  BoxDecoration(
          color: const Color(0xFF2A2D3E),
          borderRadius: const BorderRadius.all( Radius.circular(10)),
          border: Border.all(color: Colors.white10)
      ),
      child: Row(
        children: [
          ClipRRect(child: Image.asset(avatar,width: 50,height: 50,),borderRadius: BorderRadius.all(Radius.circular(50)),),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16*0.5),
            child: Text("Hasnain ",
                style: GoogleFonts.arimo(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                )
            ),
          ),
          const Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }
}