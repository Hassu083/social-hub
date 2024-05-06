import 'package:socialhub/common_widgets/design.dart';
import 'package:socialhub/common_widgets/logo.dart';
import 'package:socialhub/constants.dart';
import 'package:socialhub/str.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
    ).then((value){
        Navigator.pushNamed(context, "/login");
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
           Design(),
          Center(
            child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 200,
                direction: Axis.vertical,
                children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      direction: Axis.vertical,
                      children: [
                        SocialHub(factor:1.0),
                        Text("SINCE 2001",style: Theme.of(context).textTheme.subtitle1
                        )
                      ],
                    ),
                    Wrap(
                      direction:  Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 5,
                      children: [
                        GradientText("Powered by",
                          colors: [Colors.black,Colors.black],
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF3797EF)
                          ),
                        ),
                        GradientText(by,
                          colors: gradient(context),
                          style: GoogleFonts.pacifico(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                        ),
                      ],
                    )
                ],
              ),
          ),
        ],
      ),
    );
  }
}
