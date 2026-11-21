
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost/photobox_api';

  // LOGIN
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
      }

      return {
        'status': 'error',
        'message': 'Gagal terhubung (${response.statusCode})',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // GET PAKET FOTO
  static Future<List<dynamic>> getPaketFoto() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_paket.php'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return List<dynamic>.from(data['data'] ?? []);
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // CLOCK IN
  static Future<Map<String, dynamic>> clockIn(
    String operatorId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shift.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'start',
          'operator_id': operatorId,
        }),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
      }

      return {
        'status': 'error',
        'message': 'Gagal absen (${response.statusCode})',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // ALIAS MULAI SHIFT
  static Future<Map<String, dynamic>> mulaiShift(
    String operatorId,
  ) async {
    return clockIn(operatorId);
  }

  // REKAP TRANSAKSI
  static Future<Map<String, dynamic>> getRekapTransaksi() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_transaksi.php'),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
      }

      return {
        'status': 'error',
        'message': 'Gagal memuat transaksi (${response.statusCode})',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // REKAP PENGELUARAN
  static Future<Map<String, dynamic>> getRekapPengeluaran() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_pengeluaran.php'),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
      }

      return {
        'status': 'error',
        'message': 'Gagal memuat pengeluaran (${response.statusCode})',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // SIMPAN BELANJA
  static Future<Map<String, dynamic>> simpanBelanja({
    required String namaBahan,
    required String jumlah,
    required String biaya,
  })
   async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tambah_belanja.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_bahan': namaBahan,
          'jumlah': jumlah,
          'biaya': biaya,
        }),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
      }

      return {
        'status': 'error',
        'message': 'Gagal menyimpan belanja (${response.statusCode})',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // SIMPAN TRANSAKSI DARI POS KASIR
  static Future<Map<String, dynamic>> simpanTransaksi({
    required String namaPaket,
    required String harga,
    required String metodePembayaran,
    String? userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tambah_transaksi.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_paket': namaPaket,
          'harga': harga,
          'metode_pembayaran': metodePembayaran,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
      }

      return {
        'status': 'error',
        'message': 'Gagal menyimpan transaksi (${response.statusCode})',
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

// TAMBAH TRANSAKSI
static Future<Map<String, dynamic>> tambahTransaksi({
  required String namaPaket,
  required double harga,
  required String metodePembayaran,
  String? userId,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/tambah_transaksi.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nama_paket': namaPaket,
        'harga': harga,
        'metode_pembayaran': metodePembayaran,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    return {
      'status': 'error',
      'message': 'Gagal menghubungi server (${response.statusCode})',
    };
  } catch (e) {
    return {
      'status': 'error',
      'message': 'Terjadi kesalahan: $e',
    };
  }
}
}
