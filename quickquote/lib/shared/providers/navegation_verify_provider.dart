import 'package:flutter/material.dart';

class NavegationVerifyProvider extends ChangeNotifier {
  bool show = true;

  int selectedOption = 0;

  void showChange(bool change) {
    show = change;
    notifyListeners();
  }

  void changeSelectedOption(int index) {
    selectedOption = index;
    notifyListeners();
  }
}
