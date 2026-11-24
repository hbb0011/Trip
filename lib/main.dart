import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'data/destinations.dart';
import 'package:provider/provider.dart';
import 'providers/favoris_model.dart';
import 'providers/reglages_model.dart';
 
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FavorisModel()..charger(),
          child: const RihlaApp(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReglagesModel()..charger(),
        ),
      ],
      child: const RihlaApp(),
    )
  );
}

 
class RihlaApp extends StatelessWidget {
  const RihlaApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rihla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C86)),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E7C86),
          brightness: Brightness.dark,
        ),
      ),

      themeMode: context.watch<ReglagesModel>().sombre
      ? ThemeMode.dark
      : ThemeMode.light,

      home: const HomeScreen(),  
    );
    
  }
}
