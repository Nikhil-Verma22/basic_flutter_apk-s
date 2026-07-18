import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/chat_provider.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const DeepSiteApp(),
    ),
  );
}

class DeepSiteApp extends StatelessWidget {
  const DeepSiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Futuristic Cyan/Blue palette from Stitch design
    final Color primaryCyan = const Color(0xFF00F2FF);
    final Color surfaceDark = const Color(0xFF121212);
    final Color surfaceLighter = const Color(0xFF1E1E1E);

    return MaterialApp(
      title: 'DeepSite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: surfaceDark,
        colorScheme: ColorScheme.dark(
          primary: primaryCyan,
          secondary: const Color(0xFF56D5FA),
          surface: surfaceLighter,
          onSurface: const Color(0xFFE2E2E2),
        ),
        textTheme: GoogleFonts.manropeTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          headlineLarge: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceDark.withValues(alpha: 0.8),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
          ),
        ),
      ),
      home: const ChatScreen(),
    );
  }
}
