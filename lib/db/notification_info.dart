import 'package:hive/hive.dart';

part 'notification_info.g.dart';

@HiveType(typeId: 1)
class NotificationInfo {
  @HiveField(1)
  final String name;
  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final bool enabled;

  @HiveField(4)
  final int interval;

  NotificationInfo({
    required this.name,
    required this.dateTime,
    required this.enabled,
    required this.interval,
  });

  NotificationInfo copyWith(
      {String? name, DateTime? dateTime, bool? enabled, int? interval}) {
    return NotificationInfo(
        name: name ?? this.name,
        dateTime: dateTime ?? this.dateTime,
        enabled: enabled ?? this.enabled,
        interval: interval ?? this.interval);
  }
}
