import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/api_service.dart';

class DashboardAdminView extends StatefulWidget {
  const DashboardAdminView({super.key});

  @override
  State<DashboardAdminView> createState() => _DashboardAdminViewState();
}

class _DashboardAdminViewState extends State<DashboardAdminView> {
  bool _isLoading = true;
  Map<String, dynamic> _rekapTransaksi = {};
  Map<String, dynamic> _rekapPengeluaran = {};

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  // Fungsi mengambil rekap transaksi dan pengeluaran secara bersamaan
  Future<void> _fetchAllData() async {
    setState(() => _isLoading = true);
    
    final resTransaksi = await ApiService.getRekapTransaksi();
    final resPengeluaran = await ApiService.getRekapPengeluaran();

    setState(() {
      _rekapTransaksi = resTransaksi;
      _rekapPengeluaran = resPengeluaran;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List daftarTransaksi = _rekapTransaksi['data'] ?? [];
    double totalPendapatan = double.tryParse((_rekapTransaksi['total_pendapatan'] ?? 0).toString()) ?? 0;
    
    List daftarPengeluaran = _rekapPengeluaran['data'] ?? [];
    double totalPengeluaran = double.tryParse((_rekapPengeluaran['total_pengeluaran'] ?? 0).toString()) ?? 0;

    double pendapatanBersih = totalPendapatan - totalPengeluaran;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Dashboard Admin - Rekap Keuangan & Operasional', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Data',
              onPressed: _fetchAllData,
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              tooltip: 'Keluar',
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            const SizedBox(width: 12),
          ],
          bottom: const TabBar(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: 'Rekap Transaksi'),
              Tab(text: 'Pengeluaran Bahan'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu Statistik Utama
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Pendapatan', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 6),
                                Text('Rp ${totalPendapatan.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Pengeluaran', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 6),
                                Text('Rp ${totalPengeluaran.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pendapatan Bersih', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 6),
                                Text('Rp ${pendapatanBersih.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tab Isi Konten
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab 1: List Transaksi
                          daftarTransaksi.isEmpty
                              ? const Center(child: Text('Belum ada data transaksi tercatat.'))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: ListView.separated(
                                    itemCount: daftarTransaksi.length,
                                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                                    itemBuilder: (context, index) {
                                      final trx = daftarTransaksi[index];
                                      return ListTile(
                                        title: Text('Paket: ${trx['nama_paket'] ?? trx['paket'] ?? 'Fotobox'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        subtitle: Text('Metode: ${trx['metode_pembayaran'] ?? 'Cash'}'),
                                        trailing: Text('Rp ${trx['harga'] ?? trx['total_harga'] ?? '0'}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                                      );
                                    },
                                  ),
                                ),

                          // Tab 2: List Pengeluaran Bahan
                          daftarPengeluaran.isEmpty
                              ? const Center(child: Text('Belum ada catatan belanja bahan.'))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: ListView.separated(
                                    itemCount: daftarPengeluaran.length,
                                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                                    itemBuilder: (context, index) {
                                      final item = daftarPengeluaran[index];
                                      return ListTile(
                                        title: Text('Bahan: ${item['nama_bahan'] ?? item['keterangan'] ?? 'Belanja'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        subtitle: Text('Jumlah: ${item['jumlah'] ?? '-'} • Tanggal: ${item['tanggal'] ?? '-'}'),
                                        trailing: Text('Rp ${item['biaya'] ?? item['total'] ?? '0'}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}