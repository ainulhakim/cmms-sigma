import 'package:flutter/material.dart';

/// Centralized application theme configuration.
class AppTheme {
  AppTheme._();

  // ── Brand Colors ──────────────────────────────────────────────────────

  /// Primary brand color — deep blue.
  static const Color primaryColor = Color(0xFF1565C0);

  /// Lighter shade for highlights and backgrounds.
  static const Color primaryLight = Color(0xFF1E88E5);

  /// Darker shade for active states.
  static const Color primaryDark = Color(0xFF0D47A1);

  /// Accent color for secondary actions.
  static const Color accentColor = Color(0xFF26A69A);

  /// Error / danger color.
  static const Color errorColor = Color(0xFFD32F2F);

  /// Warning / caution color.
  static const Color warningColor = Color(0xFFF57C00);

  /// Success / complete color.
  static const Color successColor = Color(0xFF388E3C);

  /// Neutral surface background.
  static const Color surfaceColor = Color(0xFFF5F5F5);

  /// Card background.
  static const Color cardColor = Color(0xFFFFFFFF);

  // ── Text Colors ───────────────────────────────────────────────────────

  /// Primary text on light backgrounds.
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary / subtitle text.
  static const Color textSecondary = Color(0xFF757575);

  /// Hint / disabled text.
  static const Color textHint = Color(0xFFBDBDBD);

  /// Text on primary backgrounds.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text on dark surfaces.
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ── Status Colors ─────────────────────────────────────────────────────

  /// Color for "Open" status.
  static const Color statusOpen = Color(0xFF1E88E5);

  /// Color for "In Progress" status.
  static const Color statusInProgress = Color(0xFFF57C00);

  /// Color for "On Hold" status.
  static const Color statusOnHold = Color(0xFF757575);

  /// Color for "Completed" status.
  static const Color statusCompleted = Color(0xFF388E3C);

  /// Color for "Cancelled" status.
  static const Color statusCancelled = Color(0xFFD32F2F);

  // ── Shadows ───────────────────────────────────────────────────────────

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // ── Text Styles ───────────────────────────────────────────────────────

  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textOnPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    letterSpacing: 1.0,
    height: 1.5,
  );

  // ── Status-specific Text Styles ───────────────────────────────────────

  static TextStyle statusStyle(Color statusColor) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: statusColor,
        height: 1.4,
      );

  // ── Theme Data ────────────────────────────────────────────────────────

  /// Returns the application's light [ThemeData].
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: surfaceColor,
      ),

      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textOnPrimary,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textHint),
      ),

      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimary,
        elevation: 4,
      ),

      // Bottom navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 1,
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF0F0F0),
        labelStyle: const TextStyle(color: textPrimary, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryDark,
        contentTextStyle: const TextStyle(color: textOnDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: heading2,
      ),

      // Progress indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: Color(0xFFE0E0E0),
      ),

      // Scrollbar
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(6),
        radius: const Radius.circular(3),
        thumbColor: WidgetStateProperty.all(primaryColor.withOpacity(0.4)),
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: heading1,
        displayMedium: heading2,
        displaySmall: heading3,
        headlineMedium: subtitle1,
        headlineSmall: subtitle2,
        bodyLarge: bodyText1,
        bodyMedium: bodyText2,
        bodySmall: caption,
        labelLarge: button,
        labelSmall: overline,
      ),
    );
  }
}
