import 'package:flutter/material.dart';
import 'pos_kasir_view.dart';
import 'form_belanja_view.dart';

class DashboardKasirView extends StatefulWidget {
  const DashboardKasirView({super.key});

  @override
  State<DashboardKasirView> createState() => _DashboardKasirViewState();
}

class _DashboardKasirViewState extends State<DashboardKasirView> {
  bool _isShiftAktif = false;
  String _waktuMulai = '-';

  void _mulaiShift() {
    setState(() {
      _isShiftAktif = true;
      final now = TimeOfDay.now();
      _waktuMulai = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shift berhasil dimulai! Clock-In tercatat.'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _selesaiShift() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Selesai Shift'),
        content: const Text('Apakah Anda yakin ingin mengakhiri shift dan menyerahkan rekap kasir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                _isShiftAktif = false;
                _waktuMulai = '-';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Shift ditutup. Clock-Out berhasil.')),
              );
            },
            child: const Text('Ya, Selesai Shift'),
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
        title: const Text('Dashboard Kasir - Studio Photobox', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Keluar',
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Shift Card yang Lebih Elegan
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isShiftAktif ? Colors.teal.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _isShiftAktif ? Icons.verified_user : Icons.hourglass_empty,
                          color: _isShiftAktif ? Colors.teal : Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isShiftAktif ? 'Status Shift: AKTIF' : 'Status Shift: BELUM MULAI',
                            style: TextStyle(
                              color: _isShiftAktif ? Colors.teal.shade700 : Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Operator: Dina  •  Mulai: $_waktuMulai',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _isShiftAktif
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red.shade700,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _selesaiShift,
                          icon: const Icon(Icons.timer_off, size: 18),
                          label: const Text('Selesai Shift', style: TextStyle(fontWeight: FontWeight.w600)),
                        )
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _mulaiShift,
                          icon: const Icon(Icons.timer, size: 18),
                          label: const Text('Mulai Shift (Clock-In)', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Menu Utama Kasir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 16),
            
            // Grid Menu Utama Operator yang Lebih Clean
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.6,
                children: [
                  buildMenuCard(
                    context,
                    'POS Kasir (Transaksi)',
                    'Layani pesanan & cetak nota',
                    Icons.point_of_sale_rounded,
                    Colors.blueAccent,
                    () {
                      if (!_isShiftAktif) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Silakan klik "Mulai Shift (Clock-In)" terlebih dahulu!')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PosKasirView()),
                      );
                    },
                  ),
                  buildMenuCard(
                    context,
                    'Catat Belanja Bahan',
                    'Input pengeluaran kertas/tinta',
                    Icons.shopping_cart_checkout_rounded,
                    Colors.orangeAccent,
                    () {
                      if (!_isShiftAktif) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Silakan klik "Mulai Shift (Clock-In)" terlebih dahulu!')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FormBelanjaView()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}