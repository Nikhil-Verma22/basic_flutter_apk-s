import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeatsTheme {
  static const Color primary = Color(0xffffb3b5);
  static const Color primaryContainer = Color(0xffff5167);
  static const Color surface = Color(0xff131315);
  static const Color surfaceContainerLowest = Color(0xff0e0e10);
  static const Color surfaceContainerLow = Color(0xff1b1b1d);
  static const Color surfaceContainer = Color(0xff1f1f21);
  static const Color surfaceContainerHigh = Color(0xff2a2a2c);
  static const Color surfaceContainerHighest = Color(0xff353437);
  static const Color surfaceBright = Color(0xff39393b);
  static const Color onSurface = Color(0xffe4e2e4);
  static const Color onSurfaceVariant = Color(0xffe6bcbd);
  static const Color outlineVariant = Color(0x335d3f40); // 20% opacity for glass effect

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        primaryContainer: primaryContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainerHigh: surfaceContainerHigh,
        surfaceContainerHighest: surfaceContainerHighest,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 56, letterSpacing: -0.02, color: onSurface, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.inter(fontSize: 28, color: onSurface, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.inter(fontSize: 16, height: 1.5, color: onSurface),
        labelSmall: GoogleFonts.inter(fontSize: 11, letterSpacing: 0.05, color: onSurfaceVariant),
      ),
      useMaterial3: true,
    );
  }
}
