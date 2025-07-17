// lib/services/home_screen_service.dart

import 'package:flutter/material.dart';

class HomeService {
  double saldo = 0.0;
  double penghasilan = 0.0;
  double totalPengeluaran = 0.0;
  List<String> riwayatTransaksi = [];

  VoidCallback? onSaldoChanged;

  void tambahSaldo(double jumlah) {
    saldo += jumlah;
    riwayatTransaksi.add('Isi saldo Rp${jumlah.toStringAsFixed(0)}');
    onSaldoChanged?.call();
  }

  void beliPulsa(double nominal, String provider, String nomorHP, BuildContext context) {
    if (saldo >= nominal) {
      saldo -= nominal;
      penghasilan += nominal + 2000;
      totalPengeluaran += nominal;
      riwayatTransaksi.add('Pembelian pulsa Rp${nominal.toStringAsFixed(0)} untuk $nomorHP di $provider');
      onSaldoChanged?.call();
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
      onSaldoChanged?.call();
    } else {
      _showSnackbar(context, 'Saldo tidak mencukupi');
    }
  }

  // Fungsi _showDialog sudah dihapus dari sini

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}