// lib/theme/app_theme.dart
// ISL Connect - Inclusive design theme system
// Deep indigo + teal accent palette with warm neutrals for accessibility

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ── Primary brand colors ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C3FF6);       // Deep violet
  static const Color primaryLight = Color(0xFF9B72F5);  // Soft violet
  static const Color primaryDark = Color(0xFF4A1ED4);   // Rich violet

  // ── Accent colors ─────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF00C9B1);        // Teal / ISL green
  static const Color accentLight = Color(0xFF4DDDC9);   // Light teal
  static const Color accentWarm = Color(0xFFFF6B6B);    // Warm coral for emergency

  // ── Semantic category colors ──────────────────────────────────────────────
  static const Color categoryAlphabet = Color(0xFF6C3FF6);   // Violet
  static const Color categoryNumbers = Color(0xFF00C9B1);    // Teal
  static const Color categoryActions = Color(0xFF4CAF50);    // Green
  static const Color categoryEmotions = Color(0xFFFF6B6B);   // Coral
  static const Color categoryEmergency = Color(0xFFFF9800);  // Amber
  static const Color categoryGreetings = Color(0xFF2196F3);  // Blue

  // ── Neutral base ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF4F0FF);    // Lavender tint white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDE7FF); // Very light violet

  // ── Text colors (high contrast for accessibility) ─────────────────────────
  static const Color textPrimary = Color(0xFF1A1035);   // Deep navy almost black
  static const Color textSecondary = Color(0xFF5A5470); // Muted purple-grey
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Bot / Chat colors ─────────────────────────────────────────────────────
  static const Color botBubble = Color(0xFFEDE7FF);
  static const Color userBubble = Color(0xFF6C3FF6);
  static const Color botBubbleText = Color(0xFF1A1035);
  static const Color userBubbleText = Color(0xFFFFFFFF);

  // ── Shadow ────────────────────────────────────────────────────────────────
  static const Color shadowColor = Color(0x226C3FF6);
}

class AppTheme {
  // ── Build light theme ─────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.textOnPrimary,
        secondary: AppColors.accent,
        onSecondary: AppColors.textOnPrimary,
        secondaryContainer: AppColors.accentLight,
        onSecondaryContainer: AppColors.textPrimary,
        tertiary: AppColors.accentWarm,
        onTertiary: AppColors.textOnPrimary,
        tertiaryContainer: Color(0xFFFFE0E0),
        onTertiaryContainer: AppColors.textPrimary,
        error: Colors.red,
        onError: Colors.white,
        errorContainer: Color(0xFFFFDAD6),
        onErrorContainer: Color(0xFF410002),
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,
        outline: Color(0xFFCABFE0),
        shadow: AppColors.shadowColor,
        inverseSurface: AppColors.textPrimary,
        onInverseSurface: AppColors.surface,
        inversePrimary: AppColors.primaryLight,
        surfaceTint: AppColors.primary,
      ),
    );

    return base.copyWith(
      // ── Typography ────────────────────────────────────────────────────────
      textTheme: _buildTextTheme(base.textTheme),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),

      // ── Bottom Navigation ─────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        elevation: 12,
        type: BottomNavigationBarType.fixed,
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated Button ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 4,
          shadowColor: AppColors.shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(double.infinity, 56), // Large tap targets
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ── Input Decoration ─────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.nunito(
          color: AppColors.textSecondary,
          fontSize: 15,
        ),
      ),

      // ── Scaffold ─────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── Icon ─────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 28,
      ),
    );
  }

  // ── Text theme using Nunito (warm, rounded, highly legible) ───────────────
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.nunito(
        fontSize: 57,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 45,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -1.0,
      ),
      headlineLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      ),
    );
  }
}
