import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/constants.dart';
import '../models/recipe.dart';

class GeminiException implements Exception {
  final String message;
  GeminiException(this.message);
  @override
  String toString() => message;
}

class GeminiService {
  GeminiService(this.apiKey);
  final String apiKey;

  Future<List<Recipe>> suggestRecipes(
    List<String> ingredients, {
    String diet = 'Any',
    int count = 3,
  }) async {
    if (apiKey.isEmpty) {
      throw GeminiException('Add your Gemini API key in Settings first.');
    }

    final prompt = '''
You are a helpful chef. Suggest $count recipes using mainly these ingredients: ${ingredients.join(', ')}.
Dietary preference: $diet. Assume basic pantry items (salt, oil, water, pepper) are available.
Return ONLY a JSON array. Each item must have:
"title" (string), "emoji" (one food emoji), "description" (one sentence), "cookMinutes" (int), "servings" (int),
"calories" (int, per serving), "ingredients" (array of strings with quantities), "steps" (array of strings).
''';

    final uri = Uri.parse(
        '${AppConstants.endpoint}/${AppConstants.model}:generateContent');

    try {
      final res = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': apiKey,
            },
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
              'generationConfig': {
                'responseMimeType': 'application/json',
                'thinkingConfig': {'thinkingLevel': 'low'},
              },
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (res.statusCode != 200) {
        throw GeminiException(_apiError(res));
      }

      final data = jsonDecode(res.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (text == null) {
        throw GeminiException('Gemini returned an empty response. Try again.');
      }

      final decoded = jsonDecode(text as String);
      final list = decoded is List ? decoded : (decoded['recipes'] ?? []);
      final recipes = (list as List)
          .map<Recipe>((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList();
      if (recipes.isEmpty) {
        throw GeminiException('No recipes came back. Try other ingredients.');
      }
      return recipes;
    } on SocketException {
      throw GeminiException('No internet connection.');
    } on TimeoutException {
      throw GeminiException('Request timed out. Try again.');
    } on FormatException {
      throw GeminiException('Could not read the response. Try again.');
    }
  }

  String _apiError(http.Response res) {
    try {
      final msg = jsonDecode(res.body)['error']?['message'];
      if (msg != null) return 'Gemini error (${res.statusCode}): $msg';
    } catch (_) {}
    return 'Gemini error (${res.statusCode}).';
  }
}
