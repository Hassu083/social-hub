import 'dart:math';
import 'package:flutter/material.dart';
import '../color.dart';

class Design extends StatelessWidget {
  Color? color;
   Design({Key? key,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        children: [
    for (var i=80;i<120;i++)
    i%2==0?
    Positioned(
      top: Random().nextInt(800).toDouble(),
      right: Random().nextInt(1500).toDouble(),
      child: Container(
        width: i.toDouble(),
        height: i.toDouble(),
        decoration:  BoxDecoration(
            color:  color ?? logoColor.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(1000))
        ),
      ),
    ):Positioned(
      top: Random().nextInt(800).toDouble(),
      right: Random().nextInt(1500).toDouble(),
      child: Container(
        width: i.toDouble(),
        height: i.toDouble(),
        decoration:  const BoxDecoration(
            color:  Colors.black12,
            borderRadius:  BorderRadius.all(Radius.circular(1000))
        ),
      ),
    ),
    ]
    );
  }
}
