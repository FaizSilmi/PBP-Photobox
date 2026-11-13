import 'package:flutter/material.dart';

class PenggajianView extends StatefulWidget {
  const PenggajianView({super.key});

  @override
  State<PenggajianView> createState() => _PenggajianViewState();
}

class _PenggajianViewState extends State<PenggajianView> {
  final List _daftarKaryawan = [
    {'id': 1, 'nama': 'Dina (Operator Shift Pagi)', 'total_shift': 12, 'tarif_per_shift': 50000},
    {'id': 2, 'nama': 'Rizal (Operator Shift Malam)', 'total_shift': 10, 'tarif_per_shift': 50000},
  ];

  Map? _selectedKaryawan;
  final TextEditingController _bonusController = TextEditingController(text: '0');

  void _hitungDanCetakGaji() {
    if (_selectedKaryawan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih nama karyawan terlebih dahulu!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    double gajiPokok = (_selectedKaryawan!['total_shift'] * _selectedKaryawan!['tarif_per_shift']).toDouble();
    double bonus = double.tryParse(_bonusController.text) ?? 0;
    double totalGaji = gajiPokok + bonus;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Slip Gaji Karyawan'),
        content: Text(
          'Nama: ${_selectedKaryawan!['nama']}\n'
          'Total Shift: ${_selectedKaryawan!['total_shift']} Shift\n'
          'Gaji Pokok: Rp $gajiPokok\n'
          'Bonus / Lembur: Rp $bonus\n'
          '-----------------------------------\n'
          'TOTAL BERSIH: Rp $totalGaji\n\n'
          'Status Pembayaran: BERHASIL DITERBITKAN',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cetak / Selesai'),
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
        title: const Text('Modul Penggajian (Payroll) - Owner', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
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
            // Sisi Kiri: Daftar Karyawan
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Karyawan / Operator',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _daftarKaryawan.length,
                      itemBuilder: (context, index) {
                        final karyawan = _daftarKaryawan[index];
                        bool isSelected = _selectedKaryawan == karyawan;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? Colors.indigo : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            title: Text(
                              karyawan['nama'],
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            subtitle: Text('Akumulasi Shift: ${karyawan['total_shift']} Shift', style: TextStyle(color: Colors.grey.shade600)),
                            trailing: Radio(
                              value: karyawan,
                              groupValue: _selectedKaryawan,
                              activeColor: Colors.indigo,
                              onChanged: (value) {
                                setState(() {
                                  _selectedKaryawan = value as Map?;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                _selectedKaryawan = karyawan;
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
            
            // Sisi Kanan: Kalkulasi Gaji & Bonus
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
                      'Kalkulasi Rincian Gaji',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const Divider(height: 32),
                    Text(
                      'Karyawan:',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedKaryawan != null ? _selectedKaryawan!['nama'] : 'Belum dipilih',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tarif Dasar:',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${_selectedKaryawan != null ? _selectedKaryawan!['tarif_per_shift'] : 0} / shift',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _bonusController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Tambahan Bonus / Insentif (Rp)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _hitungDanCetakGaji,
                        child: const Text(
                          'Hitung & Cetak Slip Gaji',
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