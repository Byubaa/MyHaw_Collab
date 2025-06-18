import 'package:flutter/material.dart';

class HomeService {
  double saldo = 100000.0;
  double penghasilan = 0.0;
  double totalPengeluaran = 0.0;
  List<String> riwayatTransaksi = [];

  // Callback yang akan dipanggil saat saldo berubah
  // `VoidCallback` adalah alias untuk `void Function()`. Tanda '?' membuatnya nullable.
  VoidCallback? onSaldoChanged;

  void tambahSaldo(double jumlah) {
    saldo += jumlah;
    riwayatTransaksi.add('Isi saldo Rp${jumlah.toStringAsFixed(0)}');
    // Panggil callback jika tidak null
    onSaldoChanged?.call();
  }

  void beliPulsa(double nominal, String provider, String nomorHP, BuildContext context) {
    if (saldo >= nominal) {
      saldo -= nominal;
      penghasilan += nominal + 2000;
      totalPengeluaran += nominal;
      riwayatTransaksi.add('Pembelian pulsa Rp${nominal.toStringAsFixed(0)} untuk $nomorHP di $provider');
      onSaldoChanged?.call(); // Panggil callback
      _showDialog(context, 'Pembelian Pulsa Berhasil', 'Pulsa Rp${nominal.toStringAsFixed(0)} telah berhasil dikirim ke nomor $nomorHP.');
    } else {
      _showSnackbar(context, 'Saldo tidak mencukupi');
    }
  }

  void beliData(double nominal, String provider, String nomorHP, BuildContext context) {
    if (saldo >= nominal) {
      saldo -= nominal;
      penghasilan += nominal + 3000;
      totalPengeluaran += nominal;
      riwayatTransaksi.add('Pembelian data Rp${nominal.toStringAsFixed(0)} untuk $nomorHP di $provider');
      onSaldoChanged?.call(); // Panggil callback
      _showDialog(context, 'Pembelian Data Berhasil', 'Paket data Rp${nominal.toStringAsFixed(0)} telah berhasil dikirim ke nomor $nomorHP.');
    } else {
      _showSnackbar(context, 'Saldo tidak mencukupi');
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}