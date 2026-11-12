import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository untuk mengelola penyimpanan metadata dan isi catatan kuliah.
class NoteRepository {
  static const String _notesKey = 'metadata_notes';
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Menyimpan daftar metadata catatan ke SharedPreferences sebagai JSON.
  Future<void> saveNoteMetadata(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _notesKey, jsonEncode(notes.map((n) => n.toJson()).toList()));
  }

  /// Memuat daftar metadata catatan dari SharedPreferences.
  Future<List<Note>> loadNoteMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_notesKey);
    if (data != null) {
      return (jsonDecode(data) as List).map((e) => Note.fromJson(e)).toList();
    }
    return [];
  }

  /// Menambahkan catatan baru: metadata ke SharedPreferences, isi ke SecureStorage.
  Future<void> addNote(Note note, List<Note> currentNotes) async {
    currentNotes.add(note);
    await saveNoteMetadata(currentNotes);
    await _secureStorage.saveContent(note.id, note.content ?? '');
  }

  /// Menghapus catatan beserta isi terenkripsinya
  Future<void> deleteNote(String noteId, List<Note> currentNotes) async {
    currentNotes.removeWhere((n) => n.id == noteId);
    await saveNoteMetadata(currentNotes);
    await _secureStorage.deleteContent(noteId);
  }
}