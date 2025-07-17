// lib/screens/pembukuan_screen.dart

import 'package:flutter/material.dart';

class PembukuanScreen extends StatefulWidget {
  final double pemasukan;
  final double pengeluaran;
  final List<String> riwayatIsiSaldo;

  const PembukuanScreen({
    super.key,
    required this.pemasukan,
    required this.pengeluaran,
    required this.riwayatIsiSaldo,
  });

  @override
  PembukuanScreenState createState() => PembukuanScreenState();
}

class PembukuanScreenState extends State<PembukuanScreen> {

  String _formatCurrency(double amount) {
    return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    double keuntungan = widget.pemasukan - widget.pengeluaran;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Keuangan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ✅ PERUBAHAN UTAMA: Menggunakan Row dan Expanded
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Pemasukan',
                    widget.pemasukan,
                    Icons.arrow_upward,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 10), // Spasi antar kartu
                Expanded(
                  child: _buildSummaryCard(
                    'Pengeluaran',
                    widget.pengeluaran,
                    Icons.arrow_downward,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 10), // Spasi antar kartu
                Expanded(
                  child: _buildSummaryCard(
                    'Keuntungan',
                    keuntungan,
                    keuntungan >= 0 ? Icons.trending_up : Icons.trending_down,
                    keuntungan >= 0 ? Colors.blue : Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Detail Riwayat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: widget.riwayatIsiSaldo.isEmpty
                  ? const Center(child: Text('Belum ada riwayat transaksi.', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                itemCount: widget.riwayatIsiSaldo.length,
                itemBuilder: (context, index) {
                  final item = widget.riwayatIsiSaldo[index];
                  final isIncome = item.toLowerCase().contains('isi saldo');
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(
                        isIncome ? Icons.account_balance_wallet : Icons.shopping_cart,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text(item),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kartu ringkasan yang disesuaikan agar lebih kompak
  Widget _buildSummaryCard(String title, double amount, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.black87.withAlpha(200)),
            ),
            const SizedBox(height: 4),
            Text(
              _formatCurrency(amount),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}