import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {

    return ThemeData(
      shadowColor: isDarkTheme ? Colors.black : Color(0xff181818),
      scaffoldBackgroundColor: isDarkTheme ? Colors.black :Colors.grey.shade300,
      primaryColor: isDarkTheme ? Color(0xff212121) : Colors.white,
      primarySwatch: Colors.blue,
      accentColor: Colors.grey,
      backgroundColor: isDarkTheme ? Colors.grey.shade700 : Colors.white,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.grey.shade300 : Colors.black,
      bottomAppBarColor: isDarkTheme ? Colors.grey.shade800 : Colors.grey[200],
      highlightColor: isDarkTheme ? Color(0xff372901) : Colors.blueAccent,
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Colors.blueAccent,
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF424242) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light(),
      ),
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        color: Colors.white,
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600)),
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ),

      textSelectionTheme: TextSelectionThemeData(selectionColor: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}