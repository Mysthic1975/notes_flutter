import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeProvider() {
    loadThemeMode();
  }

  void switchTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    saveThemeMode();
    notifyListeners();
  }

  void saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', themeMode == ThemeMode.light ? 0 : 1);
  }

  void loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    int themeModeInt = prefs.getInt('themeMode') ?? 0;
    themeMode = themeModeInt == 0 ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}