import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Initialize the notification plugin
Future<void> initializeNotifications() async {
  // iOS-specific settings
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // Android-specific settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Combine both platforms
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        onNotificationResponse, // Optional callback for notification interaction
  );
}

/// Callback for when a notification is received on iOS
Future<void> onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // Handle iOS notification received while the app is in the foreground
  log('Notification Received: $title $body $payload');
}

/// Callback for when a notification is tapped
Future<void> onNotificationResponse(NotificationResponse response) async {
  // Handle notification tap action
  log('Notification Tapped: ${response.payload}');
}

/// Schedule daily notifications starting from the specified date (excluding the day it is set)
Future<void> scheduleDailyNotificationFromDate(DateTime startDate, String title,
    String body, DateTime notificationTime) async {
  // Initialize time zones
  tz.initializeTimeZones();

  // Convert notification time to a DateTime in the desired timezone

  // Ensure the start date does not schedule notifications today
  final tz.TZDateTime firstNotificationDate =
      tz.TZDateTime(tz.local, startDate.year, startDate.month, startDate.day)
          .add(const Duration(days: 1)) // Start from the next day
          .add(Duration(
              hours: notificationTime.hour, minutes: notificationTime.minute));

  // Schedule a repeating daily notification from the next day
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Notification ID
    title, // Notification Title
    body, // Notification Body
    firstNotificationDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id', // Channel ID
        'Daily Notifications', // Channel Name
        channelDescription: 'Daily notifications starting from a specific date',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle, // Use the exact mode
    matchDateTimeComponents: DateTimeComponents.time, // Daily at the same time
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> scheduleNotificationsEveryXDays(DateTime startDate, String title,
    String body, int repeatCount, int daysCount) async {
  // Initialize time zones
  tz.initializeTimeZones();

  // Calculate the first notification time
  tz.TZDateTime notificationTime = tz.TZDateTime(
    tz.local,
    startDate.year,
    startDate.month,
    startDate.day,
    startDate.hour,
    startDate.minute,
  );

  for (int i = 0; i < repeatCount; i++) {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      i, // Unique ID for each notification
      title, // Notification Title
      body, // Notification Body
      notificationTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'custom_interval_channel', // Channel ID
          'Custom Interval Notifications', // Channel Name
          channelDescription: 'Notifications at custom intervals',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Move the notification time forward by 18 days
    notificationTime = notificationTime.add(Duration(days: daysCount));
  }
}
