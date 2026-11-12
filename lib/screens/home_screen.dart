import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/app_provider.dart';
import '../widgets/profile_card.dart';
import '../config/app_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _fetchData(BuildContext context) async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.baseUrl}/users'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil fetch ${data.length} data HTTP')));
      }
    } catch (e) {
      debugPrint('Error fetch aman (tanpa data sensitif)');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    if (provider == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        actions: [
          IconButton(icon: const Icon(Icons.cloud_download), onPressed: () => _fetchData(context)),
        ],
      ),
      body: Column(
        children: [
          ProfileCard(student: provider.student),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: provider.notes.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(provider.notes[i].title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.deleteNote(provider.notes[i].id),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Tambahkan navigasi form jika perlu
        child: const Icon(Icons.add),
      ),
    );
  }
}