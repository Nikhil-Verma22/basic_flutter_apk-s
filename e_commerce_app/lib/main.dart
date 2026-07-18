import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'config/supabase_config.dart';
import 'providers/cart_provider.dart';
import 'screens/home_screen.dart';
import 'utils/keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize Supabase if credentials are filled in
  if (SupabaseConfig.supabaseUrl != 'YOUR_SUPABASE_URL_HERE') {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
    } catch (e) {
      debugPrint('Supabase initialization failed: $e');
      debugPrint('Falling back to mock data mode.');
    }
  } else {
    debugPrint('Supabase not configured. Running in mock data mode.');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const ApniDukanApp(),
    ),
  );
}

class ApniDukanApp extends StatelessWidget {
  const ApniDukanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apni Dukan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7FAF7),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF5A615A),
          onPrimary: Color(0xFFF4FBF2),
          secondary: Color(0xFF4F6453),
          onSecondary: Color(0xFFE8FFE9),
          surface: Color(0xFFF7FAF7),
          onSurface: Color(0xFF2C3431),
          error: Color(0xFFA83836),
          onError: Color(0xFFFFF7F6),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: const Color(0xFF2C3431),
          displayColor: const Color(0xFF2C3431),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2C3431)),
        ),
        dividerColor: Colors.transparent,
      ),
      home: HomeScreen(key: homeKey),
    );
  }
}
