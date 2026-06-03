import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.light;

  bool get isDark => mode == ThemeMode.dark;

  void toggle(bool value) {
    mode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
