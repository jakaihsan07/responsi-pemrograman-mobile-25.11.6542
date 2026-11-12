import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import '../widgets/profile_card.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';

/// Layar utama yang menampilkan profil ringkas, daftar catatan, dan data API publik.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _apiUsers = [];
  bool _isLoadingApi = false;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    _fetchPublicUsers();
  }

  /// Mengambil data pengguna publik menggunakan HTTP GET dengan error handling aman.
  Future<void> _fetchPublicUsers() async {
    setState(() {
      _isLoadingApi = true;
      _apiError = null;
    });
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/users'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          _apiUsers = jsonDecode(response.body);
          _isLoadingApi = false;
        });
      } else {
        setState(() {
          _apiError = 'Gagal memuat data (Status: ${response.statusCode})';
          _isLoadingApi = false;
        });
      }
    } on SocketException {
      debugPrint('HTTP Error: Tidak ada koneksi internet');
      setState(() {
        _apiError = 'Tidak ada koneksi internet';
        _isLoadingApi = false;
      });
    } on TimeoutException {
      debugPrint('HTTP Error: Koneksi timeout');
      setState(() {
        _apiError = 'Koneksi timeout';
        _isLoadingApi = false;
      });
    } catch (_) {
      debugPrint('HTTP Error: Terjadi kesalahan tidak terduga');
      setState(() {
        _apiError = 'Terjadi kesalahan saat memuat data';
        _isLoadingApi = false;
      });
    }
  }

  /// Menampilkan dialog konfirmasi sebelum menghapus catatan.
  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              AppProvider.of(context)!.deleteNote(id);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    if (provider == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang API',
            onPressed: _fetchPublicUsers,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil Mahasiswa',
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              if (updated == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil diperbarui')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileCard(student: provider.student),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Daftar Catatan Kuliah',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: provider.notes.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    itemCount: provider.notes.length,
                    itemBuilder: (ctx, i) => NoteCard(
                      note: provider.notes[i],
                      onDelete: () =>
                          _confirmDelete(context, provider.notes[i].id),
                    ),
                  ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Referensi Mahasiswa (HTTP GET)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: _isLoadingApi
                ? const Center(child: CircularProgressIndicator())
                : _apiError != null
                    ? Center(child: Text(_apiError!))
                    : ListView.builder(
                        itemCount: _apiUsers.length,
                        itemBuilder: (ctx, i) => ListTile(
                          dense: true,
                          leading: const Icon(Icons.account_circle_outlined),
                          title: Text(_apiUsers[i]['name'] ?? ''),
                          subtitle: Text(_apiUsers[i]['email'] ?? ''),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const NoteFormScreen()),
          );
          if (added == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Catatan berhasil ditambahkan')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}