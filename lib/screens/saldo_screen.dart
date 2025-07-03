import 'package:flutter/material.dart';

class SaldoScreen extends StatelessWidget {
  final Function(double) tambahSaldo;
  final double currentAccountBalance;

  SaldoScreen(this.tambahSaldo, this.currentAccountBalance, {super.key});

  final TextEditingController _saldoController = TextEditingController();

  final List<double> _quickNominals = [50000, 100000, 200000, 500000];

  String _formatCurrency(double amount) {
    return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _showPurchaseConfirmation(BuildContext context, double nominal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Center(
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 70),
              SizedBox(height: 15),
              Text(
                'Isi Saldo Berhasil!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nominal Ditambahkan:',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    _formatCurrency(nominal),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  void _isiSaldo(BuildContext context, double nominal) {
    if (nominal >= 10000) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.wallet, color: Colors.purple),
                  title: const Text('E-Wallet', style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    tambahSaldo(nominal);
                    Navigator.pop(context); // Tutup bottom sheet
                    _showPurchaseConfirmation(context, nominal);
                  },
                ),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.account_balance, color: Colors.teal),
                  title: const Text('Bank Transfer', style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    tambahSaldo(nominal);
                    Navigator.pop(context); // Tutup bottom sheet
                    _showPurchaseConfirmation(context, nominal);
                  },
                ),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.qr_code, color: Colors.blue),
                  title: const Text('QRIS', style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    tambahSaldo(nominal);
                    Navigator.pop(context); // Tutup bottom sheet
                    _showPurchaseConfirmation(context, nominal);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nominal minimal adalah ${_formatCurrency(10000)}'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isi Saldo', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.blueAccent, size: 40),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo Anda Saat Ini',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        Text(
                          _formatCurrency(currentAccountBalance),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Masukkan Nominal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _saldoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minimal Rp10.000',
                prefixText: 'Rp',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 25),

            const Text(
              'Pilih Nominal Cepat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: _quickNominals.map((nominal) {
                return ActionChip(
                  label: Text(_formatCurrency(nominal)),
                  labelStyle: TextStyle(
                    color: _saldoController.text == nominal.toStringAsFixed(0) ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: _saldoController.text == nominal.toStringAsFixed(0) ? Colors.blue : Colors.blue.withAlpha(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: _saldoController.text == nominal.toStringAsFixed(0) ? Colors.blue : Colors.blue.withAlpha(100),
                    ),
                  ),
                  onPressed: () {
                    _saldoController.text = nominal.toStringAsFixed(0);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  double? jumlah = double.tryParse(_saldoController.text);
                  if (jumlah != null) {
                    _isiSaldo(context, jumlah);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Masukkan nominal yang valid'),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Lanjutkan Isi Saldo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}