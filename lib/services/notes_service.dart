import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesService {
  static const _notesKey = 'my_notes';

  Future<List<Note>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_notesKey) ?? [];
    final notes = list.map((s) => Note.fromJson(jsonDecode(s))).toList();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<void> saveNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_notesKey) ?? [];
    list.add(jsonEncode(note.toJson()));
    await prefs.setStringList(_notesKey, list);
  }

  Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_notesKey) ?? [];
    final filtered = list.where((s) {
      final json = jsonDecode(s);
      return json['id'] != id;
    }).toList();
    await prefs.setStringList(_notesKey, filtered);
  }
}
