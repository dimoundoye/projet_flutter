import 'package:flutter/material.dart';
import 'models/repas.dart';
import 'screens/meal_list_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/meal_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaspillage Cantine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFFE65100),
          tertiary: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const MealListScreen(),
            );
          case '/detail':
            final repas = settings.arguments as Repas;
            return MaterialPageRoute(
              builder: (_) => MealDetailScreen(repas: repas),
            );
          case '/form':
            final repas = settings.arguments as Repas?;
            return MaterialPageRoute(
              builder: (_) => MealFormScreen(repas: repas),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const MealListScreen(),
            );
        }
      },
    );
  }
}
