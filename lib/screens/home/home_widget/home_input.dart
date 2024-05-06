import 'package:flutter/material.dart';

import '../../../color.dart';
import '../../../constants.dart';



class HomeInput extends StatelessWidget {
  String hinttext;
  void Function(String)? onchange;
  TextEditingController controller;
  Color? color;
  int? maxline;
  Widget? preffix, suffix;
  HomeInput({Key? key,
  required this.hinttext,
    required this.controller,
    this.color,
    this.preffix,
    this.suffix,
    this.onchange,
    this.maxline
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxline!=null? 150 : 50,
      padding: const EdgeInsets.only(left: constantPadding,right: constantPadding*0.5),
      decoration:  BoxDecoration(
          color: color==null ? isDarkMode(context)? logoColor : const Color(0xFFFFF9EA) : color,
          borderRadius: const BorderRadius.all( Radius.circular(50))
      ),
      child: TextField(
        controller: controller,
        maxLines: maxline,
        onChanged: onchange,
        style:  color!=null? Theme.of(context).textTheme.headline5 : Theme.of(context).textTheme.headline5!.copyWith(color: Colors.black),
        decoration: InputDecoration(
            hintStyle:  color!=null? Theme.of(context).textTheme.subtitle2 : Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.black) ,
            hintText: hinttext,
            prefixIcon: preffix,
            border: InputBorder.none,
            suffixIcon: suffix
            )
        ),
    );
  }
  bool isDarkMode(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }
}
