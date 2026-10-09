import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<AppState>().favorites;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved recipes')),
      body: favs.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('💔', style: TextStyle(fontSize: 54)),
                  SizedBox(height: 8),
                  Text('No saved recipes yet'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              children: [for (final r in favs) RecipeCard(recipe: r)],
            ),
    );
  }
}
