import 'package:flutter/material.dart';
import 'views/auth/login_view.dart';
import 'views/operator/dashboard_kasir_view.dart';
import 'views/owner/dashboard_admin_view.dart';
void main() {
  runApp(const PhotoboxApp());
}

class PhotoboxApp extends StatelessWidget {
  const PhotoboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Operasional Photobox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      // Halaman pertama kali saat aplikasi dijalankan
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/operator-dashboard': (context) => const DashboardKasirView(),
        '/owner-dashboard': (context) => const DashboardAdminView(),
      },
    );
  }
}