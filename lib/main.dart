// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'services/home_screen_service.dart'; // Import HomeService

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider di sini hanya menyediakan HomeService karena UserProfileService
    // akan disediakan setelah login.
    return MultiProvider(
      providers: [
        Provider<HomeService>(
          create: (_) => HomeService(), // HomeService akan dibuat ulang saat MyApp di-rebuild
        ),
      ],
      child: MaterialApp(
        title: 'Aplikasi Pulsa & Data',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: const LoginScreen(), // Selalu mulai dari LoginScreen
        // Ketika logout, kita akan pushReplacement ke LoginScreen, membersihkan stack.
        // Karena LoginScreen adalah root baru, Providers sebelumnya akan hilang scope.
      ),
    );
  }
}