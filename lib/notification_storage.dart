import 'package:shared_preferences/shared_preferences.dart';

class NotificationStorage {
  static const String notificationKey = 'notifications';

  static Future<List<String>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList(notificationKey) ?? [];
    return notifications;
  }

  static Future<void> addNotification(String notificationText) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList(notificationKey) ?? [];
    notifications.add(notificationText);
    await prefs.setStringList(notificationKey, notifications);
  }
}
