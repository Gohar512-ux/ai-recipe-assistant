import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';

class StorageService {
  static const _favKey = 'favorites';
  static const _apiKeyKey = 'gemini_api_key';
  late SharedPreferences _prefs;

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  String get apiKey => _prefs.getString(_apiKeyKey) ?? '';
  Future<void> saveApiKey(String key) =>
      _prefs.setString(_apiKeyKey, key.trim());

  List<Recipe> loadFavorites() {
    final raw = _prefs.getString(_favKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorites(List<Recipe> recipes) => _prefs.setString(
      _favKey, jsonEncode(recipes.map((r) => r.toJson()).toList()));
}
