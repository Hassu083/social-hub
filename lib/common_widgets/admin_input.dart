import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatelessWidget {
  TextEditingController controller;
  Function() runQuery;
  SearchField({Key? key,
  required this.controller,
  required this.runQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: GoogleFonts.poppins(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
          hintText: "Write Query",
          hintStyle: GoogleFonts.poppins(color: Colors.white54),
          suffixIcon: InkWell(
            onTap: runQuery,
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                  color: Color(0xFF2697FF),
                  borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: const Icon(Icons.pause,color: Colors.white,),
            ),
          ),
          fillColor: const Color(0xFF2A2D3E),
          filled: true,
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30))
          )
      ),
    );
  }
}