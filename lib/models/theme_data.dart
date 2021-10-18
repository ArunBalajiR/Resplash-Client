import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {

    return ThemeData(

      shadowColor: isDarkTheme ? Colors.black : Colors.grey[300],
      scaffoldBackgroundColor: isDarkTheme ? Colors.black :Colors.grey.shade300,
      primaryColor: isDarkTheme ? Color(0xff010c1d) : Colors.white,
      primarySwatch: Colors.grey,
      accentColor: Colors.grey,
      highlightColor: isDarkTheme ? Colors.black45 : Colors.grey.shade300,
      backgroundColor: isDarkTheme ?  Color(0xff2a3344) : Color(0xfff3f3f4),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.white : Colors.black,
      bottomAppBarColor: isDarkTheme ? Color(0xff2a3344) : Colors.grey[200],
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Colors.grey,
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF424242) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light(),
      ),

      accentColorBrightness: isDarkTheme ? Brightness.light : Brightness.dark,

      appBarTheme: isDarkTheme ? AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        brightness: Brightness.dark,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ) : AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.light,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ),

        textSelectionTheme: TextSelectionThemeData(selectionColor: isDarkTheme ? Colors.white : Colors.black),
    );
  }
}