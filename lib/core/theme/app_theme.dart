import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color deadow50 = Color(0xFFF0F3FD);
  static const Color deadow100 = Color(0xFFE4E9FB);
  static const Color deadow200 = Color(0xFFCED5F7);
  static const Color deadow300 = Color(0xFFB0BAF1);
  static const Color deadow400 = Color(0xFF9097E9);
  static const Color deadow500 = Color(0xFF7575DF);

  static const Color primary = Color(0xFF6E66D4);
  static const Color secondary = Color(0xFF3D0079);

  static const Color deadow700 = Color(0xFF554BB7);
  static const Color deadow800 = Color(0xFF453F94);
  static const Color deadow900 = Color(0xFF3C3976);
  static const Color deadow950 = Color(0xFF242145);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF6B7280);
  static const Color border = Color(0xFFB0BAF1);
}

class AppTheme {
  AppTheme._();

  static final ColorScheme lightColorScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        surface: AppColors.surface,
        onSurfaceVariant: AppColors.muted,
        outline: AppColors.border,
        outlineVariant: AppColors.border,
      );

  static final ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.border,
  );
}
