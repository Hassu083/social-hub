import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class InstaTheme{
  static ThemeData light = ThemeData(
    primaryColor: Colors.white,
    backgroundColor: Color(0xFFFAFAFA),
    shadowColor: Colors.black,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
        primary: Colors.black,
        onPrimary: Colors.black,
        secondary: Colors.black,
        onSecondary: Colors.black,
        error: Colors.black,
        onError: Colors.black,
        background: Colors.black,
        onBackground: Colors.black,
        surface: Colors.black,
        onSurface: Colors.black
    ),
    textTheme: TextTheme(
      subtitle1: GoogleFonts.arimo(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w600
      ),
      subtitle2: GoogleFonts.poppins(
          color: Colors.black38,
          fontSize: 15
      ),
      headline1:  GoogleFonts.pacifico(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
      headline5: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black
      ) ,
    )
  );
  static ThemeData dark = light.copyWith(
    primaryColor: Colors.black,
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.white,
        onPrimary: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.white,
        error: Colors.white,
        onError: Colors.white,
        background: Colors.white,
        onBackground: Colors.white,
        surface: Colors.white,
        onSurface: Colors.white
    ) ,
    backgroundColor: const Color(0xFF121212),
    textTheme: TextTheme(
      subtitle1: light.textTheme.subtitle1!.copyWith(color: Colors.white),
      subtitle2: light.textTheme.subtitle2!.copyWith(color: Colors.white24),
      headline1: light.textTheme.headline1!.copyWith(color: Colors.white),
      headline5: light.textTheme.headline5!.copyWith(color: Colors.white),
    )
  );
}