import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('logo');
  void initializationNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    await flutterLocalNotificationPlugin.initialize(initializationSettings);
  }

  void sendNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
       const AndroidNotificationDetails('channelId', 'channelName', priority: Priority.high, importance: Importance.max);
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationPlugin.show(0, title, body, notificationDetails);
  }
}
