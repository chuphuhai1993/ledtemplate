import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/template.dart';

class UserData {
  static final ValueNotifier<List<Template>> savedTemplates = ValueNotifier([]);
  static final ValueNotifier<String> defaultPhoneAsset = ValueNotifier(
    'assets/phones/iphone_16.png',
  );
  static final ValueNotifier<bool> isFirstTime = ValueNotifier(true);
  static const String _key = 'saved_templates';
  static const String _phoneKey = 'default_phone_asset';
  static const String _firstTimeKey = 'is_first_time';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<Template> loadedTemplates =
          jsonList.map((e) => Template.fromJson(e)).toList();
      savedTemplates.value = loadedTemplates;
    }

    final String? savedPhone = prefs.getString(_phoneKey);
    if (savedPhone != null) {
      defaultPhoneAsset.value = savedPhone;
    }

    // Load first-time status
    isFirstTime.value = prefs.getBool(_firstTimeKey) ?? true;
  }

  static Future<void> addTemplate(Template template) async {
    final currentList = List<Template>.from(savedTemplates.value);
    currentList.add(template);
    savedTemplates.value = currentList;
    await _save();
  }

  static Future<void> updateTemplate(int index, Template template) async {
    final currentList = List<Template>.from(savedTemplates.value);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = template;
      savedTemplates.value = currentList;
      await _save();
    }
  }

  static Future<void> deleteTemplate(int index) async {
    final currentList = List<Template>.from(savedTemplates.value);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      savedTemplates.value = currentList;
      await _save();
    }
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      savedTemplates.value.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  static Future<void> setPhoneAsset(String asset) async {
    defaultPhoneAsset.value = asset;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, asset);
  }

  static Future<void> completeOnboarding() async {
    isFirstTime.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
  }
}
