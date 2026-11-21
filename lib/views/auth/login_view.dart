import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../operator/dashboard_kasir_view.dart';
import '../owner/dashboard_admin_view.dart'; // Sesuaikan jalur foldernya jika berbeda

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  
void _prosesLogin() async {
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  // Validasi input
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email dan password tidak boleh kosong!'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  // Debug untuk memeriksa apakah controller membaca input
  debugPrint('Email terbaca: $email');
  debugPrint('Password terbaca: ${password.isNotEmpty}');

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    debugPrint('Mengirim request login ke API...');

      final result = await ApiService.login(email, password)
          .timeout(const Duration(seconds: 15));

      debugPrint('Respons API: $result');

    if (!mounted) return;

    Navigator.pop(context);

    if (result['status'] == 'success') {
      final userData = result['data'];

      if (userData == null) {
        throw Exception('Data pengguna tidak ditemukan');
      }

      String role = userData['role'].toString();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login Berhasil! Selamat datang, ${userData['nama']}',
          ),
          backgroundColor: Colors.green,
        ),
      );

      if (role == 'owner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardAdminView(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardKasirView(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login gagal!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  } catch (e) {
    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terjadi kesalahan: $e'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                'Login Photobox',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 8),
              Text(
                'Silakan masuk menggunakan akun terdaftar',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: _prosesLogin,
                  child: const Text('Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}