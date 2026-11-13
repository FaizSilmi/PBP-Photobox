import 'package:flutter/material.dart';

class PosKasirView extends StatefulWidget {
  const PosKasirView({super.key});

  @override
  State<PosKasirView> createState() => _PosKasirViewState();
}

class _PosKasirViewState extends State<PosKasirView> {
  final List _daftarPaket = [
    {'id': 1, 'nama': 'Paket Hemat (1 Lembar)', 'harga': 25000},
    {'id': 2, 'nama': 'Paket Premium (2 Lembar + Frame)', 'harga': 45000},
    {'id': 3, 'nama': 'Paket Group / Rombongan (4 Lembar)', 'harga': 80000},
  ];

  Map? _selectedPaket;
  String _metodeBayar = 'Cash';
  final TextEditingController _bayarController = TextEditingController();

  void _prosesTransaksi() {
    if (_selectedPaket == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih paket foto terlebih dahulu!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    double hargaPaket = (_selectedPaket!['harga'] as num).toDouble();
    double bayar = double.tryParse(_bayarController.text) ?? 0;

    if (_metodeBayar == 'Cash' && bayar < hargaPaket) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uang tunai kurang dari total harga paket!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Transaksi Berhasil'),
        content: Text(
          'Paket: ${_selectedPaket!['nama']}\n'
          'Metode: $_metodeBayar\n'
          'Total: Rp $hargaPaket\n\n'
          'Data transaksi tersimpan & stok bahan dikurangi otomatis.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
            onPressed: () {
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('POS Kasir - Transaksi Photobox', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sisi Kiri: Pilihan Paket Foto
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Paket Foto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _daftarPaket.length,
                      itemBuilder: (context, index) {
                        final paket = _daftarPaket[index];
                        bool isSelected = _selectedPaket == paket;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            title: Text(
                              paket['nama'],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            subtitle: Text('Rp ${paket['harga']}', style: TextStyle(color: Colors.blueAccent.shade700, fontWeight: FontWeight.w600)),
                            trailing: Radio(
                              value: paket,
                              groupValue: _selectedPaket,
                              activeColor: Colors.blueAccent,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaket = value as Map?;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _selectedPaket = paket;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            
            // Sisi Kanan: Ringkasan & Pembayaran
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Pembayaran',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const Divider(height: 32),
                    Text(
                      'Paket Dipilih:',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedPaket != null ? _selectedPaket!['nama'] : 'Belum dipilih',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Total Harga:',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${_selectedPaket != null ? _selectedPaket!['harga'] : 0}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Cash'),
                            value: 'Cash',
                            groupValue: _metodeBayar,
                            activeColor: Colors.blueAccent,
                            onChanged: (val) => setState(() => _metodeBayar = val.toString()),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('QRIS'),
                            value: 'QRIS',
                            groupValue: _metodeBayar,
                            activeColor: Colors.blueAccent,
                            onChanged: (val) => setState(() => _metodeBayar = val.toString()),
                          ),
                        ),
                      ],
                    ),
                    if (_metodeBayar == 'Cash') ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _bayarController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Uang Tunai Diterima (Rp)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _prosesTransaksi,
                        child: const Text(
                          'Proses Transaksi & Cetak',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}