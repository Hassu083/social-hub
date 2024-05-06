import 'package:flutter/material.dart';

import '../../../constants.dart';

class StatusItem extends StatelessWidget {
  Widget profile,status;

  StatusItem({Key? key,
    required this.profile,
    required this.status
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: 75,
      height: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const  BorderRadius.all( Radius.circular(15)),
            child: status,
          ),
          Positioned(
            top:07,
            left:06,
            child: Container(
              padding:const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: const  BorderRadius.all( Radius.circular(500)),
                gradient: LinearGradient(
                    colors: gradient(context)
                ),
              ),
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: const  BorderRadius.all( Radius.circular(500)),
                child: profile,
              ),
            ),
          )
        ],
      ),
    );;
  }
}
