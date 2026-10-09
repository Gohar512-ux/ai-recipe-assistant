import 'secrets.dart';

class AppConstants {
  static const String _placeholder = 'PASTE_YOUR_KEY_HERE';

  /// Key from lib/core/secrets.dart, or --dart-define=GEMINI_API_KEY=xxxx
  static const String _configKey =
      String.fromEnvironment('GEMINI_API_KEY', defaultValue: Secrets.geminiApiKey);

  static String get envApiKey => _configKey == _placeholder ? '' : _configKey;

  static const String model = 'gemini-3.5-flash';
  static const String endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const List<String> diets = [
    'Any',
    'Vegetarian',
    'Vegan',
    'Gluten-free',
    'High-protein',
  ];
}
