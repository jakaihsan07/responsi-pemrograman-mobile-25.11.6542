import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Kelas konfigurasi aplikasi yang memuat variabel dari file .env.
class AppConfig {
  /// Memuat file .env ke dalam environment aplikasi.
  static Future<void> load() async => await dotenv.load(fileName: ".env");

  /// Mendapatkan URL dasar API dari .env.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';

  /// Mendapatkan API Key dummy dari .env.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}