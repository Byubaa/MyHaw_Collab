// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_profile_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Gunakan addPostFrameCallback untuk memastikan context sudah siap sebelum navigasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirect();
    });
  }

  Future<void> _redirect() async {
    // Beri sedikit waktu agar Supabase dan widget tree sepenuhnya siap
    await Future.delayed(Duration.zero);

    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // Jika ADA sesi, muat data profil pengguna terlebih dahulu
      await _loadUserProfile(session.user);
      if (!mounted) return;

      // Setelah data dimuat, baru navigasi ke HomeScreen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
    } else {
      // Jika TIDAK ada sesi, langsung ke LoginScreen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  Future<void> _loadUserProfile(User user) async {
    final profileService = context.read<UserProfileService>();

    // Set email dari data otentikasi yang sudah pasti ada
    profileService.setEmail(user.email!);

    try {
      final profileData = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle() as Map<String, dynamic>?;

      if (profileData != null) {
        // Jika data profil ada di database, gunakan itu
        profileService.setName(profileData['username'] as String? ?? user.email!.split('@')[0]);
        profileService.updateProfilePicture(profileData['avatar_url'] as String?);
      } else {
        // Fallback jika profil tidak ada di database (misal: user lama)
        profileService.setName(user.email!.split('@')[0]);
        profileService.updateProfilePicture(null);
      }
    } catch (e) {
      debugPrint("Error saat memuat profil di SplashScreen: $e");
      // Jika terjadi error, setidaknya nama & email tetap ada dari data otentikasi
      profileService.setName(user.email!.split('@')[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Selama proses pengecekan, tampilkan layar loading
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}