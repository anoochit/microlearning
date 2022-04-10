import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kMaterialColor = MaterialColor(0xff6c63ff, {
  50: Color(0xff6c63ff), //10%
  100: Color(0xff6159e6), //20%
  200: Color(0xff564fcc), //30%
  300: Color(0xff4c45b3), //40%
  400: Color(0xff413b99), //50%
  500: Color(0xff363280), //60%
  600: Color(0xff2b2866), //70%
  700: Color(0xff201e4c), //80%
  800: Color(0xff161433), //90%
  900: Color(0xff000000), //100%
});

final kElevatedButtonStyle = ButtonStyle(
  textStyle: MaterialStateProperty.all<TextStyle>(
    GoogleFonts.prompt(),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);
