class Recipe {
  final String title;
  final String description;
  final String emoji;
  final int cookMinutes;
  final int servings;
  final int calories;
  final List<String> ingredients;
  final List<String> steps;

  const Recipe({
    required this.title,
    required this.description,
    this.emoji = '🍽️',
    required this.cookMinutes,
    required this.servings,
    required this.calories,
    required this.ingredients,
    required this.steps,
  });

  String get id => title.toLowerCase().trim();

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
        title: (j['title'] ?? 'Untitled').toString(),
        description: (j['description'] ?? '').toString(),
        emoji: (j['emoji'] ?? '🍽️').toString(),
        cookMinutes: _toInt(j['cookMinutes']),
        servings: _toInt(j['servings']),
        calories: _toInt(j['calories']),
        ingredients: _toList(j['ingredients']),
        steps: _toList(j['steps']),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'emoji': emoji,
        'cookMinutes': cookMinutes,
        'servings': servings,
        'calories': calories,
        'ingredients': ingredients,
        'steps': steps,
      };

  static int _toInt(dynamic v) =>
      v is num ? v.toInt() : int.tryParse('$v') ?? 0;

  static List<String> _toList(dynamic v) =>
      v is List ? v.map((e) => e.toString()).toList() : <String>[];
}
