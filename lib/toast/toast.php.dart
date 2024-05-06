import 'package:socialhub/color.dart';
import 'package:socialhub/common_widgets/logo.dart';
import 'package:socialhub/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class HubToast{

  static shToast(BuildContext context, String message,double height){
      showDialog(context: context
          , builder: (context){
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(10))
                ),
                contentPadding: const EdgeInsets.all(0),
                content: Container(
                  width: 200,
                  height: height,
                  decoration: const BoxDecoration(
                    color: logoColor,
                    borderRadius:  BorderRadius.all(Radius.circular(10))
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SocialHub(factor: 0.4,color: const Color(0xFF2697FF),),
                      const SizedBox(height: constantPadding*0.5,),
                      Text(message, style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black
                          ),),
                    ],
                  ),
                ),
              );
          }
      );
  }

}