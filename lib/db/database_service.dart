import 'package:hive_flutter/hive_flutter.dart';
import 'package:scheduled_notification/db/notification_info.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  Future<void> initialize() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
  }

  late Box<List<dynamic>> _infoBox;

  Future<void> _openBoxes() async {
    _infoBox = await Hive.openBox<List<dynamic>>('notifications');
  }

  void _registerAdapters() {
    Hive.registerAdapter(NotificationInfoAdapter());
  }

  List<NotificationInfo> getSavedNotifiation() {
    final savedReminders = _infoBox.get('id');
    return savedReminders?.cast<NotificationInfo>() ?? [];
  }

  Future<void> saveNotifications(List<NotificationInfo> notifications) async {
    List<dynamic> savedNotifications = getSavedNotifiation();
    savedNotifications.addAll(notifications);
    _infoBox.put('id', savedNotifications);
  }

  Future<void> updateNOfication(NotificationInfo info) async {
    List<NotificationInfo> svedNotification = getSavedNotifiation();
    List<NotificationInfo> updateNotification = List.from(svedNotification);
    int index = updateNotification
        .indexWhere((savedNotification) => savedNotification.name == info.name);
    if (index != -1) {
      updateNotification[index] =
          updateNotification[index].copyWith(enabled: info.enabled);
      _infoBox.put('id', updateNotification);
    }
  }

  Future<void> deleteNotification(NotificationInfo info) async {
    List<NotificationInfo> svedNotification = getSavedNotifiation();
    List<NotificationInfo> updateNotification = List.from(svedNotification);
    int index = updateNotification
        .indexWhere((savedNotification) => savedNotification.name == info.name);
    if (index != -1) {
      updateNotification.removeAt(index);
      _infoBox.put('id', updateNotification);
    }
  }
}
