import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'quiz_page.dart';
import 'profile_page.dart';
import 'history_page.dart';
import 'settings_page.dart';
import 'storage.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  themeNotifier.value = await LocalStorage.loadThemeMode();
  runApp(InLawCompatibilityApp());
}

class InLawCompatibilityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'In-law Compatibility Test',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              primary: Colors.teal,
              secondary: Colors.amber,
              surface: Colors.white,
              background: Colors.grey[100],
            ),
            textTheme: const TextTheme(
              headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
              bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shadowColor: Colors.teal.withOpacity(0.5),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Colors.teal),
                foregroundColor: Colors.teal,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: Colors.teal,
              linearMinHeight: 8,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
              primary: Colors.tealAccent,
              secondary: Colors.amberAccent,
              surface: Colors.grey[900],
              background: Colors.grey[850],
            ),
            textTheme: const TextTheme(
              headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
              bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
            ),
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey[800],
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black87,
                shadowColor: Colors.tealAccent.withOpacity(0.5),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Colors.tealAccent),
                foregroundColor: Colors.tealAccent,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.tealAccent, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[800],
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: Colors.tealAccent,
              linearMinHeight: 8,
            ),
          ),
          themeMode: mode,
          initialRoute: '/',
          routes: {
            '/': (_) => HomePage(),
            '/quiz': (_) => QuizPage(),
            '/profile': (_) => ProfilePage(),
            '/history': (_) => HistoryPage(),
            '/settings': (_) => SettingsPage(),
          },
        );
      },
    );
  }
}