import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/theme_services.dart';

// const Color bluishClr = Color(0xFF4e5ae8);
const MaterialColor bluishClr = MaterialColor(0xFF4e5ae8, <int, Color>{
  50: Color(0xFF4e5ae8),
  100: Color(0xFF4e5ae8),
  200: Color(0xFF4e5ae8),
  300: Color(0xFF4e5ae8),
  400: Color(0xFF4e5ae8),
  500: Color(0xFF4e5ae8),
  600: Color(0xFF4e5ae8),
  700: Color(0xFF4e5ae8),
  800: Color(0xFF4e5ae8),
  900: Color(0xFF4e5ae8),
});
const Color yellowClr = Color(0xFFFF8746);
const Color pinkClr = Color(0xFFFF4667);
const Color white = Colors.white;
const primaryClr = bluishClr;

const MaterialColor darkGreyClr = MaterialColor(0xFF121212, <int, Color>{
  50: Color(0xFF121212),
  100: Color(0xFF121212),
  200: Color(0xFF121212),
  300: Color(0xFF121212),
  400: Color(0xFF121212),
  500: Color(0xFF121212),
  600: Color(0xFF121212),
  700: Color(0xFF121212),
  800: Color(0xFF121212),
  900: Color(0xFF4e5ae8),
});
const MaterialColor darkHeaderClr = MaterialColor(0xFF424242, <int, Color>{
      50: Color(0xFF424242),
      100: Color(0xFF424242),
      200: Color(0xFF424242),
      300: Color(0xFF424242),
      400: Color(0xFF424242),
      500: Color(0xFF424242),
      600: Color(0xFF424242),
      700: Color(0xFF424242),
      800: Color(0xFF424242),
      900: Color(0xFF424242),
    });

class Themes{
  static final light = ThemeData(
      backgroundColor: Colors.white,
      primarySwatch: primaryClr,
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white
      ),

    secondaryHeaderColor: Colors.black,
    scaffoldBackgroundColor: Colors.white

    // brightness: Brightness.dark,
    //   scaffoldBackgroundColor: Colors.blue
  );

  static final dark = ThemeData(
    backgroundColor: darkHeaderClr,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: darkGreyClr
    ),
    primarySwatch: Colors.orange,
    secondaryHeaderColor:Colors.white,
      scaffoldBackgroundColor: darkHeaderClr

  );


}

bool get isDark{
  return ThemeService().iSDarkTheme()??false;
}
TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDark? Colors.grey[400]:Colors.grey,
      ),
  );
}
Color? get buttonBorderClr{
  return isDark? Colors.grey[600]:Colors.grey[300];
}
Color? get containerBackgroundClr{
  return isDark? Colors.white:Colors.grey[400];
}
TextStyle get headingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: isDark? Colors.white:Colors.black,
    ),
  );
}
TextStyle  verseTitleStyle({double? fontSize = 16}){
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: isDark? Colors.black:Colors.white,
    ),
  );
}
TextStyle get titleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: isDark? Colors.white:Colors.black,
    ),
  );
}
TextStyle get subTitleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: isDark? Colors.grey[100]:Colors.grey[600],
    ),
  );
}
TextStyle datePickerStyle({double? size=20}){
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    )
  );
}