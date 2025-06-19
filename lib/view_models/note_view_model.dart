import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/firestore_service.dart';

class NoteViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  Stream<List<Note>> get notes => _firestoreService.getNotes();
  Stream<bool> get allNotesChecked => notes.map(
    (noteList) => noteList.isNotEmpty && noteList.every((note) => note.checked),
  );

  Future<void> addNote(String title, String description, Color color) async {
    await _firestoreService.addNote(
      Note(
        id: '',
        title: title,
        description: description,
        checked: false,
        color: color,
      ),
    );
  }

  Future<void> updateNote(Note note) async {
    await _firestoreService.updateNote(note);
  }

  Future<void> deleteNote(String id) async {
    await _firestoreService.deleteNote(id);
  }
}
