import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final textTheme = _textTheme(AppColors.gray900);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.coral400,
        onPrimary: AppColors.coral50,
        primaryContainer: AppColors.coral50,
        onPrimaryContainer: AppColors.coral900,
        secondary: AppColors.teal600,
        onSecondary: AppColors.teal50,
        tertiary: AppColors.amber200,
        onTertiary: AppColors.amber900,
        error: AppColors.coral600,
        onError: AppColors.coral50,
        errorContainer: AppColors.coral50,
        onErrorContainer: AppColors.coral900,
        surface: Colors.white,
        onSurface: AppColors.gray900,
        outline: AppColors.gray200,
        outlineVariant: AppColors.gray100,
      ),
      textTheme: textTheme,
      extensions: const [AppColorsExtension.light],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coral400,
          foregroundColor: AppColors.coral50,
          disabledBackgroundColor: AppColors.coral200,
          disabledForegroundColor: AppColors.coral50,
          minimumSize: const Size.fromHeight(52),
          elevation: 6,
          shadowColor: AppColors.coral400.withValues(alpha: 0.35),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gray900,
          disabledForegroundColor: AppColors.gray400,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.gray200),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.coral400,
          textStyle: textTheme.labelMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.gray200, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.gray200, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.coral400, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.coral600, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.coral600, width: 1.5),
        ),
        labelStyle: textTheme.bodySmall?.copyWith(color: AppColors.gray600),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.gray400),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.coral600),
      ),
    );
  }

  static TextTheme _textTheme(Color baseColor) {
    final display = GoogleFonts.frauncesTextTheme();
    final body = GoogleFonts.interTextTheme();

    return body
        .copyWith(
          headlineSmall: display.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: baseColor,
          ),
          headlineMedium: display.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: baseColor,
          ),
          titleLarge: display.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: baseColor,
          ),
        )
        .apply(bodyColor: baseColor, displayColor: baseColor);
  }
}
