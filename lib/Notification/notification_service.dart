import 'dart:convert';

import 'package:eyvo_inventory/Notification/Page/notification_page.dart';
import 'package:eyvo_inventory/app/app.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//This Method Handle Message in Background
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  LoggerData.dataPrint("Title : ${message.notification?.title}");
  LoggerData.dataPrint("Body : ${message.notification?.body}");
  LoggerData.dataPrint("PayLoad : ${message.data}");
}

class NotificationService {
  final firebasemessaging = FirebaseMessaging.instance;

  //local Notification Instance
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  // Important Method to Handle Notification For Android
  // 'high_importance_channel' is channel Id same as Android Menifest
  //Used For App in Forground
  final androidChannel = const AndroidNotificationChannel(
    'eyvo_inventory',
    'Eyvo Inventory Channel',
    description: 'this Channel used for important notification',
    importance: Importance.defaultImportance,
  );

  // Initialize notification
  Future<void> initNotification() async {
    //used For Show Permission PopUP
    await firebasemessaging.requestPermission();

    // Used For Get FCM token Which unique for Every User
    final fcmToken = await firebasemessaging.getToken();

    LoggerData.dataLog("FCM Token : $fcmToken");

    initPushNotification();

    // User For Handle Background Notification
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState!
        .pushNamed(NotificationPage.route, arguments: message);
  }

  //Initialization For Foreground Condition
  Future initLocalNotification() async {
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const settings = InitializationSettings(
      iOS: initializationSettingsDarwin,
      android:
          AndroidInitializationSettings('@drawable/ic_launcher_foreground'),
    );

    await flutterLocalNotificationPlugin.initialize(settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      LoggerData.dataPrint('notification payload: $payload');
    }
  }

  //Initialization For Background Condition
  Future initPushNotification() async {
    //Important Method For Set Alert, Badge, Sound
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // User For Handle Background Notification
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    //Listner When App is In Forground
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification == null) return;
      flutterLocalNotificationPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              icon: '@drawable/ic_launcher_foreground',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }
}
