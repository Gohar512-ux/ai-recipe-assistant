import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/home_screen.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Recipe AI',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        home: const HomeScreen(),
      );
}
