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
  final TextEditingController _textController = TextEditingController();

  double get keuntungan => widget.pemasukan - widget.pengeluaran;

  void _addRiwayat(String isiSaldo) {
    setState(() {
      widget.riwayatIsiSaldo.add(isiSaldo);
    });
    Navigator.of(context).pop();
  }

  void _editRiwayat(int index, String updatedSaldo) {
    setState(() {
      widget.riwayatIsiSaldo[index] = updatedSaldo;
    });
    Navigator.of(context).pop();
  }

  void _deleteRiwayat(int index) {
    setState(() {
      widget.riwayatIsiSaldo.removeAt(index);
    });
  }

  void _showInputDialog({int? index}) {
    if (index != null) {
      _textController.text = widget.riwayatIsiSaldo[index];
    } else {
      _textController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Tambah Riwayat' : 'Edit Riwayat'),
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(hintText: 'Masukkan detail isi saldo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (index == null) {
                  _addRiwayat(_textController.text);
                } else {
                  _editRiwayat(index, _textController.text);
                }
              }
            },
            child: Text(index == null ? 'Tambah' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembukuan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekapitulasi Keuangan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.green),
                title: const Text('Total Pemasukan'),
                subtitle: Text('Rp${widget.pemasukan.toStringAsFixed(0)}'),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.trending_down, color: Colors.red),
                title: const Text('Total Pengeluaran'),
                subtitle: Text('Rp${widget.pengeluaran.toStringAsFixed(0)}'),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Icon(
                  keuntungan >= 0 ? Icons.attach_money : Icons.money_off,
                  color: keuntungan >= 0 ? Colors.green : Colors.red,
                ),
                title: const Text('Keuntungan'),
                subtitle: Text(
                  'Rp${keuntungan.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: keuntungan >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Isi Saldo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: () => _showInputDialog(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.riwayatIsiSaldo.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
                    title: Text(widget.riwayatIsiSaldo[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showInputDialog(index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRiwayat(index),
                        ),
                      ],
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
}
