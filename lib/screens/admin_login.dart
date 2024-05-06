import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../common_widgets/button.dart';
import '../common_widgets/design.dart';
import '../common_widgets/input_field.dart';
import '../common_widgets/logo.dart';
import '../common_widgets/responsive.dart';
import '../constants.dart';

class AdminLogin extends StatelessWidget {
  AdminLogin({Key? key}) : super(key: key);

  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212332),
      appBar: AppBar(
        backgroundColor: const Color(0xFF292929),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          "Admin's Login",
          style: GoogleFonts.poppins(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Design(
            color: Colors.black12,
          ),
          SingleChildScrollView(
            child: Form(
              child: Builder(builder: (context) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      GestureDetector(
                        child: SocialHub(
                          factor: Responsive.isMobile(context) ? 1 : 1.35,
                          color: const Color(0xFF2697FF),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        direction: Axis.vertical,
                        spacing: 20,
                        children: [
                          InputField(
                            isPassword: false,
                            hintText: "Admin_name",
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            controller: userName,
                            validator: (value) {},
                            color: const Color(0xFF2A2D3E),
                          ),
                          InputField(
                            isPassword: true,
                            hintText: "Password",
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            controller: password,
                            validator: (value) {},
                            color: const Color(0xFF2A2D3E),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      SocialHubButton(
                        onTap: () {
                          if (userName.text == 'Admin' &&
                              password.text == '123') {
                            Navigator.pushNamed(context, "/adminDashboard");
                          }
                        },
                        text: "Login",
                        width: Responsive.isMobile(context) ? 330 : 400,
                        color: const Color(0xFF2697FF),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
