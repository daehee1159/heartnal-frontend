import 'dart:ui';

import 'package:couple_signal/src/models/theme/theme_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {

  String _darkTheme = "defaultMode";
  ThemePreference preference = ThemePreference();

  // getter
  String get darkTheme => _darkTheme;

  // setter
  set darkTheme(String value) {
    _darkTheme = value;
    preference.setTheme(value);
    notifyListeners();
  }

  /// parameter 로 테마를 받아서 각 parameter 에 맞는 테마로 설정되게 만들어야함
  themeData(String theme) {
    switch (theme) {
      case "defaultMode":
        return ThemeData(
          // primaryColor: Color(0xffFBCCD1),
          // primaryColor: const Color(0xffFE9BE6),
          primaryColor: Colors.white,
          primaryColorLight: const Color(0xffFE9BE6),
          secondaryHeaderColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          cardColor: Colors.white,
          fontFamily: 'Cafe24SsurroundAir',
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.black
            ),
            backgroundColor: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: const Color(0xff5D5D5D),
            size: 25.0
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black
          ),
          cardTheme: CardTheme(
            color: Colors.white,
          ),
          textTheme: TextTheme(
            bodyText1: const TextStyle(
              color: const Color(0xff494749),
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cafe24SsurroundAir',
            ),
            bodyText2: const TextStyle(
              color: const Color(0xff494749),
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cafe24SsurroundAir',
            ),
          ),
        );
      case "darkMode":
        return ThemeData(
          primaryColor: Colors.black,
          secondaryHeaderColor: Colors.black,
          scaffoldBackgroundColor: const Color(0xFF222222),
          backgroundColor: Colors.black,
          cardColor: Colors.black,
          fontFamily: 'Cafe24SsurroundAir',
          hintColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          tabBarTheme: const TabBarTheme(
              labelColor: Colors.white
          ),
          cardTheme: const CardTheme(
              color: Colors.black
          ),
          textTheme: const TextTheme(
              bodyText1: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600
              ),
              bodyText2: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600
              )
          ),
        );
    }
  }
}
