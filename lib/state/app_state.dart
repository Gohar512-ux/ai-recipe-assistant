import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../models/recipe.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage) {
    _favorites = _storage.loadFavorites();
    _apiKey =
        _storage.apiKey.isNotEmpty ? _storage.apiKey : AppConstants.envApiKey;
  }

  final StorageService _storage;
  late List<Recipe> _favorites;
  late String _apiKey;

  final List<String> ingredients = [];
  List<Recipe> results = [];
  String diet = 'Any';
  bool loading = false;
  String? error;

  List<Recipe> get favorites => List.unmodifiable(_favorites);
  String get apiKey => _apiKey;
  bool get hasKey => _apiKey.isNotEmpty;

  void addIngredient(String raw) {
    final v = raw.trim();
    if (v.isEmpty ||
        ingredients.any((e) => e.toLowerCase() == v.toLowerCase())) {
      return;
    }
    ingredients.add(v);
    notifyListeners();
  }

  void removeIngredient(String v) {
    ingredients.remove(v);
    notifyListeners();
  }

  void setDiet(String d) {
    diet = d;
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key.trim();
    await _storage.saveApiKey(_apiKey);
    notifyListeners();
  }

  Future<void> findRecipes() async {
    if (ingredients.isEmpty) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      results =
          await GeminiService(_apiKey).suggestRecipes(ingredients, diet: diet);
    } on GeminiException catch (e) {
      error = e.message;
    } catch (_) {
      error = 'Something went wrong. Try again.';
    }
    loading = false;
    notifyListeners();
  }

  bool isFavorite(Recipe r) => _favorites.any((f) => f.id == r.id);

  Future<void> toggleFavorite(Recipe r) async {
    if (isFavorite(r)) {
      _favorites.removeWhere((f) => f.id == r.id);
    } else {
      _favorites.insert(0, r);
    }
    notifyListeners();
    await _storage.saveFavorites(_favorites);
  }
}
