import 'package:flutter/material.dart';

import 'dart:math';

MaterialColor generateMaterialColor(Color color) {
  final int colorValue = (0xFF << 24) |
      (color.r.toInt() << 16) |
      (color.g.toInt() << 8) |
      color.b.toInt();
  return MaterialColor(colorValue, {
    50: _tintColor(color, 0.9),
    100: _tintColor(color, 0.8),
    200: _tintColor(color, 0.6),
    300: _tintColor(color, 0.4),
    400: _tintColor(color, 0.2),
    500: color,
    600: _shadeColor(color, 0.1),
    700: _shadeColor(color, 0.2),
    800: _shadeColor(color, 0.3),
    900: _shadeColor(color, 0.4),
  });
}

int _tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color _tintColor(Color color, double factor) => Color.fromRGBO(
      _tintValue(color.r.toInt(), factor),
      _tintValue(color.g.toInt(), factor),
      _tintValue(color.b.toInt(), factor),
      1,
    );

int _shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color _shadeColor(Color color, double factor) => Color.fromRGBO(
      _shadeValue(color.r.toInt(), factor),
      _shadeValue(color.g.toInt(), factor),
      _shadeValue(color.b.toInt(), factor),
      1,
    );
