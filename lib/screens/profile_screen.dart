import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../models/student.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _nimCtrl, _prodiCtrl, _emailCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final student = AppProvider.of(context)!.student;
    _nameCtrl = TextEditingController(text: student.name);
    _nimCtrl = TextEditingController(text: student.nim);
    _prodiCtrl = TextEditingController(text: student.programStudi);
    _emailCtrl = TextEditingController(text: student.email);
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      AppProvider.of(context)!.updateStudent(Student(
        name: _nameCtrl.text, nim: _nimCtrl.text,
        programStudi: _prodiCtrl.text, email: _emailCtrl.text,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nama')),
              const SizedBox(height: 12),
              TextFormField(controller: _nimCtrl, decoration: const InputDecoration(labelText: 'NIM')),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _saveProfile, child: const Text('Simpan Profil')),
            ],
          ),
        ),
      ),
    );
  }
}