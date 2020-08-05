import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler{
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); // make it a static field of the class

  static void initNotification()
  {

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }

  }
  static Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {
    print(title+" "+body);
  }

}