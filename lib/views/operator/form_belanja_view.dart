import 'package:flutter/material.dart';

class FormBelanjaView extends StatefulWidget {
  const FormBelanjaView({super.key});

  @override
  State<FormBelanjaView> createState() => _FormBelanjaViewState();
}

class _FormBelanjaViewState extends State<FormBelanjaView> {
  String _selectedBahan = 'Kertas Foto';
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  final List<String> _pilihanBahan = [
    'Kertas Foto',
    'Tinta / Ribbon',
    'Lem / Aksesoris',
  ];

  void _simpanBelanja() {
    if (_jumlahController.text.isEmpty || _hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Belanja Berhasil Dicatat'),
        content: Text(
          'Bahan: $_selectedBahan\n'
          'Jumlah: ${_jumlahController.text}\n'
          'Total Biaya: Rp ${_hargaController.text}\n\n'
          'Stok inventaris bertambah & kas shift berkurang otomatis.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white),
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
        title: const Text('Form Belanja Bahan Operasional', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Center(
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Catat Pengeluaran Kasir / Belanja',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 6),
              Text(
                'Pembelian bahan habis pakai selama operasional shift',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _selectedBahan,
                decoration: InputDecoration(
                  labelText: 'Pilih Jenis Bahan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                items: _pilihanBahan.map((bahan) {
                  return DropdownMenuItem(value: bahan, child: Text(bahan));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedBahan = val!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _jumlahController,
                decoration: InputDecoration(
                  labelText: 'Jumlah Beli (Contoh: 2 Roll / 1 Box)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Harga / Biaya (Rp)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _simpanBelanja,
                  child: const Text(
                    'Simpan Log Belanja',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}