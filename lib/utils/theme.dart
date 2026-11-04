import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Palette (Light Watercolor Theme) ────────────────────────────────
  static const Color white        = Color(0xFFFFFFFF);
  static const Color skyWhite     = Color(0xFFF4F9FF);   // page background
  static const Color cloudBlue    = Color(0xFFE8F4FD);   // card fill
  static const Color lightBlue    = Color(0xFFD0E9F8);   // subtle accent
  static const Color iceBlue      = Color(0xFFB8D9F0);   // border / divider

  static const Color mintGreen    = Color(0xFF52C17C);   // brand green
  static const Color tealBlue     = Color(0xFF2AA8C4);   // brand teal
  static const Color deepTeal     = Color(0xFF1A7A91);   // dark teal
  static const Color navyText     = Color(0xFF1A2E44);   // primary text
  static const Color slateText    = Color(0xFF4A6580);   // secondary text
  static const Color mutedText    = Color(0xFF8AA5BE);   // hint/muted text

  static const Color alertRed     = Color(0xFFE05252);
  static const Color alertAmber   = Color(0xFFF5A623);
  static const Color alertGreen   = Color(0xFF27AE60);

  // Legacy aliases for screens that still use old color names
  static const Color spaceDark    = navyText;
  static const Color slateDark    = Color(0xFF2C3E50);
  static const Color slateCard    = cloudBlue;
  static const Color mintAccent   = mintGreen;
  static const Color tealPrimary  = tealBlue;
  static const Color lilacAccent  = Color(0xFF9B59B6);
  static const Color textHigh     = navyText;
  static const Color textMedium   = slateText;
  static const Color textLow      = mutedText;
  static const Color alertSevere  = alertRed;
  static const Color alertWarning = alertAmber;
  static const Color alertSuccess = alertGreen;

  // ── Dark Palette ──────────────────────────────────────────────────────────
  static const Color darkBg         = Color(0xFF121212);   // scaffold background
  static const Color darkSurface    = Color(0xFF1E1E1E);   // card fill
  static const Color darkSurfaceAlt = Color(0xFF252525);   // elevated surface
  static const Color darkBorder     = Color(0xFF333333);   // border / divider
  static const Color darkTextHigh   = Color(0xFFE8E8E8);   // primary text
  static const Color darkTextMed    = Color(0xFFB0B0B0);   // secondary text
  static const Color darkTextLow    = Color(0xFF757575);   // hint/muted text

  // ── Gradient helpers ──────────────────────────────────────────────────────
  static const LinearGradient brandGradient = LinearGradient(
    colors: [mintGreen, tealBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient brandGradientV = LinearGradient(
    colors: [mintGreen, tealBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroBg = LinearGradient(
    colors: [Color(0xFFEBF7FF), Color(0xFFF8FDFF), Color(0xFFF0FAF5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroBgDark = LinearGradient(
    colors: [Color(0xFF121618), Color(0xFF141414), Color(0xFF121614)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Light Theme ───────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: skyWhite,
      primaryColor: tealBlue,
      cardColor: white,
      colorScheme: const ColorScheme.light(
        primary: tealBlue,
        secondary: mintGreen,
        tertiary: deepTeal,
        surface: white,
        error: alertRed,
        onPrimary: white,
        onSecondary: white,
        onSurface: navyText,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.nunito(
          color: navyText, fontSize: 32,
          fontWeight: FontWeight.w800, letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.nunito(
          color: navyText, fontSize: 24,
          fontWeight: FontWeight.w800, letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.nunito(
          color: navyText, fontSize: 18, fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.nunito(
          color: slateText, fontSize: 15, fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: navyText, fontSize: 16,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: slateText, fontSize: 14,
        ),
        labelLarge: GoogleFonts.nunito(
          color: tealBlue, fontSize: 14, fontWeight: FontWeight.w700,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: iceBlue,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          color: navyText, fontSize: 18, fontWeight: FontWeight.w800,
        ),
        iconTheme: const IconThemeData(color: navyText),
        surfaceTintColor: Colors.transparent,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        hintStyle: GoogleFonts.nunito(color: mutedText, fontSize: 14),
        labelStyle: GoogleFonts.nunito(color: slateText, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: iceBlue, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: iceBlue, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: tealBlue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: alertRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: alertRed, width: 1.8),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tealBlue,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tealBlue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: tealBlue, width: 1.5),
          textStyle: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tealBlue,
          textStyle: GoogleFonts.nunito(
            fontSize: 14, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: cloudBlue,
        labelStyle: GoogleFonts.nunito(color: slateText, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: iceBlue),
      ),

      dividerTheme: const DividerThemeData(
        color: iceBlue,
        thickness: 1,
        space: 1,
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: white,
        headerBackgroundColor: tealBlue,
        headerForegroundColor: white,
        surfaceTintColor: Colors.transparent,
        dividerColor: iceBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        dayStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700),
        todayForegroundColor: WidgetStateProperty.all(tealBlue),
        todayBorder: const BorderSide(color: tealBlue, width: 1.5),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tealBlue;
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return white;
          if (states.contains(WidgetState.disabled)) return mutedText;
          return navyText;
        }),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.nunito(
          color: navyText,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: GoogleFonts.nunito(
          color: slateText,
          fontSize: 14,
        ),
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        hourMinuteTextColor: navyText,
        hourMinuteColor: cloudBlue,
        hourMinuteTextStyle: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900),
        dialHandColor: tealBlue,
        dialBackgroundColor: skyWhite,
        dialTextColor: navyText,
        entryModeIconColor: tealBlue,
        dayPeriodTextColor: tealBlue,
        dayPeriodColor: cloudBlue,
      ),
    );
  }

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: tealBlue,
      cardColor: darkSurface,
      colorScheme: const ColorScheme.dark(
        primary: tealBlue,
        secondary: mintGreen,
        tertiary: deepTeal,
        surface: darkSurface,
        error: alertRed,
        onPrimary: white,
        onSecondary: white,
        onSurface: darkTextHigh,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.nunito(
          color: darkTextHigh, fontSize: 32,
          fontWeight: FontWeight.w800, letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.nunito(
          color: darkTextHigh, fontSize: 24,
          fontWeight: FontWeight.w800, letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.nunito(
          color: darkTextHigh, fontSize: 18, fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.nunito(
          color: darkTextMed, fontSize: 15, fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: darkTextHigh, fontSize: 16,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: darkTextMed, fontSize: 14,
        ),
        labelLarge: GoogleFonts.nunito(
          color: tealBlue, fontSize: 14, fontWeight: FontWeight.w700,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: darkBorder,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          color: darkTextHigh, fontSize: 18, fontWeight: FontWeight.w800,
        ),
        iconTheme: const IconThemeData(color: darkTextHigh),
        surfaceTintColor: Colors.transparent,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceAlt,
        hintStyle: GoogleFonts.nunito(color: darkTextLow, fontSize: 14),
        labelStyle: GoogleFonts.nunito(color: darkTextMed, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkBorder, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: tealBlue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: alertRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: alertRed, width: 1.8),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tealBlue,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tealBlue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: tealBlue, width: 1.5),
          textStyle: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tealBlue,
          textStyle: GoogleFonts.nunito(
            fontSize: 14, fontWeight: FontWeight.w700,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceAlt,
        labelStyle: GoogleFonts.nunito(color: darkTextMed, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: darkBorder),
      ),

      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: darkSurface,
        headerBackgroundColor: tealBlue,
        headerForegroundColor: white,
        surfaceTintColor: Colors.transparent,
        dividerColor: darkBorder,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        dayStyle: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700),
        todayForegroundColor: WidgetStateProperty.all(tealBlue),
        todayBorder: const BorderSide(color: tealBlue, width: 1.5),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tealBlue;
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return white;
          if (states.contains(WidgetState.disabled)) return darkTextLow;
          return darkTextHigh;
        }),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.nunito(
          color: darkTextHigh,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: GoogleFonts.nunito(
          color: darkTextMed,
          fontSize: 14,
        ),
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        hourMinuteTextColor: darkTextHigh,
        hourMinuteColor: darkSurfaceAlt,
        hourMinuteTextStyle: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w900),
        dialHandColor: tealBlue,
        dialBackgroundColor: darkBg,
        dialTextColor: darkTextHigh,
        entryModeIconColor: tealBlue,
        dayPeriodTextColor: tealBlue,
        dayPeriodColor: darkSurfaceAlt,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
      ),

      popupMenuTheme: const PopupMenuThemeData(
        color: darkSurface,
      ),
    );
  }

  // ── Theme-aware color helpers ─────────────────────────────────────────────
  // Use these in screens to get the right color for the current theme mode.
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Page background color (replaces hardcoded skyWhite)
  static Color scaffoldBg(BuildContext context) =>
      isDark(context) ? darkBg : skyWhite;

  /// Card fill color (replaces hardcoded white / cloudBlue)
  static Color cardBg(BuildContext context) =>
      isDark(context) ? darkSurface : white;

  /// Elevated card fill (replaces cloudBlue for subtle backgrounds)
  static Color cardBgAlt(BuildContext context) =>
      isDark(context) ? darkSurfaceAlt : cloudBlue;

  /// Primary text color (replaces hardcoded navyText)
  static Color textPrimary(BuildContext context) =>
      isDark(context) ? darkTextHigh : navyText;

  /// Secondary text color (replaces hardcoded slateText)
  static Color textSecondary(BuildContext context) =>
      isDark(context) ? darkTextMed : slateText;

  /// Muted/hint text color (replaces hardcoded mutedText)
  static Color textMuted(BuildContext context) =>
      isDark(context) ? darkTextLow : mutedText;

  /// Border/divider color (replaces hardcoded iceBlue)
  static Color borderColor(BuildContext context) =>
      isDark(context) ? darkBorder : iceBlue;

  /// Subtle accent background (replaces hardcoded lightBlue)
  static Color subtleAccent(BuildContext context) =>
      isDark(context) ? darkSurfaceAlt : lightBlue;

  // ── Background decorations ────────────────────────────────────────────────
  static Decoration get backgroundGradient => const BoxDecoration(
    gradient: heroBg,
  );

  /// Theme-aware background gradient
  static Decoration backgroundGradientOf(BuildContext context) => BoxDecoration(
    gradient: isDark(context) ? heroBgDark : heroBg,
  );

  static Decoration glassCardDecoration({bool isBorderAccent = false}) =>
      BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isBorderAccent ? tealBlue.withValues(alpha: 0.35) : iceBlue,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2AA8C4).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );

  /// Theme-aware glass card decoration
  static Decoration glassCardDecorationOf(BuildContext context, {bool isBorderAccent = false}) {
    final dark = isDark(context);
    return BoxDecoration(
      color: dark ? darkSurface : white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isBorderAccent
            ? tealBlue.withValues(alpha: 0.35)
            : (dark ? darkBorder : iceBlue),
        width: 1.2,
      ),
      boxShadow: dark
          ? [] // no shadow on dark surfaces
          : [
              BoxShadow(
                color: const Color(0xFF2AA8C4).withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }

  // Gradient pill button decoration (for custom gradient buttons)
  static BoxDecoration get gradientButtonDecoration => BoxDecoration(
    gradient: brandGradient,
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
      BoxShadow(
        color: tealBlue.withValues(alpha: 0.35),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
