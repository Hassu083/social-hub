import 'package:socialhub/color.dart';
import 'package:socialhub/common_widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class InputField extends StatefulWidget {
  bool isPassword;
  int? maxLine;
  String hintText;
  Icon? prefixIcon;
  TextEditingController controller;
  FormFieldValidator<String>? validator;
  Color? color;

  InputField({Key? key,
    required this.isPassword,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
    required this.validator,
    this.maxLine,
    this.color
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isPassword = false;
  @override
  void initState() {
    isPassword = widget.isPassword;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width:  !Responsive.isMobile(context) && widget.maxLine!=null? 450:  Responsive.isMobile(context)? 310: 400,
      height: widget.maxLine!=null? null: 45,
      decoration:  BoxDecoration(
          color:  widget.color ?? Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: widget.color==null ? gradient(context).map((e) => BoxShadow(color: e,blurRadius: 0.9)).toList() : null
      ),
      child: TextFormField(
        scrollPadding: const EdgeInsets.symmetric(vertical: 22),
        maxLines: widget.maxLine ?? 1,
        controller: widget.controller,
        validator: widget.validator,
        style: widget.color==null? Theme.of(context).textTheme.headline5 : Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
        obscureText: isPassword,
        decoration: InputDecoration(
          errorStyle: const TextStyle(height: 0.3,fontSize: 10),
          contentPadding: const EdgeInsets.only(top: 10),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: widget.prefixIcon,
          ),
          isCollapsed: false,
          isDense: true,
          suffixIcon: widget.isPassword?
          GestureDetector(child:  Icon(Icons.remove_red_eye,color: widget.color==null? Theme.of(context).colorScheme.primary: Colors.white,),onTap: (){
            setState((){
              isPassword=!isPassword;
            });
          },
          ):null,
          border: OutlineInputBorder(
               borderSide: const BorderSide(color: logoColor, width: 5.0),
               borderRadius: BorderRadius.circular(5),
          ),
          filled: false,
          hintText: widget.hintText,
          hintStyle: widget.color==null? Theme.of(context).textTheme.subtitle2 : Theme.of(context).textTheme.subtitle2!.copyWith(color:Colors.white24)
        ),
      ),
    );
  }
}
