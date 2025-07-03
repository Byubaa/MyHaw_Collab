import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  final List<String> riwayatTransaksi;

  const RiwayatScreen(this.riwayatTransaksi, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: riwayatTransaksi.isEmpty
          ? const Center(child: Text('Belum ada transaksi'))
          : ListView.builder(
        itemCount: riwayatTransaksi.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(riwayatTransaksi[index]),
          );
        },
      ),
    );
  }
}
