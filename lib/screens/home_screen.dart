// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;
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
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    _HomeContent(homeService: HomeService()),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Bantuan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
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
      if (mounted) {
        setState(() {
          _currentSaldo = widget.homeService.saldo;
        });
      }
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
    final userProfileService = context.watch<UserProfileService>();
    final user = userProfileService.userProfile;

    ImageProvider<Object>? profileImageProvider;
    if (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty) {
      if (user.profilePictureUrl!.startsWith('http')) {
        profileImageProvider = NetworkImage(user.profilePictureUrl!);
      } else if (!kIsWeb) {
        try {
          final File imageFile = File(user.profilePictureUrl!);
          if (imageFile.existsSync()) {
            profileImageProvider = FileImage(imageFile);
          }
        } catch (e) {
          debugPrint('Error loading local file image: $e');
        }
      }
    }

    // ✅ INI SATU-SATUNYA PERUBAHAN: Menambahkan widget SafeArea
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: profileImageProvider,
                  child: profileImageProvider == null ? const Icon(Icons.person, color: Colors.white) : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(user.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                    const Text('Saldo Anda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(_formatCurrency(_currentSaldo), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SaldoScreen(widget.homeService.tambahSaldo, _currentSaldo)),
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
                _squareMenuButton(Icons.add, 'Tambah Transaksi', () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: const Text('Beli Pulsa'),
                              onTap: () {
                                Navigator.pop(bc);
                                Navigator.push(context, MaterialPageRoute(
                                  // ✅ Kode ini menjembatani fungsi agar tidak error
                                    builder: (_) => PulsaScreen(
                                          (nominal, provider, nomorHP) {
                                        widget.homeService.beliPulsa(nominal, provider, nomorHP, context);
                                      },
                                    )
                                ));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.data_usage),
                              title: const Text('Beli Data'),
                              onTap: () {
                                Navigator.pop(bc);
                                Navigator.push(context, MaterialPageRoute(
                                  // ✅ Kode ini menjembatani fungsi agar tidak error
                                    builder: (_) => DataScreen(
                                          (nominal, provider, nomorHP) {
                                        widget.homeService.beliData(nominal, provider, nomorHP, context);
                                      },
                                    )
                                ));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
                _squareMenuButton(Icons.receipt, 'Pengeluaran', () {
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
                }),
                _squareMenuButton(Icons.history, 'Riwayat', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RiwayatScreen(widget.homeService.riwayatTransaksi)));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _squareMenuButton(IconData icon, String label, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
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