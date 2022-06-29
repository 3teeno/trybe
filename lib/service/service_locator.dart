import 'package:get_it/get_it.dart';

import 'MyService.dart';
import 'MyServiceImpl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


GetIt locator = GetIt.instance;
setupServiceLocator() {
  locator.registerLazySingleton<MyService>(() => MyServiceImpl());
}
showLocalNotifications(bool status,String message,String heading,int notificationId,int progressValue) async{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = new AndroidInitializationSettings('mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(android:initializationSettingsAndroid,iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
  });
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your channel id',
      'Download', 'Post Downloading',
      onlyAlertOnce: true,
      importance: Importance.max, priority: Priority.high,playSound: false,autoCancel: false,ongoing: status,progress: progressValue,
      maxProgress: 100,showProgress: status);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
  if(status==true){
    if (flutterLocalNotificationsPlugin != null) await flutterLocalNotificationsPlugin.show(notificationId,
      heading+" (${progressValue}%)",
      "",
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }else{
    if (flutterLocalNotificationsPlugin != null) await flutterLocalNotificationsPlugin.show(notificationId,
      heading,
      "",
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
showMessageNotifications(bool status,String message,String heading,int notificationId,int progressValue) async{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = new AndroidInitializationSettings('mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(android:initializationSettingsAndroid,iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
  });
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your channel id',
      'Download', 'Post Uploading',
      onlyAlertOnce: true,
      importance: Importance.max, priority: Priority.high,playSound: false,autoCancel: false,ongoing: status,progress: progressValue,
      maxProgress: 100,showProgress: status);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
  if(status==true){
    if (flutterLocalNotificationsPlugin != null) await flutterLocalNotificationsPlugin.show(notificationId,
      heading+" (${progressValue}%)",
      "",
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }else{
    if (flutterLocalNotificationsPlugin != null) await flutterLocalNotificationsPlugin.show(notificationId,
      heading,
      "",
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}