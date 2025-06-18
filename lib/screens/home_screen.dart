// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb

// Import dart:io HANYA jika bukan web.
// JIKA ANDA TIDAK MENGGUNAKAN UNTUK WEB, HAPUS SAJA 'if (!kIsWeb)'
// Tapi untuk cross-platform, ini lebih aman.
import 'dart:io' show File; // Import File dari dart:io secara eksplisit
// dan hanya jika bukan web.

import '../services/home_screen_service.dart';
import '../services/user_profile_service.dart';
import '../screens/saldo_screen.dart';
import '../screens/pulsa_screen.dart';
import '../screens/data_screen.dart';
import '../screens/riwayat_screen.dart';
import '../screens/pembukuan_screen.dart';
import '../screens/bantuan_screen.dart';
import '../screens/profil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final HomeService _homeService = HomeService();
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const BantuanScreen(),
    const ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? _HomeContent(homeService: _homeService)
          : _widgetOptions.elementAt(_selectedIndex - 1),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Bantuan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final HomeService homeService;

  const _HomeContent({required this.homeService});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  double _currentSaldo = 0.0;

  @override
  void initState() {
    super.initState();
    _currentSaldo = widget.homeService.saldo;
    widget.homeService.onSaldoChanged = () {
      setState(() {
        _currentSaldo = widget.homeService.saldo;
      });
    };
  }

  @override
  void dispose() {
    widget.homeService.onSaldoChanged = null;
    super.dispose();
  }

  String _formatCurrency(double amount) {
    return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileService>(
      builder: (context, userProfileService, child) {
        final user = userProfileService.userProfile;

        ImageProvider<Object>? profileImageProvider;
        if (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty) {
          // Selalu coba sebagai NetworkImage terlebih dahulu,
          // karena NetworkImage bisa menangani URL jaringan DAN blob: URL dari image_picker di web
          if (user.profilePictureUrl!.startsWith('http://') || user.profilePictureUrl!.startsWith('https://') || kIsWeb) {
            profileImageProvider = NetworkImage(user.profilePictureUrl!);
          } else {
            // Jika bukan web dan bukan URL jaringan, asumsikan ini adalah path file lokal
            // Pastikan import 'dart:io' ada di awal file
            try {
              final File imageFile = File(user.profilePictureUrl!);
              if (imageFile.existsSync()) {
                profileImageProvider = FileImage(imageFile);
              } else {
                profileImageProvider = null; // Fallback jika file tidak ditemukan
              }
            } catch (e) {
              // Tangani error jika path tidak valid atau ada masalah File
              profileImageProvider = null;
              debugPrint('Error loading local file image: $e');
            }
          }
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilScreen()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueGrey,
                      backgroundImage: profileImageProvider,
                      child: profileImageProvider == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saldo Anda',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(_currentSaldo),
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SaldoScreen(
                                    (jumlah) {
                                  widget.homeService.tambahSaldo(jumlah);
                                },
                                _currentSaldo,
                              )),
                            );
                          },
                          child: const Text('Isi Saldo', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _squareMenuButton(
                    context,
                    Icons.add,
                    'Tambah Transaksi',
                        () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc){
                            return SafeArea(
                              child: Wrap(
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.phone),
                                    title: const Text('Beli Pulsa'),
                                    onTap: () {
                                      Navigator.pop(bc);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => PulsaScreen((nominal, provider, nomorHP) {
                                          widget.homeService.beliPulsa(nominal, provider, nomorHP, context);
                                        })),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.data_usage),
                                    title: const Text('Beli Data'),
                                    onTap: () {
                                      Navigator.pop(bc);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => DataScreen((nominal, provider, nomorHP) {
                                          widget.homeService.beliData(nominal, provider, nomorHP, context);
                                        })),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                    },
                  ),
                  _squareMenuButton(
                    context,
                    Icons.receipt,
                    'Pengeluaran',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PembukuanScreen(
                            pemasukan: widget.homeService.penghasilan,
                            pengeluaran: widget.homeService.totalPengeluaran,
                            riwayatIsiSaldo: widget.homeService.riwayatTransaksi,
                          ),
                        ),
                      );
                    },
                  ),
                  _squareMenuButton(
                    context,
                    Icons.history,
                    'Riwayat',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RiwayatScreen(widget.homeService.riwayatTransaksi)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _squareMenuButton(BuildContext context, IconData icon, String label, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black54, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}