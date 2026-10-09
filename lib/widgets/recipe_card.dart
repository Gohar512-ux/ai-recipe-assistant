import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../models/recipe.dart';
import '../screens/recipe_detail_screen.dart';
import '../state/app_state.dart';
import 'stat_chip.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = Theme.of(context);
    final fav = state.isFavorite(recipe);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(recipe: recipe)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: gradientFor(recipe.title),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child:
                      Text(recipe.emoji, style: const TextStyle(fontSize: 34)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(recipe.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13.5,
                              color: theme.colorScheme.onSurface
                                  .withAlpha(150))),
                      const SizedBox(height: 10),
                      Wrap(spacing: 6, runSpacing: 6, children: [
                        StatChip(Icons.timer_outlined,
                            '${recipe.cookMinutes} min'),
                        StatChip(Icons.local_fire_department_outlined,
                            '${recipe.calories} kcal'),
                      ]),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                  color: fav ? Colors.redAccent : null,
                  onPressed: () => state.toggleFavorite(recipe),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
