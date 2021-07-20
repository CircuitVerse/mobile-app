import 'package:flutter/material.dart';

class IbTheme {
  IbTheme._();

  static ThemeData getThemeData(context) {
    return Theme.of(context).copyWith(
      primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
            color: Colors.white,
          ),
      accentColor: IbTheme.primaryColor,
      primaryColor: IbTheme.primaryColor,
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: IbTheme.fontFamily,
            bodyColor: IbTheme.textColor(context),
          ),
      primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
            fontFamily: IbTheme.fontFamily,
            bodyColor: Colors.white,
          ),
      accentTextTheme: Theme.of(context).accentTextTheme.apply(
            fontFamily: IbTheme.fontFamily,
          ),
    );
  }

  static Color textFieldLabelColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[300]
        : Colors.grey[600];
  }

  static Color textColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : IbTheme.bodyTextColor;
  }

  static Color primaryHeadingColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : IbTheme.headingTextColor;
  }

  static Color boxBg(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? bgCardDark
        : bgCard;
  }

  static Color boxShadow(context) {
    return Theme.of(context).brightness == Brightness.dark ? bgCardDark : grey;
  }

  static Color highlightText(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryColor
        : primaryColorDark;
  }

  static Color getPrimaryColor(context) {
    return Theme.of(context).brightness == Brightness.dark
        ? IbTheme.brightPrimaryColor
        : IbTheme.primaryColor;
  }

  static const Color primaryColor = Color.fromRGBO(2, 110, 87, 1);
  static const Color brightPrimaryColor = Color.fromRGBO(0, 232, 179, 1);
  static const Color primaryColorDark = Color.fromRGBO(2, 110, 87, 0.5);
  static const Color bodyTextColor = Color.fromRGBO(92, 89, 98, 1);
  static const Color headingTextColor = Color.fromRGBO(39, 38, 43, 1);
  static const String fontFamily = 'Roboto';
  static const Color grey = Color.fromRGBO(150, 150, 150, 1);
  static const Color bgCard = Color.fromRGBO(255, 255, 255, 0.9);
  static const Color bgCardDark = Color.fromRGBO(97, 97, 97, 1);
}
