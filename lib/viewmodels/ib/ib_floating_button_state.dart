import 'package:flutter/material.dart';

class IbFloatingButtonState extends ChangeNotifier {
  bool isVisible = true;

  void makeInvisible() {
    isVisible = false;
    notifyListeners();
  }

  void makeVisible() {
    isVisible = true;
    notifyListeners();
  }
}
