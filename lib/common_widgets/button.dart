import 'package:socialhub/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialHubButton extends StatelessWidget {
  Function() onTap;
  String text;
  double? width,height;
  Color? color;
  bool? loading;
   SocialHubButton({Key? key,
     this.width,
     this.height,
     this.loading,
    required this.onTap,
    required this.text,
     this.color
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width ?? 400,
          height: height ?? 60,
          padding: const EdgeInsets.all(5),
          decoration:   BoxDecoration(
            color:   color ?? logoColor,
            borderRadius:  const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: loading==null || loading==false ?Text(text,
              style: GoogleFonts.poppins(
                  fontSize: height!=null?10:20,
                  fontWeight: FontWeight.bold,
                  color: color==null? Theme.of(context).colorScheme.primary : Colors.white
              ),
            ): const CircularProgressIndicator(color: Colors.black,),
          )
      ),
    );
  }
}
