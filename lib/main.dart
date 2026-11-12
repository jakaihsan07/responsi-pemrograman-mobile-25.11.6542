import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'models/student.dart';
import 'models/note.dart';
import 'repositories/note_repository.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const MyApp());
}

class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  const AppProviderWrapper({Key? key, required this.child}) : super(key: key);
  @override
  _AppProviderWrapperState createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _repo = NoteRepository();
  List<Note> _notes = [];
  
  Student _student = Student(
    name: 'Muhammad Jaka Ihsan',
    nim: '25.11.6542',
    programStudi: 'S1 Informatika',
    email: 'jaka.ihsan@students.amikom.ac.id',
  );

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final notes = await _repo.loadNoteMetadata();
    setState(() => _notes = notes);
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      updateStudent: (s) => setState(() => _student = s),
      addNote: (n, c) async {
        await _repo.addNote(n, c, _notes);
        setState(() {});
      },
      deleteNote: (id) async {
        await _repo.deleteNote(id, _notes);
        setState(() {});
      },
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppProviderWrapper(
      child: MaterialApp(
        title: 'Profil & Catatan',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}