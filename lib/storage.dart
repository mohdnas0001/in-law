import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class LocalStorage {
  static const _profileKey = 'profile';
  static const _historyKey = 'history';
  static const _themeKey = 'theme';

  static Future<void> saveProfile(Map<String, dynamic> profile) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_profileKey, jsonEncode(profile));
  }

  static Future<Map<String, dynamic>?> loadProfile() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_profileKey);
    if (s == null) return null;
    return jsonDecode(s) as Map<String, dynamic>;
  }

  static Future<void> addResult(TestResult r) async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_historyKey) ?? [];
    list.insert(0, jsonEncode(r.toJson()));
    await sp.setStringList(_historyKey, list);
  }

  static Future<List<TestResult>> loadResults() async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_historyKey) ?? [];
    return list.map((s) => TestResult.fromJson(jsonDecode(s))).toList();
  }

  static Future<void> clearHistory() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_historyKey);
  }

  static Future<void> deleteResult(String id) async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_historyKey) ?? [];
    list.removeWhere((s) => jsonDecode(s)['id'] == id);
    await sp.setStringList(_historyKey, list);
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_themeKey, mode.toString());
  }

  static Future<ThemeMode> loadThemeMode() async {
    final sp = await SharedPreferences.getInstance();
    final mode = sp.getString(_themeKey);
    switch (mode) {
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}