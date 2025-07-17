// lib/screens/data_screen.dart

import 'package:flutter/material.dart';
import '../models/provider.dart';
import '../models/denomination.dart';

class DataScreen extends StatefulWidget {
  // Fungsi callback untuk dieksekusi saat pembelian terjadi
  final Function(double nominal, String provider, String nomorHP) beliData;

  const DataScreen(this.beliData, {super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final TextEditingController _nomorHpController = TextEditingController();

  static final List<Provider> providers = [
    Provider('Telkomsel', 'assets/images/telkomsel.png'),
    Provider('XL', 'assets/images/xl.png'),
    Provider('Axis', 'assets/images/axis.png'),
    Provider('IM3', 'assets/images/im3.png'),
    Provider('Smartfren', 'assets/images/smartfren.png'),
    Provider('Indosat', 'assets/images/Indosat.png'),
  ];

  static final List<Denomination> paketData = [
    Denomination(15000.0, '1 GB - Rp15.000'),
    Denomination(25000.0, '2 GB - Rp25.000'),
    Denomination(50000.0, '5 GB - Rp50.000'),
    Denomination(100000.0, '10 GB - Rp100.000'),
    Denomination(200000.0, '20 GB - Rp200.000'),
  ];

  void _pilihPaketData(BuildContext context, Provider provider) {
    String nomorHp = _nomorHpController.text;
    if (nomorHp.isEmpty || nomorHp.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor HP tidak valid. Mohon periksa kembali.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Pilih Paket Data untuk ${provider.name}'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: paketData.map((paket) => ListTile(
            title: Text(paket.label),
            onTap: () {
              Navigator.pop(dialogContext); // Tutup dialog pilihan
              widget.beliData(paket.amount, provider.name, nomorHp);
              _showPurchaseConfirmation(context, paket, nomorHp, provider.name);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showPurchaseConfirmation(BuildContext context, Denomination paket, String nomorHp, String provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 15),
            const Text('Pembelian Berhasil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.blue),
              title: const Text('Nomor HP'),
              subtitle: Text(nomorHp),
            ),
            ListTile(
              leading: const Icon(Icons.network_cell, color: Colors.blue),
              title: const Text('Provider'),
              subtitle: Text(provider),
            ),
            ListTile(
              leading: const Icon(Icons.data_saver_on, color: Colors.blue),
              title: const Text('Paket Data'),
              subtitle: Text(paket.label),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Menutup dialog
              Navigator.of(context).pop();     // Menutup halaman DataScreen, kembali ke Home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beli Paket Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nomor Tujuan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _nomorHpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Contoh: 081234567890',
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pilih Provider', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: providers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final provider = providers[index];
                return GestureDetector(
                  onTap: () => _pilihPaketData(context, provider),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(provider.imageAssetPath, height: 40, fit: BoxFit.contain),
                          const SizedBox(height: 8),
                          Text(provider.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}