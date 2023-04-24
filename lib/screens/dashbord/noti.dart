import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti{
  static Future intitialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    var androidInitialize = new AndroidInitializationSettings('minimap/ic_launcher');
    var initializationSettings = new InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  static Future showBigTextNotification({var id =0,required String title, required String body,
    var payload, required FlutterLocalNotificationsPlugin fln
  } ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    new AndroidNotificationDetails(
      'security_alert',
      'channel_name',
      'Alert Triggred',

      playSound: true,
      sound: RawResourceAndroidNotificationSound('newalert'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not= NotificationDetails(android: androidPlatformChannelSpecifics
    );
    await fln.show(0, title, body,not );
  }
}