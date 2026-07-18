import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFFb1feda);
  static const Color primaryContainer = Color(0xFF65af8f);
  static const Color secondary = Color(0xFF7bd1fa);
  static const Color secondaryContainer = Color(0xFF006686);
  static const Color error = Color(0xFFff716c);
  static const Color errorContainer = Color(0xFF9f0519);
  
  // Neutral Colors
  static const Color background = Color(0xFF0e0e0e);
  static const Color surface = Color(0xFF0e0e0e);
  static const Color surfaceVariant = Color(0xFF262626);
  static const Color surfaceContainerHighest = Color(0xFF262626);
  static const Color onSurface = Color(0xFFffffff);
  static const Color onSurfaceVariant = Color(0xFFadaaaa);
  static const Color outline = Color(0xFF767575);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        error: error,
        errorContainer: errorContainer,
        background: background,
        surface: surface,
        surfaceVariant: surfaceVariant,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.w900, letterSpacing: -0.25),
        displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w900),
        displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w900),
        headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
