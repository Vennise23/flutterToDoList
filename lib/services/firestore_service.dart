import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {
  final CollectionReference _notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  Stream<List<Note>> getNotes() {
    return _notes.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) =>
                    Note.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
    );
  }

  Future<void> addNote(Note note) {
    return _notes.add(note.toMap());
  }

  Future<void> updateNote(Note note) {
    return _notes.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String id) {
    return _notes.doc(id).delete();
  }
}
