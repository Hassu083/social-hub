import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';

class SocialHub extends StatelessWidget {
  double factor;
  Color? color;
   SocialHub({required this.factor,
     this.color,
     Key? key}
       ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: [
        Container(
          padding:  EdgeInsets.symmetric(horizontal: 10*factor,vertical: 5*factor),
          decoration:  BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5*factor),bottomLeft:Radius.circular(5*factor) )
          ),
          child: Text("Social",
            style: GoogleFonts.arimo(
                fontWeight: FontWeight.bold,
                color: color!=null ? Colors.white: Theme.of(context).colorScheme.primary,
                fontSize: 30*factor
            ),),
        ),
        Container(
          padding:  EdgeInsets.symmetric(horizontal: 10*factor,vertical: 5*factor),
          decoration:  BoxDecoration(
              color: color ?? logoColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(5*factor),bottomRight:Radius.circular(5*factor) )
          ),
          child: Text("Hub",
            style: GoogleFonts.arimo(
                fontWeight: FontWeight.bold,
                color: color!=null ? Colors.black :Theme.of(context).primaryColor,
                fontSize: 30*factor
            ),),
        ),
      ],
    );
  }
}
