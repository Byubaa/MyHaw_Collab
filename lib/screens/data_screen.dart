import 'package:flutter/material.dart';
import '../models/provider.dart';
import '../models/denomination.dart';

class DataScreen extends StatelessWidget {
  final Function(double, String, String) beliData;

  DataScreen(this.beliData, {super.key});

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
    Denomination(15000.0, '1 GB - Rp15,000'),
    Denomination(25000.0, '2 GB - Rp25,000'),
    Denomination(50000.0, '5 GB - Rp50,000'),
    Denomination(100000.0, '10 GB - Rp100,000'),
    Denomination(200000.0, '20 GB - Rp200,000'),
  ];

  void _pilihPaketData(BuildContext context, Provider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Paket Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: paketData
              .map((paket) => ListTile(
                    title: Text(paket.label),
                    onTap: () => _inputNomorHP(context, provider, paket.amount),
                  ))
              .toList(),
        ),
      ),
    );
  }

void _inputNomorHP(BuildContext context, Provider provider, double nominal) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Masukkan Nomor HP'),
      content: TextField(
        controller: _nomorHpController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Nomor HP',
          hintText: 'Contoh: 081234567890',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String nomorHp = _nomorHpController.text;
            if (nomorHp.isEmpty) {
              // Jika nomor kosong
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nomor HP tidak boleh kosong')),
              );
            } else if (nomorHp.length < 12) {
              // Jika nomor kurang dari 12 angka
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nomor HP minimal 12 angka')),
              );
            } else {
              // Jika valid, proses pembelian
              beliData(nominal, provider.name, nomorHp);
              Navigator.pop(context); // Close input dialog
              _showPurchaseConfirmation(context, nominal, nomorHp, provider.name);
            }
          },
          child: const Text('Kirim'),
        ),
      ],
    ),
  );
}


void _showPurchaseConfirmation(
      BuildContext context, double nominal, String nomorHp, String provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembelian Berhasil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 20),
            const Text(
              'Paket data berhasil dibeli!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
              leading: const Icon(Icons.monetization_on, color: Colors.blue),
              title: const Text('Nominal'),
              subtitle: Text('Rp${nominal.toStringAsFixed(0)}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Pembelian Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: providers
              .map((provider) => ListTile(
                    leading: Image.asset(provider.imageAssetPath, width: 40, height: 40),
                    title: Text(provider.name),
                    onTap: () => _pilihPaketData(context, provider),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
