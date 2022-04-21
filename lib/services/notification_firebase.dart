import 'dart:convert';

import 'package:http/http.dart';

enum ActionNotification { stored, deleted }

class NotificationService {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "fcm.googleapis.com";
  static String SERVER_PRODUCTION = "fcm.googleapis.com";

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  static String API_SEND = '/fcm/send';

  static Map<String, String> headers = {
    'Authorization':
        'key=AAAAX8RGX9g:APA91bHcRdbXmmYFpChcArwnbHsBgKVN4JyJl9aKvBOfqVvcCxgvAtARslcQtxQFK8ryyh-UDWew6jN8cKGmWvebLyn5wQdlomJbLMBGx1mpP3UWnqcvtZcGKZNpsbKKdx6t5-jBv_3e',
    'Content-Type': 'application/json',
  };

  static Future<String?> POST(Map<String, dynamic> body) async {
    var uri = Uri.https(getServer(), API_SEND);
    var response = await post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Map<String, dynamic> bodyNote(String fcmToken, String action) {
    Map<String, dynamic> body = {};
    body.addAll({
      'notification': {'title': 'Notes App', 'body': 'Your note is $action !'},
      'registration_ids': [fcmToken],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return body;
  }
}
