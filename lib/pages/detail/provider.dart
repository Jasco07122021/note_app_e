import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app_e/models/note_model.dart';
import 'package:note_app_e/services/firebase_database.dart';
import 'package:note_app_e/services/notification_firebase.dart';

class DetailProvider extends ChangeNotifier {
   TextEditingController titleController = TextEditingController();
   TextEditingController bodyController = TextEditingController();

  bool isLoading = false;

  saveNote() async {
    isLoading = true;
    notifyListeners();

    Note note = Note("", titleController.text, DateTime.now().toString(),
        bodyController.text);
    await FirestoreService.addNote(note).then((value) {
      isLoading = false;
      notifyListeners();

      NotificationService.POST(
        NotificationService.bodyNote(
          Hive.box("note").get("token"),
          ActionNotification.stored.name,
        ),
      );
    });
  }

}
