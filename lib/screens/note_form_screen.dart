import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({Key? key}) : super(key: key);
  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final cleanTitle = Validators.sanitize(_titleCtrl.text);
      
      final note = Note(id: DateTime.now().millisecondsSinceEpoch.toString(), title: cleanTitle, date: DateTime.now());
      AppProvider.of(context)!.addNote(note);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul'), validator: Validators.validateTitle),
              const SizedBox(height: 16),
              TextFormField(controller: _contentCtrl, decoration: const InputDecoration(labelText: 'Isi Catatan'), validator: Validators.validateContent, maxLines: 3),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _saveNote, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}