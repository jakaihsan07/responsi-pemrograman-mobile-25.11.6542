import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

class NoteRepository {
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<void> saveNoteMetadata(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('metadata_notes', jsonEncode(notes.map((n) => n.toJson()).toList()));
  }

  Future<List<Note>> loadNoteMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('metadata_notes');
    if (data != null) return (jsonDecode(data) as List).map((e) => Note.fromJson(e)).toList();
    return [];
  }

  Future<void> addNote(Note note, String content, List<Note> currentNotes) async {
    currentNotes.add(note);
    await saveNoteMetadata(currentNotes);
    await _secureStorage.saveContent(note.id, content);
  }

  Future<void> deleteNote(String noteId, List<Note> currentNotes) async {
    currentNotes.removeWhere((n) => n.id == noteId);
    await saveNoteMetadata(currentNotes);
    await _secureStorage.deleteContent(noteId);
  }
}