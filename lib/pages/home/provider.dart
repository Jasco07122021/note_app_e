import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app_e/services/firebase_database.dart';
import 'package:note_app_e/services/notification_firebase.dart';

class HomeProvider extends ChangeNotifier {
  CollectionReference noteRef = FirebaseFirestore.instance.collection("notes");

  static deleteNote(String id) {
    FirestoreService.deleteNote(id);
    NotificationService.POST(
      NotificationService.bodyNote(
        Hive.box("note").get('token'),
        ActionNotification.deleted.name,
      ),
    );
  }
}
