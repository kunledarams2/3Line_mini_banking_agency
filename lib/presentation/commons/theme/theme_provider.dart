

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AppThemeMode { light, dark}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref)=>ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
static const _themeKey = 'isDarkMode';

  ThemeNotifier():super(ThemeMode.system){
    _loadTheme();

  }

void toggleTheme(bool isDark) {
  final mode = isDark ? ThemeMode.dark : ThemeMode.light;
  state = mode;
  _saveTheme(isDark);
}

bool get isDarkMode => state == ThemeMode.dark;

Future<void> _loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool(_themeKey) ?? false;
  state = isDark ? ThemeMode.dark : ThemeMode.light;
}

Future<void> _saveTheme(bool isDark) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_themeKey, isDark);
}
}