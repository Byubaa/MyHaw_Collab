import 'package:flutter/material.dart';
import 'package:myapp/screens/bantuan_screen.dart'; // dari branch try
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dari branch try

import 'screens/login_screen.dart';
import 'services/home_screen_service.dart';
import 'services/user_profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat file .env yang berisi GEMINI_API_KEY
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: 'https://cjzuefviqlrdnbzhhnmm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqenVlZnZpcWxyZG5iemhobm1tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAyOTkwNTEsImV4cCI6MjA2NTg3NTA1MX0.6Si01-85KV6A8lVeZqgLcOKAmoGj6DpxhbYyYa9PtE8',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        provider.Provider<HomeService>(
          create: (_) => HomeService(),
        ),
        provider.ChangeNotifierProvider<UserProfileService>(
          create: (_) => UserProfileService(
            initialEmail: '',
            initialName: '',
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Aplikasi Pulsa & Data',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
        routes: {
          '/register': (_) => const LoginScreen(),
          '/chat': (_) => const BantuanScreen(), // ✅ Tambahan dari try
        },
      ),
    );
  }
}
