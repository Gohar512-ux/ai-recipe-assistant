import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';
import '../widgets/stat_chip.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final theme = Theme.of(context);
    final fav = s.isFavorite(recipe);

    Widget section(String title, Widget child) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              child,
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
            color: fav ? Colors.redAccent : null,
            onPressed: () => s.toggleFavorite(recipe),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: gradientFor(recipe.title),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.emoji, style: const TextStyle(fontSize: 56)),
                const SizedBox(height: 8),
                Text(recipe.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        height: 1.15,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(recipe.description,
                    style: TextStyle(
                        color: Colors.white.withAlpha(230), fontSize: 15)),
                const SizedBox(height: 14),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  StatChip(Icons.timer_outlined, '${recipe.cookMinutes} min',
                      light: true),
                  StatChip(Icons.people_outline, '${recipe.servings} servings',
                      light: true),
                  StatChip(Icons.local_fire_department_outlined,
                      '${recipe.calories} kcal',
                      light: true),
                ]),
              ],
            ),
          ),
          section(
            'Ingredients',
            Column(
              children: [
                for (final i in recipe.ingredients)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7, right: 12),
                          child: Icon(Icons.circle, size: 8, color: brand),
                        ),
                        Expanded(
                            child: Text(i, style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          section(
            'Steps',
            Column(
              children: [
                for (var n = 0; n < recipe.steps.length; n++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              gradient: brandGradient, shape: BoxShape.circle),
                          child: Text('${n + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(recipe.steps[n],
                              style:
                                  const TextStyle(fontSize: 15, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
