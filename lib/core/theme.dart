import 'package:flutter/material.dart';

const Color brand = Color(0xFFFF6B35);

const LinearGradient brandGradient = LinearGradient(
  colors: [Color(0xFFFF9A44), Color(0xFFFF4E50)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const List<List<Color>> _palettes = [
  [Color(0xFFFFB347), Color(0xFFFF7E5F)],
  [Color(0xFF56CCF2), Color(0xFF2F80ED)],
  [Color(0xFF6FCF97), Color(0xFF27AE60)],
  [Color(0xFFBB6BD9), Color(0xFF8E44AD)],
  [Color(0xFFF2994A), Color(0xFFEB5757)],
  [Color(0xFFF7CE68), Color(0xFFFBAB7E)],
];

LinearGradient gradientFor(String seed) {
  final c = _palettes[seed.hashCode.abs() % _palettes.length];
  return LinearGradient(
      colors: c, begin: Alignment.topLeft, end: Alignment.bottomRight);
}

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: brand, brightness: b);
  final bg = dark ? const Color(0xFF17130F) : const Color(0xFFFFF8F1);
  final surface = dark ? const Color(0xFF241E19) : Colors.white;
  final line = dark ? const Color(0xFF3A322B) : const Color(0xFFF0E4D8);

  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c, width: w),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    cardColor: surface,
    dividerColor: line,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w800, color: scheme.onSurface),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: border(line),
      enabledBorder: border(line),
      focusedBorder: border(brand, 2),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      selectedColor: brand,
      side: BorderSide(color: line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: TextStyle(color: scheme.onSurface),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
