import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/api_key_dialog.dart';
import '../widgets/gradient_button.dart';
import '../widgets/recipe_card.dart';
import 'favorites_screen.dart';

const Map<String, String> _quick = {
  'Chicken': '🍗',
  'Rice': '🍚',
  'Eggs': '🥚',
  'Tomato': '🍅',
  'Onion': '🧅',
  'Potato': '🥔',
  'Cheese': '🧀',
  'Pasta': '🍝',
  'Garlic': '🧄',
  'Mushroom': '🍄',
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(AppState s) {
    s.addIngredient(_controller.text);
    _controller.clear();
  }

  void _toast(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _find(AppState s) async {
    FocusScope.of(context).unfocus();
    _add(s); // picks up text typed but not yet added
    if (s.ingredients.isEmpty) {
      _toast('Add at least one ingredient first 🥕');
      return;
    }
    if (!s.hasKey) {
      await showApiKeyDialog(context);
      if (!mounted || !s.hasKey) return;
    }
    await s.findRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
          children: [
            // top bar
            Row(
              children: [
                const Text('🍳', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Recipe AI',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                ),
                IconButton(
                  tooltip: 'Saved recipes',
                  icon: const Icon(Icons.favorite_rounded),
                  color: Colors.redAccent,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FavoritesScreen())),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // hero
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: brandGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                      color: brand.withAlpha(80),
                      blurRadius: 24,
                      offset: const Offset(0, 12)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("What's in your\nkitchen today?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          height: 1.15,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text('Add ingredients and get AI-made recipes.',
                      style: TextStyle(color: Colors.white.withAlpha(220))),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _add(s),
                        decoration: InputDecoration(
                          hintText: 'e.g. chicken, rice...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          fillColor: theme.cardColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _add(s),
                        child: const SizedBox(
                          width: 54,
                          height: 54,
                          child: Icon(Icons.add_rounded, color: brand, size: 30),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),

            // quick picks
            const SizedBox(height: 22),
            const Text('Quick add',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in _quick.entries)
                  ActionChip(
                    label: Text('${e.value} ${e.key}'),
                    onPressed: () => s.addIngredient(e.key),
                  ),
              ],
            ),

            // selected
            if (s.ingredients.isNotEmpty) ...[
              const SizedBox(height: 22),
              const Text('Your ingredients',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final i in s.ingredients)
                    InputChip(
                      label: Text(i,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      backgroundColor: brand,
                      deleteIconColor: Colors.white,
                      side: BorderSide.none,
                      onDeleted: () => s.removeIngredient(i),
                    ),
                ],
              ),
            ],

            // diet
            const SizedBox(height: 22),
            const Text('Diet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final d in AppConstants.diets)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(d),
                        selected: s.diet == d,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: s.diet == d
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        onSelected: (_) => s.setDiet(d),
                      ),
                    ),
                ],
              ),
            ),

            // action
            const SizedBox(height: 24),
            GradientButton(
              label: 'Find recipes',
              icon: Icons.auto_awesome_rounded,
              loading: s.loading,
              onPressed: () => _find(s),
            ),

            // error
            if (s.error != null)
              Container(
                margin: const EdgeInsets.only(top: 18),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s.error!)),
                ]),
              ),

            // results
            const SizedBox(height: 26),
            if (s.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('👨‍🍳 Chef Gemini is thinking...',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              )
            else if (s.results.isNotEmpty) ...[
              Text('Recipes for you (${s.results.length})',
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              for (final r in s.results) RecipeCard(recipe: r),
            ] else if (s.error == null)
              Center(
                child: Column(children: [
                  const Text('🥘', style: TextStyle(fontSize: 54)),
                  const SizedBox(height: 8),
                  Text('Your recipes will show up here',
                      style: TextStyle(
                          color: theme.colorScheme.onSurface.withAlpha(140))),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
