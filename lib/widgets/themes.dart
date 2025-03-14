import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme{
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    fontFamily:GoogleFonts.pathwayExtreme().fontFamily,
  );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
    fontFamily: GoogleFonts.sanchez().fontFamily,
  );

  static Color blueColor = Color(0xff0d6efd);
  static Color lightblueColor = Color(0xff6c9be3);
  static Color darkblueColor = Color(0xff134da9);

}
