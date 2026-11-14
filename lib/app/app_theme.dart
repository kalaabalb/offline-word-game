import 'package:flutter/material.dart';

class JebenaTheme {
  static const background = Color(0xFF241812);
  static const surface = Color(0xFF38251C);
  static const cream = Color(0xFFF4E8D4);
  static const terracotta = Color(0xFFC96D4B);
  static const saffron = Color(0xFFE4AC3B);

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        canvasColor: background,
        colorScheme: const ColorScheme.dark(
          primary: terracotta,
          secondary: saffron,
          surface: surface,
          onPrimary: cream,
          onSecondary: background,
          onSurface: cream,
        ),
        fontFamily: 'NotoSansEthiopic',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: cream, fontSize: 18, height: 1.4),
          bodyMedium: TextStyle(color: cream, fontSize: 16, height: 1.4),
          titleLarge: TextStyle(
              color: cream,
              fontSize: 24,
              height: 1.4,
              fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              color: cream,
              fontSize: 30,
              height: 1.4,
              fontWeight: FontWeight.bold),
        ).merge(const TextTheme(
          bodySmall: TextStyle(height: 1.4),
          bodyMedium: TextStyle(height: 1.4),
          bodyLarge: TextStyle(height: 1.4),
          displaySmall: TextStyle(height: 1.4),
          displayMedium: TextStyle(height: 1.4),
          displayLarge: TextStyle(height: 1.4),
          headlineSmall: TextStyle(height: 1.4),
          headlineMedium: TextStyle(height: 1.4),
          headlineLarge: TextStyle(height: 1.4),
          titleSmall: TextStyle(height: 1.4),
          titleMedium: TextStyle(height: 1.4),
          titleLarge: TextStyle(height: 1.4),
          labelSmall: TextStyle(height: 1.4),
          labelMedium: TextStyle(height: 1.4),
          labelLarge: TextStyle(height: 1.4),
        )),
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          foregroundColor: cream,
          centerTitle: true,
          toolbarHeight: 56,
        ),
        cardTheme: const CardThemeData(color: surface),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      );
}
