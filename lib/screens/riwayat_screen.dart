// lib/screens/riwayat_screen.dart

import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  final List<String> riwayatTransaksi;

  const RiwayatScreen(this.riwayatTransaksi, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.blue,
      ),
      body: riwayatTransaksi.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada transaksi', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: riwayatTransaksi.length,
        itemBuilder: (context, index) {
          final item = riwayatTransaksi[index];

          IconData iconData;
          Color iconColor;

          if (item.toLowerCase().contains('pulsa')) {
            iconData = Icons.phone_android;
            iconColor = Colors.orange;
          } else if (item.toLowerCase().contains('data')) {
            iconData = Icons.wifi;
            iconColor = Colors.purple;
          } else if (item.toLowerCase().contains('isi saldo')) {
            iconData = Icons.account_balance_wallet;
            iconColor = Colors.green;
          } else {
            iconData = Icons.receipt_long;
            iconColor = Colors.blueGrey;
          }

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: CircleAvatar(
                // ✅ PERBAIKAN DI SINI
                backgroundColor: iconColor.withAlpha((255 * 0.1).round()), // Menggunakan .withAlpha
                child: Icon(iconData, color: iconColor),
              ),
              title: Text(
                item,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }
}