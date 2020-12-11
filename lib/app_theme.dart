import 'package:flutter/material.dart';

class PrimaryAppTheme {
  PrimaryAppTheme._();
  static Color textfieldlabelColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[300]
        : Colors.grey[600];
  }

  static Color getTextColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static Color primaryHeading(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? PrimaryAppTheme.primaryColor
        : Colors.black;
  }

  static Color boxBg(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? PrimaryAppTheme.bgCardDark
        : PrimaryAppTheme.bgCard;
  }

  static Color boxShadow(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? PrimaryAppTheme.bgCardDark
        : PrimaryAppTheme.grey;
  }

  static Color appbarText(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? PrimaryAppTheme.primaryColor
        : Colors.black;
  }

  static Color drawerIcon(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? PrimaryAppTheme.primaryColor
        : Colors.black;
  }

  static Color highlightText(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? PrimaryAppTheme.primaryColor
        : PrimaryAppTheme.primaryColorDark;
  }

  static Color unexpanded_trailing(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static Color expanded_trailing(context) {
    return Colors.green;
  }

  static ThemeData getThemeData(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? ThemeData.dark().copyWith(
            accentColor: Colors.green,
            primaryColor: PrimaryAppTheme.primaryColor)
        : ThemeData.dark().copyWith(
            accentColor: Colors.green,
            primaryColor: PrimaryAppTheme.primaryColor);
  }

  static const Color primaryColor = Color.fromRGBO(66, 185, 131, 1);
  static const Color primaryColorDark = Color.fromRGBO(2, 110, 87, 1);
  static const Color primaryColorDarkTheme = Color.fromRGBO(33, 33, 33, 1);
  static const Color primaryColorLight = Color.fromRGBO(66, 185, 131, 0.5);
  static const Color primaryColorShadow = Color.fromRGBO(245, 255, 252, 1);
  static const Color imageBackground = Color.fromRGBO(63, 61, 86, 1);
  static const Color blue = Color.fromRGBO(66, 185, 182, 1);
  static const Color red = Color.fromRGBO(255, 89, 89, 1);
  static const Color grey = Color.fromRGBO(150, 150, 150, 1);
  static const Color lightGrey = Color.fromRGBO(150, 150, 150, 0.5);
  static const Color bgCard = Color.fromRGBO(255, 255, 255, 0.9);
  static Color bgCardDark = Colors.grey[700];
  static Color htmlEditorBg = Colors.grey[100];
  static const OutlineInputBorder primaryDarkOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: PrimaryAppTheme.primaryColorDark),
  );

  static const OutlineInputBorder redOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: PrimaryAppTheme.red),
  );

  static const InputDecoration textFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.all(8),
    focusedBorder: PrimaryAppTheme.primaryDarkOutlineBorder,
    enabledBorder: PrimaryAppTheme.primaryDarkOutlineBorder,
    errorBorder: PrimaryAppTheme.redOutlineBorder,
    focusedErrorBorder: PrimaryAppTheme.redOutlineBorder,
  );
}
