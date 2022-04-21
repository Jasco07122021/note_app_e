import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app_e/models/note_model.dart';

class FirestoreService {
  static final fireStore = FirebaseFirestore.instance;

  static String notesFolder = 'notes';

  static Future addNote(Note note) async {
    String noteId = fireStore.collection(notesFolder).doc().id;
    note.id = noteId;
    await fireStore.collection(notesFolder).doc(noteId).set(note.toJson());
    return note;
  }

  static Future deleteNote(String id) async {
    await fireStore.collection(notesFolder).doc(id).delete();
  }
}
